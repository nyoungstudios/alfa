import 'package:toml/toml.dart';

void main() async {
  var document = await TomlDocument.load('config.toml');
  var config = document.toMap();
  print('This is stuff: $config');

  var title = config['title'];

  print('$title');
}
