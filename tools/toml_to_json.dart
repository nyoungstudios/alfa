/// Converts a toml file to a json file.
import 'dart:convert';
import 'dart:io';

import 'package:toml/toml.dart';

void main(List<String> args) async {
  if (args.length != 2) {
    print('Usage: dart run tools/toml_to_json.dart input.toml output.json');
    exit(1);
  }
  final Map data = ((await TomlDocument.load(args[0])).toMap());
  await File(args[1]).writeAsString(jsonEncode(data));
}
