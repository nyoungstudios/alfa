// run with dart run alfa
import 'dart:io';
import 'package:toml/toml.dart';


Future<String> check_os() async {
  var uname_results = await Process.run('uname', ['-s'], runInShell: true);
  if (uname_results.stdout.startsWith("Linux")) {
    return "linux";
  } else if (uname_results.stdout.startsWith("Darwin")) {
    return "macos";
  } else if (uname_results.stdout.startsWith("CYGWIN")) {
    return "cygwin";
  } else if (uname_results.stdout.startsWith("MINGW")) {
    return "mingw";
  } else {
    return "unknown";
  }
}

void main() async {
  var document = await TomlDocument.load('config.toml');
  var config = document.toMap();

  var main = config['main'];
  config.remove('main');
  
  var title = main['title'];
  print('Running "$title" config');

  print('This is stuff: $config');

  for (MapEntry e in config.entries) {
    print("Key ${e.key}, Value ${e.value}");
  }

// /bin/bash -euc "source functions.sh; $arg"
  // Process.run('/bin/bash', ['-euc', 'source functions.sh; check_os'], runInShell: true).then((ProcessResult results) {
  //   print(results.stdout);
  //   print(results.stderr);
  // });


  var os_name = await check_os();
  print(os_name);

}
