import 'dart:io';

import 'package:test/test.dart';

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
  test('install _example 1', () async {
    final result = runCommand('echo', ['hi']);
    expect(result.stdout, 'hi');
  }, tags: ['linux-x86']);
  test('install _example 2', () async {
    final result = runCommand('echo', ['bye']);
    expect(result.stdout, 'bye');
  }, tags: ['linux-x86-docker']);

  test('install _example log 1', () async {
    final result = getLogs();
    expect(result.installNames,
        ['_example+setup', '_example', '_example+teardown']);
    expect(result.logs, contains('arg1\narg2'));
  }, tags: ['linux-x86-docker', 'linux-arm', 'macos-arm', 'macos-x86']);

  test('install _example log 2', () async {
    final result = getLogs();
    expect(result.installNames, [
      '_example+setup-special',
      '_example+special-install',
      '_example+teardown-special'
    ]);
    expect(result.logs, contains('special-install'));
  }, tags: ['linux-x86']);
}
