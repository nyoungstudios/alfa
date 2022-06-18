// run with dart run alfa
import 'dart:io';
import 'package:toml/toml.dart';
import 'package:args/args.dart';


Future<String> check_os() async {
  var uname_results = await Process.run('uname', ['-s'], runInShell: true);
  if (uname_results.stdout.startsWith("Linux")) {
    return "linux";
  } else if (uname_results.stdout.startsWith("Darwin")) {
    return "macos";
  } else if (uname_results.stdout.startsWith("CYGWIN")) {
    return "cygwin";
  } else if (uname_results.stdout.startsWith("MINGW")) {
    return "mingw";
  } else {
    return "unknown";
  }
}

void main(List<String> args) async {
  // argument parser
  var parser = ArgParser();
  parser.addOption('file', abbr: 'f');

  var results = parser.parse(args);

  // gets operating system
  var os_name = await check_os();
  print("Running alfa on ${os_name}");

  // loads config file which maps the install keys to the tags
  var config_file = await TomlDocument.load('config.toml');
  var config = config_file.toMap();

  // create a map of tag name to install keys
  Map<String, List<String>> tag_to_install_key = {};

  for (MapEntry e in config.entries) {
    for (String tag in e.value['tags']) {
      tag_to_install_key.putIfAbsent(tag, () => []).add(e.key);
    }
  }

  // stores an ordered set of the names of the things to install
  var names_to_install = Set<String>();

  // reads input file
  List<String> lines = await new File(results['file']).readAsLines();

  for (String line in lines) {
    if (tag_to_install_key.containsKey(line)) {
      names_to_install.addAll(tag_to_install_key[line]);
    } else {
      names_to_install.add(line);
    }
  }

  print("");
  print("--------------------------------------------");
  print("These are the things that will be installed:");
  print(names_to_install.join(', '));
  print("");
  print("--------------------------------------------");

  // gets map of names to install functions
  var dictionary_file = await TomlDocument.load('dictionary.toml');
  var dictionary = dictionary_file.toMap();

  for (String name in names_to_install) {
    var function_name = dictionary[name];

    // checks for the type, if it is not a String, then it is a Hashmap with os specific installation methods
    if (function_name.runtimeType != String) {
      function_name = function_name[os_name];
    }

    String command = 'source functions.sh; ${function_name}';

    // checks if there are any options to pass when installing this
    if (config[name].containsKey("options") && config[name]["options"].isNotEmpty) {
      command += ' ${config[name]["options"].join(" ")}';
    }

    // executes shell command
    await Process.run('/bin/bash', ['-euc', command], runInShell: true).then((ProcessResult results) {
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
