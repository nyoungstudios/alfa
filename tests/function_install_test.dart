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
  if (testContainerName == null) {
    return await Process.run(executable, arguments, runInShell: true);
  } else {
    return await Process.run(
        'docker', ['exec', testContainerName, executable, ...arguments],
        runInShell: true);
  }
}

void main() async {
  test('test install _example install', () async {
    var result = await runCommand('echo', ['hi']);
    String output = result.stdout.toString().trimRight();
    print(output);
    expect(output, 'hi');
  });
  test('test install _example install 2', () async {
    var result = await runCommand('echo', ['bye']);
    String output = result.stdout.toString().trimRight();
    print(output);
    expect(output, 'bye');
  });
}
