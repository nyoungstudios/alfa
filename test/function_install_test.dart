import 'dart:io';

import 'package:test/test.dart';

final List<Map> runners = [
  {'os': 'ubuntu-22.04', 'image': 'phusion/baseimage:jammy-1.0.4'},
  {
    'os': 'ubuntu-22.04',
    'image': 'phusion/baseimage:jammy-1.0.4',
    'platform': 'linux/arm64'
  },
  {'os': 'macos-14'},
  {'os': 'macos-13'},
];

ProcessResult runCommand(String executable, List<String> arguments) {
  String? testContainerName = Platform.environment['TEST_CONTAINER_NAME'];
  ProcessResult result;
  if (testContainerName == null || testContainerName == '') {
    // runs command on machine
    result = Process.runSync(executable, arguments, runInShell: true);
  } else {
    // runs command on docker container
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

void main() async {
  test('test install _example install', () async {
    final result = runCommand('echo', ['hi']);
    expect(result.stdout, 'hi');
  });
  test('test install _example install 2', () async {
    final result = runCommand('echo', ['bye']);
    expect(result.stdout, 'bye');
  });
}
