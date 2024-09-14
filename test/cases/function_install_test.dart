import 'dart:io';

import 'package:test/test.dart';
import 'package:toml/toml.dart';

/// Runs a command either on the GitHub actions runner or within the Docker
/// container.
///
/// The [executable] and [arguments] is the command to run and the arguments to
/// pass to the executable. These are taken from `Process.run`.
///
/// Returns an instance of `ProcessResult` where the stdout and stderr are
/// converted to strings with the trailing whitespace removed.
ProcessResult runCommand(String executable, List<String> arguments) {
  final String? testContainerName =
      Platform.environment['ALFA_TEST_CONTAINER_NAME'];
  ProcessResult result;
  if (testContainerName == null || testContainerName == '') {
    // runs command on machine
    result = Process.runSync(executable, arguments, runInShell: true);
  } else {
    // runs command on Docker container
    result = Process.runSync(
        'docker', ['exec', testContainerName, executable, ...arguments],
        runInShell: true);
  }

  // cleans output
  final String stdout = result.stdout.toString().trimRight();
  final String stderr = result.stderr.toString().trimRight();

  print('stdout: $stdout');
  print('stderr: $stderr');

  return ProcessResult(
    result.pid,
    result.exitCode,
    stdout,
    stderr,
  );
}

/// The parsed output of the alfa install command.
final class AlfaInstallOutput {
  /// The header text that is outputted. This either contains the argparse
  /// error message or which architecture the program is being run on.
  final String header;

  /// The list of names that the program is trying to install
  final List<String>? installNames;

  /// All the logs from running the various install scripts
  final String? logs;

  AlfaInstallOutput(this.header, this.installNames, this.logs);
}

/// Gets the logs and parses the logs from the `ALFA_INSTALL_LOG_FILEPATH`
/// environment variable.
///
/// Returns the parsed logs as an instance of `AlfaInstallOutput`.
AlfaInstallOutput getLogs() {
  final String installLogEnvName = 'ALFA_INSTALL_LOG_FILEPATH';
  final String? installLogFilepath = Platform.environment[installLogEnvName];

  if (installLogFilepath == null || installLogFilepath == '') {
    throw Exception('Environment variable $installLogEnvName is not set.');
  } else {
    final List<String> outputParts = File(installLogFilepath)
        .readAsStringSync()
        .split('--------------------------------------------');

    // parses install names from output
    List<String>? installNames;
    if (outputParts.length > 1) {
      final regex = RegExp(r'^.+:\s*(.*)\s*$', multiLine: true);
      installNames = regex.firstMatch(outputParts[1])?.group(1)?.split(', ');
    }

    String? logs;
    if (outputParts.length > 2) {
      logs = outputParts[2];
    }

    return AlfaInstallOutput(outputParts[0], installNames, logs);
  }
}

void main() async {
  test('install logs', () async {
    final String? functionName =
        Platform.environment['ALFA_TEST_FUNCTION_NAME'];
    final String? caseName = Platform.environment['ALFA_TEST_CASE_NAME'];
    final String runnersPath =
        'test/resources/functions/$functionName/runners.toml';
    if (await File(runnersPath).exists()) {
      final Map data = (await TomlDocument.load(runnersPath)).toMap();

      /// Gets test value at the specified [key].
      ///
      /// Tries to get the value with the runner name; otherwise, defaults to
      /// the common value.
      getTestValue(String key) {
        return data['case'][caseName]['test']?[key] ??
            data['common']?['test']?[key];
      }

      /// Runs checks based off of the install log output
      final List? assertInstallNames = getTestValue('assert-install-names');
      final List? assertLogContains = getTestValue('assert-log-contains');

      late final installLogs = getLogs();
      if (assertInstallNames != null) {
        expect(installLogs.installNames, assertInstallNames);
      }
      if (assertLogContains != null) {
        for (String logPart in assertLogContains) {
          expect(installLogs.logs, contains(logPart));
        }
      }

      /// Runs any other commands for additional testing
      final List<Map>? testCommands = getTestValue('commands');

      if (testCommands != null) {
        for (Map testCommand in testCommands) {
          final result = runCommand(
              testCommand['command'], testCommand['arguments'].cast<String>());

          final List<String> assertKeys = [
            'assert-stdout-equals',
            'assert-stderr-equals',
            'assert-stdout-contains',
            'assert-stderr-contains'
          ];

          for (String assertKey in assertKeys) {
            if (testCommand[assertKey] != null) {
              String output;
              if (assertKey.contains('stdout')) {
                output = result.stdout;
              } else {
                output = result.stderr;
              }

              if (assertKey.contains('equals')) {
                expect(output, equals(testCommand[assertKey]));
              } else {
                expect(output, contains(testCommand[assertKey]));
              }
            }
          }
        }
      }
    }
  });
}
