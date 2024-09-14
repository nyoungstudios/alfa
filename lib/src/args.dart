import 'package:args/args.dart';

void printUsageMsg(ArgParser ap, String name, String msg) {
  print(msg);
  print('');
  print('Usage: $name [arguments]');
  print('');
  print('Options:');
  print(ap.usage);
}
