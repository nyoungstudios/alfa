import 'dart:io';

import 'package:test/test.dart';
import 'package:toml/toml.dart';

void main() async {
  test('test function schema', () async {
    final functionsDir = Directory('functions');

    // iterate over the folders in the functions folder
    await for (var entry in functionsDir.list()) {
      final configFile = File('${entry.path}/config.toml');
      final installFile = File('${entry.path}/install.sh');
      final readmeFile = File('${entry.path}/README.md');

      // check files exist
      expect(await configFile.exists(), true,
          reason: 'Config file does not exist: ${configFile.path}');
      expect(await installFile.exists(), true,
          reason: 'Install script file does not exist: ${installFile.path}');
      expect(await readmeFile.exists(), true,
          reason: 'Readme file does not exist: ${readmeFile.path}');

      // load config
      var configDocument = await TomlDocument.load(configFile.path);
      var config = configDocument.toMap();

      // expected function names to test
      Set expectedFunctionNames = {};

      bool hasInstallFunction = config.containsKey('install_function');
      if (hasInstallFunction) {
        expectedFunctionNames.add(config['install_function']);
      }

      if (config.containsKey('linux')) {
        var tempHasInstallFunction =
            config['linux'].containsKey('install_function');
        if (tempHasInstallFunction) {
          expectedFunctionNames.add(config['linux']['install_function']);
        }
        hasInstallFunction |= tempHasInstallFunction;
      }
      if (config.containsKey('macos')) {
        var tempHasInstallFunction =
            config['macos'].containsKey('install_function');
        if (tempHasInstallFunction) {
          expectedFunctionNames.add(config['macos']['install_function']);
        }
        hasInstallFunction |= tempHasInstallFunction;
      }

      // tests if config has at least one install_function key
      expect(hasInstallFunction, true,
          reason:
              'Config ${configFile.path} does not an "install_function" key.');

      var result = await Process.run(
          'bash', ['-c', 'source ${installFile.path}; declare -F'],
          runInShell: true);

      // gets actual function names
      Set functionNames = result.stdout.trim().split('\n').map((line) {
        var parts = line.split(' ');
        expect(parts.length == 3, true,
            reason:
                'There is not a valid function defined in ${installFile.path}');
        return parts[2];
      }).toSet();

      // tests if all the expected function names are in the actual function names
      Set functionDiff = expectedFunctionNames.difference(functionNames);
      expect(functionDiff.isEmpty, true,
          reason:
              'These expected functions ${functionDiff.toString()} are not defined in ${installFile.path}');
    }
  });
}
