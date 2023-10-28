import 'dart:io';

import 'package:image_enum_list_generator/image_enum_list_generator.dart';

/// A main entrypoint of a CLI tool
void main(List<String> args) async {
  const configPath = 'image_enum_list_generator.yaml';
  if (FileSystemEntity.typeSync(configPath) == FileSystemEntityType.notFound) {
    // `image_enum_list_generator.yaml` does not exist
    print(
        'There is no `image_enum_list_generator.yaml` in your project\'s root directory. Please consult https://github.com/mariorefetto/image_enum_list_generator for more information regarding the configuration.');
    exit(2);
  }

  var org = FlutterImageEnumList.withConfigFile(configPath);

  int exitCode = 0;

  if (args.isNotEmpty) {
    String command = args[0];
    if (command == 'run') {
      exitCode = await org.run();
    } else if (command == 'watch') {
      exitCode = await org.watch();
    } else {
      print('`$command` is not a valid command.');
      exitCode = 2;
    }
  } else {
    exitCode = await org.run();
  }

  exit(exitCode);
}
