/// run with dart run alfaa
import 'dart:io';

import 'package:alfa/src/args.dart';
import 'package:alfa/src/schema.dart';
import 'package:args/args.dart';
import 'package:json_schema/json_schema.dart';
import 'package:shlex/shlex.dart' as shlex;
import 'package:toml/toml.dart';

void main(List<String> args) async {
  // argument parser
  var parser = ArgParser();
  parser.addFlag('help',
      abbr: 'h', help: 'Print this usage information.', negatable: false);
  parser.addFlag('dry-run',
      abbr: 'n', help: 'Only prints what will be installed.', negatable: false);
  parser.addFlag('exit',
      abbr: 'e',
      help:
          'Will exit immediately if any of the commands run has a non-zero exit status.',
      negatable: false);
  parser.addMultiOption('config',
      abbr: 'c',
      help:
          'Config toml file with mappings of names to tags and options. Can pass multiple.');
  parser.addMultiOption('file',
      abbr: 'f',
      help:
          'Text file with items to install (names or tags). Can pass multiple.');
  parser.addFlag('run-zsh',
      abbr: 'r', help: 'Runs zsh at the end', negatable: false);

  late ArgResults argResults;

  try {
    argResults = parser.parse(args);
  } catch (e) {
    printUsageMsg(parser, 'alfa', e.toString());
    exit(1);
  }

  // checks required arguments
  if (argResults['help']) {
    printUsageMsg(parser, 'alfa', 'The alfa command-line utility');
    exit(0);
  } else if (argResults['config'].isEmpty) {
    printUsageMsg(parser, 'alfa', 'Must pass a config file');
    exit(1);
  } else if (argResults['file'].isEmpty) {
    printUsageMsg(
        parser, 'alfa', 'Must pass a text file with items to install');
    exit(1);
  }

  // gets environment variables
  String? user = Platform.environment['SUDO_USER'];
  String? alfaUser = Platform.environment['ALFA_USER'];
  String? alfaArch = Platform.environment['ALFA_ARCH'];
  if (user == 'root' && alfaUser != '') {
    user = alfaUser;
  }

  // gets operating system
  // valid options (linux, macos)
  var osName = Platform.operatingSystem;
  print('Running alfa on $osName $alfaArch');

  // loads config file which maps the install keys to the tags
  Map config = {};
  for (var configFilepath in argResults['config']) {
    var configFile = await TomlDocument.load(configFilepath);
    config.addAll(configFile.toMap());
  }

  // validates config.toml file
  final validationResults = JsonSchema.create(configSchema).validate(config);
  if (!validationResults.isValid) {
    print("${argResults['config']} is not formatted correctly.");
    for (var error in validationResults.errors) {
      print(error);
    }
    exit(1);
  }

  // create a map of tag name to install keys
  Map<String, List<String>> tagToInstallKey = {};

  config.forEach((key, value) {
    var tags = value['tags'];
    if (tags != null) {
      for (String tag in tags) {
        tagToInstallKey.putIfAbsent(tag, () => []).add(key);
      }
    }
  });

  // stores an ordered set of the names of the things to install
  var namesToInstall = <String>{};

  // reads input files
  List<String> lines = [];
  for (var file in argResults['file']) {
    lines.addAll(await File(file).readAsLines());
  }

  for (String line in lines) {
    line = line.trim();
    if (line.isNotEmpty && !line.startsWith('#') && !line.startsWith('//')) {
      // only continues if names to install that are not commented out
      if (tagToInstallKey.containsKey(line)) {
        namesToInstall.addAll(tagToInstallKey[line]!);
        // in the case where the tag and config name has the same name
        if (config.containsKey(line) &&
            await File("functions/${line.split('+')[0]}/install.sh").exists()) {
          namesToInstall.add(line);
        }
      } else {
        namesToInstall.add(line);
      }
    }
  }

  // for storing map of names to install functions
  Map<String, Map> dictionary = {};
  List<String> filteredNamesToInstall = [];

  // filters invalid names to install
  for (String name in namesToInstall) {
    var baseName = name.split('+')[0];

    String installScriptPath = 'functions/$baseName/install.sh';
    String configTomlPath = 'functions/$baseName/config.toml';
    File installScript = File(installScriptPath);
    File configToml = File(configTomlPath);

    if (!config.containsKey(name)) {
      print(
          '${argResults['config']} does not have a reference for "$name" to install.');
      print('Installer exiting');
      exit(1);
    } else if (!await installScript.exists()) {
      print(
          'Trying to install "$baseName", but install script "$installScriptPath" does not exist.');
      print('Installer exiting');
      exit(1);
    } else if (!await configToml.exists()) {
      print(
          'Trying to install "$baseName", but config "$configTomlPath" does not exist.');
      print('Installer exiting');
      exit(1);
    } else if (config[name].containsKey('os') &&
        !config[name]['os'].contains(osName)) {
      print(
          'Skipping install of "$name" since the operating system, $osName, is not in ${config[name]['os']}.');
    } else {
      var tempConfig = await TomlDocument.load(configTomlPath);
      dictionary[baseName] = tempConfig.toMap();
      if (!dictionary[baseName]!.containsKey('install_function') &&
          !dictionary[baseName]!.containsKey(osName)) {
        print(
            'Skipping install of "$name" since there is no install function for "$baseName" on operating system, $osName.');
      } else {
        filteredNamesToInstall.add(name);
      }
    }
  }

  print('');
  print('--------------------------------------------');
  print('These are the things that will be installed:');
  print(filteredNamesToInstall.join(', '));
  print('');
  print('--------------------------------------------');

  // exits if dry run is set to true
  if (argResults['dry-run']) {
    print('Exiting alfa, dry run mode enabled.');
    exit(0);
  }

  // sets executable
  String executable;
  if (user == null || user == 'root') {
    executable = '/bin/bash';
  } else {
    executable = 'sudo';
  }

  for (String name in filteredNamesToInstall) {
    var baseName = name.split('+')[0];
    var functionMap = dictionary[baseName]!;

    // if function map does not contain the install_function key, the install_function key should be nested within the os name key.
    if (!functionMap.containsKey('install_function')) {
      functionMap = functionMap[osName];
    }

    var functionName = functionMap['install_function'];

    String command = '';

    // checks if there are any environment variables to pass when installing this
    if (config[name].containsKey('env') && config[name]['env'].isNotEmpty) {
      config[name]['env'].forEach((key, value) {
        command += 'export $key=${shlex.quote(value.toString())}; ';
      });
    }

    command +=
        'source tools/download.sh; source functions/$baseName/install.sh; $functionName';

    // checks if there are any options to pass when installing this
    if (config[name].containsKey('options') &&
        config[name]['options'].isNotEmpty) {
      command +=
          ' ${config[name]["options"].map((option) => shlex.quote(option)).join(" ")}';
    }

    List<String> arguments = [];

    if (user != null && user != 'root') {
      if (!functionMap.containsKey('sudo') || !functionMap['sudo']) {
        // run in user mode
        arguments = ['-u', user];
      }

      arguments
          .addAll(['--preserve-env=ALFA_USER,ALFA_ARCH', '--', '/bin/bash']);
    }

    arguments.addAll(['-euc', command]);

    // executes shell command
    var streams = await Process.start(executable, arguments, runInShell: true)
        .then((process) {
      var outStream = stdout.addStream(process.stdout);
      var errStream = stderr.addStream(process.stderr);

      return [process.exitCode, outStream, errStream];
    });

    // waits for exit code
    var exitCode = await streams[0];

    // waits for process logs to finish
    await streams[1];
    await streams[2];

    // if running in strict mode and exit code is non-zero
    if (argResults['exit'] && exitCode != 0) {
      print('alfa exiting with code: $exitCode');
      exit(exitCode);
    }
  }
}
