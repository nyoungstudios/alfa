// dart run tests/get_functions.dart
// gets functions to run tests for in Github Actions
import 'dart:convert';
import 'dart:io';

import 'package:alfa/src/args.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;

void main(List<String> args) async {
  // argument parser
  var parser = ArgParser();
  parser.addFlag('help',
      abbr: 'h', help: 'Print this usage information.', negatable: false);
  parser.addOption('output',
      abbr: 'o', help: 'Filepath to save JSON GitHub Actions matrix data to.');

  late ArgResults argResults;

  try {
    argResults = parser.parse(args);
  } catch (e) {
    parser.usage;
    exit(1);
  }

  // checks required arguments
  if (argResults['help']) {
    printUsageMsg(parser, 'get_functions', 'The get_functions script');
    exit(0);
  } else if (argResults['output'] == null) {
    printUsageMsg(parser, 'get_functions', 'Must pass a output file');
    exit(1);
  }

  // iterates over functions directory and builds include list
  final functionsDir = Directory('functions');
  List<Map<String, String>> include = [];
  await for (var entry in functionsDir.list()) {
    if (!p.basename(entry.path).startsWith('_')) {
      include.add({'sourcePath': '${entry.path}/**'});
    }
  }

  Map matrix = {'include': include};

  // writes output json file
  await File(argResults['output']).writeAsString(jsonEncode(matrix));
}
