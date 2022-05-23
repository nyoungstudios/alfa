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
  // gets operating system
  var os_name = await check_os();
  print("Running alfa on ${os_name}");

  // loads config file
  var document = await TomlDocument.load('config.toml');
  var config = document.toMap();

  // var main = config['main'];
  // config.remove('main');
  
  // var title = main['title'];
  // print('Running "$title" config');

  // read config file

  // print('This is stuff: $config');

  // for (MapEntry e in config.entries) {
  //   print("Key ${e.key}, Value ${e.value}");
  // }

  // gets map for names to install functions
  var dictionary_file = await TomlDocument.load('dictionary.toml');
  var dictionary = dictionary_file.toMap();


  // get items to install
  var to_install = <String>{"vimrc"};

  for (String name in to_install) {
    await Process.run('/bin/bash', ['-euc', 'source functions.sh; ${dictionary[name]["install_function"]}'], runInShell: true).then((ProcessResult results) {
      // if results has standard out, print it
      if (!results.stdout.isEmpty) {
        stdout.write(results.stdout);
      }

      // if results has standard error, print it
      if (!results.stderr.isEmpty) {
        stderr.write(results.stderr);
      }
      
    });
  }

  print('This is dictionary: $dictionary');

}
