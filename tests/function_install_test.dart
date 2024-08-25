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

Future<ProcessResult> runCommand(
    String executable, List<String> arguments) async {
  String? testContainerName = Platform.environment['TEST_CONTAINER_NAME'];
  if (testContainerName == null || testContainerName == '') {
    return await Process.run(executable, arguments, runInShell: true);
  } else {
    final List<String> args = [
      'exec',
      testContainerName,
      executable,
      ...arguments
    ];
    print(args);
    return await Process.run('docker', args, runInShell: true);
  }
}

void main() async {
  test('test install _example install', () async {
    final result = await runCommand('echo', ['hi']);
    String output = result.stdout.toString().trimRight();
    String outputError = result.stderr.toString().trimRight();
    print(output);
    print('------');
    print(outputError);
    expect(output, 'hi');
  });
  test('test install _example install 2', () async {
    final result = await runCommand('echo', ['bye']);
    String output = result.stdout.toString().trimRight();
    String outputError = result.stderr.toString().trimRight();
    print(output);
    print('------');
    print(outputError);
    expect(output, 'bye');
  });
}
