// run with dart run alfa

import 'package:toml/toml.dart';

void main() async {
  var document = await TomlDocument.load('config.toml');
  var config = document.toMap();
  
  var title = config['main']['title'];
  print('Running "$title" config');

  print('This is stuff: $config');

}
