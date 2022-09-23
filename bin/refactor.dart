// run with dart run refactor
import 'dart:io';
import 'package:toml/toml.dart';

void main(List<String> args) async {
  List<String> lines = await File('functions.sh').readAsLines();

  List<String> tomlLines = await File('dictionary.toml').readAsLines();

  // gets map of names to install functions
  var dictionaryFile = await TomlDocument.load('dictionary.toml');
  var dictionary = dictionaryFile.toMap();

  for (MapEntry e in dictionary.entries) {
    var directory =
        await Directory('functions/${e.key}').create(recursive: true);
    var result = await Process.run(
        "cp", ["docs/entries/${e.key}.md", "${directory.path}/README.md"],
        runInShell: true);

    String functionString = "";
    bool foundFunction = false;
    List<String> installFunctions = [];

    if (e.value.containsKey("install_function")) {
      installFunctions.add(e.value["install_function"]);
    } else {
      if (e.value.containsKey("macos")) {
        installFunctions.add(e.value["macos"]["install_function"]);
        if (e.value["macos"]["install_function"] == "install_anaconda3_macos") {
          installFunctions.add("install_anaconda3_common");
        }
      }
      if (e.value.containsKey("linux")) {
        installFunctions.add(e.value["linux"]["install_function"]);
      }
    }

    for (String installFunction in installFunctions) {
      for (String line in lines) {
        if (foundFunction && line.startsWith("}")) {
          functionString += line;
          foundFunction = false;
          break;
        } else if (foundFunction || line.startsWith("${installFunction}() {")) {
          if (!foundFunction && functionString.isNotEmpty) {
            functionString += '\n';
          }
          functionString += line + '\n';
          foundFunction = true;
        }
      }
      functionString += '\n';
    }
    functionString = "#!/bin/bash\n\n" + functionString;
    // print(functionString);
    String scriptPath = "${directory.path}/install.sh";
    var file = await File(scriptPath).writeAsString(functionString);
    var resultChmod =
        await Process.run("chmod", ["+x", scriptPath], runInShell: true);

    String tomlConfigString = "";
    bool foundName = false;
    for (String tomlLine in tomlLines) {
      if (foundName && tomlLine.isEmpty) {
        foundName = false;
        break;
      } else if (tomlLine == "[ ${e.key} ]") {
        foundName = true;
      } else if (foundName) {
        tomlConfigString += tomlLine + '\n';
      }
    }

    var fileConfig = await File("${directory.path}/config.toml")
        .writeAsString(tomlConfigString);
    // break;
  }
}
