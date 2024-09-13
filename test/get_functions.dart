/// dart run test/get_functions.dart
/// gets functions to run tests for in Github Actions
import 'dart:convert';
import 'dart:io';

import 'package:alfa/src/args.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import 'package:toml/toml.dart';
import 'package:yaml_writer/yaml_writer.dart';

/// Filters out test key from Map.
Map filterTestKey(Map data) {
  data.removeWhere((key, value) => key == 'test');
  return data;
}

void main(List<String> args) async {
  // argument parser
  var parser = ArgParser();
  parser.addFlag('help',
      abbr: 'h', help: 'Print this usage information.', negatable: false);
  parser.addOption('output-filter',
      abbr: 'f', help: 'Filepath to save YAML paths filter data to.');
  parser.addOption('output-matrix',
      abbr: 'm', help: 'Filepath to save JSON GitHub Actions matrix data to.');

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
  } else if (argResults['output-filter'] == null) {
    printUsageMsg(parser, 'get_functions', 'Must pass an output filter file');
    exit(1);
  } else if (argResults['output-matrix'] == null) {
    printUsageMsg(parser, 'get_functions', 'Must pass an output matrix file');
    exit(1);
  }

  // iterates over functions directory and builds include list
  final functionsDir = Directory('functions');
  final testFunctionsDir = Directory('test/resources/functions');

  Map<String, List<String>> filters = {};
  List<Map<String, String>> include = [];

  await for (var entry in functionsDir.list()) {
    final String basename = p.basename(entry.path);
    final String basenamePath = p.join(testFunctionsDir.path, basename);
    final String runnersPath = p.join(basenamePath, 'runners.toml');
    final String testConfigPath = p.join(basenamePath, 'test_config.toml');

    if (await File(testConfigPath).exists() &&
        await File(runnersPath).exists()) {
      filters[basename] = [
        '${entry.path}/config.toml',
        '${entry.path}/install.sh',
        runnersPath,
        testConfigPath,
      ];
      final Map data = (await TomlDocument.load(runnersPath)).toMap();

      data['case'].forEach((runnerName, extraIncludes) {
        include.add({
          'name': basename,
          'runner-name': runnerName,
          ...filterTestKey(data['common']),
          ...filterTestKey(extraIncludes)
        });
      });
    }
  }

  final Map matrix = {'include': include};

  // writes output yaml filters file and json matrix file
  await File(argResults['output-filter'])
      .writeAsString(YamlWriter().write(filters));
  await File(argResults['output-matrix']).writeAsString(jsonEncode(matrix));
}
