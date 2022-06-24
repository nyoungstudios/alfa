// run with dart run alfa
import 'dart:io';
import 'package:toml/toml.dart';
import 'package:args/args.dart';

Future<String> checkOs() async {
  var unameResults = await Process.run('uname', ['-s'], runInShell: true);
  if (unameResults.stdout.startsWith("Linux")) {
    return "linux";
  } else if (unameResults.stdout.startsWith("Darwin")) {
    return "macos";
  } else if (unameResults.stdout.startsWith("CYGWIN")) {
    return "cygwin";
  } else if (unameResults.stdout.startsWith("MINGW")) {
    return "mingw";
  } else {
    return "unknown";
  }
}

void printUsageMsg(ArgParser ap, String msg) {
    print(msg);
    print("");
    print("Usage: alfa [arguments]");
    print("");
    print("Options:");
    print(ap.usage);
}

void main(List<String> args) async {
  // argument parser
  var parser = ArgParser();
  parser.addFlag('help',
    abbr: 'h',
    help: "Print this usage information.",
    negatable: false);
  parser.addOption('config',
    abbr: 'c',
    help: "Config toml file with mappings of names to tags and options");
  parser.addOption('file',
    abbr: 'f',
    help: "Text file with items to install (names or tags");

  var argResults;

  try {
    argResults = parser.parse(args);
  } catch (e) {
    printUsageMsg(parser, e.toString());
    exit(1);
  }

  if (argResults['help']) {
    printUsageMsg(parser, "The alfa command-line utility");
    exit(0);
  } else if (argResults['config'] == null) {
    printUsageMsg(parser, "Must pass a config file");
    exit(1);
  } else if (argResults['file'] == null) {
    printUsageMsg(parser, "Must pass a text file with items to install");
    exit(1);
  }

  // gets operating system
  var osName = await checkOs();
  print("Running alfa on ${osName}");

  // loads config file which maps the install keys to the tags
  var configFile = await TomlDocument.load(argResults['config']);
  var config = configFile.toMap();

  // create a map of tag name to install keys
  Map<String, List<String>> tagToInstallKey = {};

  for (MapEntry e in config.entries) {
    for (String tag in e.value['tags']) {
      tagToInstallKey.putIfAbsent(tag, () => []).add(e.key);
    }
  }

  // stores an ordered set of the names of the things to install
  var namesToInstall = Set<String>();

  // reads input file
  List<String> lines = await new File(argResults['file']).readAsLines();

  for (String line in lines) {
    if (!line.startsWith("#") && !line.startsWith('//')) {
      // only continues if names to install that are not commented out
      if (tagToInstallKey.containsKey(line)) {
        namesToInstall.addAll(tagToInstallKey[line]);
      } else {
        namesToInstall.add(line);
      }
    }
  }

  print("");
  print("--------------------------------------------");
  print("These are the things that will be installed:");
  print(namesToInstall.join(', '));
  print("");
  print("--------------------------------------------");

  // gets map of names to install functions
  var dictionaryFile = await TomlDocument.load('dictionary.toml');
  var dictionary = dictionaryFile.toMap();

  for (String name in namesToInstall) {
    var baseName = name.split('+')[0];

    if (!dictionary.containsKey(baseName)) {
      print("dictionary.toml does not have a reference for \"${baseName}\" to install.");
      print("Installer exiting");
      exit(1);
    } else if (!config.containsKey(name)) {
      print("${argResults['config']} does not have a reference for \"${name}\" to install.");
      print("Installer exiting");
      exit(1);
    }
    var functionName = dictionary[baseName];

    // checks for the type, if it is not a String, then it is a Hashmap with os
    // specific installation methods
    if (functionName.runtimeType != String) {
      functionName = functionName[osName];
    }

    String command = 'source functions.sh; ${functionName}';

    // checks if there are any options to pass when installing this
    if (config[name].containsKey("options") &&
        config[name]["options"].isNotEmpty) {
      command += ' ${config[name]["options"].join(" ")}';
    }

    // executes shell command
    await Process.run('/bin/bash', ['-euc', command], runInShell: true)
        .then((ProcessResult results) {
      // if results has standard out, print it
      if (!results.stdout.isEmpty) {
        stdout.write(results.stdout);
      }

      // if results has standard error, print it
      if (!results.stderr.isEmpty) {
        stderr.write(results.stderr);
      }
    });
  }
}
