library image_enum_list_generator;

import 'dart:core';
import 'dart:io';

import 'package:image_enum_list_generator/src/string_extension.dart';
import 'package:path/path.dart' as p;
import 'package:watcher/watcher.dart';

import 'src/config.dart';

class FlutterImageEnumList {
  /// A configulation instance
  late Config config;

  /// A main constructor with a default configuration
  FlutterImageEnumList() {
    config = Config();
  }

  /// A named constructor that creates an instance with a config
  FlutterImageEnumList.withConfig({
    String assetFolderPath = DefaultConfig.assetFolderPath,
    String classFolderPath = DefaultConfig.classFolderPath,
    String startClassName = DefaultConfig.startClassName,
    List<String> fileExtensions = DefaultConfig.fileExtensions,
  }) {
    config = Config(
      assetFolderPath: assetFolderPath,
      classFolderPath: classFolderPath,
      startClassName: startClassName,
      fileExtensions: fileExtensions,
    );
  }

  /// A named constructor that creates an instance with a configPath provided
  FlutterImageEnumList.withConfigFile(String configPath) {
    config = Config.fromFile(configPath);
  }

  /// [For CLI] Organise image's file according to the setting in the config instance
  Future<int> run() async {
    int exitCode = 0;

    List<FileSystemEntity> entities =
        _getFileEntitiesInDirectory(config.assetFolderPath, config.fileExtensions);
    await writeListToFile(entities);

    return exitCode;
  }

  /// [For CLI] Watch and organise image's file according to the setting in the config instance
  Future<int> watch() async {
    int exitCode = 0;

    run();
    print('Watching...');

    var watcher = DirectoryWatcher(p.absolute(config.assetFolderPath));
    await for (var event in watcher.events) {
      if (event.type == ChangeType.ADD || event.type == ChangeType.MODIFY) {
        var f = File(event.path);
        print(f);
        if (_matchWithFileExtensions(f)) {
          run();
        }
      }
    }

    return exitCode;
  }

  Future<void> writeListToFile(List<FileSystemEntity> entities) async {
    String generatedFilePath = config.classFolderPath;
    Directory current = Directory.current;
    String fullDirectoryPath = '${current.path}/$generatedFilePath';

    await Directory(fullDirectoryPath).create(recursive: true);

    String fullFilePath = '$fullDirectoryPath/image_enum_list.dart';

    File file = await File(fullFilePath).create(recursive: true);
    String content = "class ImageEnumList {\n";
    content += "ImageEnumList._();";

    for (var entity in entities) {
      final String assetName = p.basenameWithoutExtension(entity.path);
      final String camelCaseAssetName = assetName.toCamelCase;
      final String asset = "static String get $camelCaseAssetName => '$assetName';\n";
      content += asset;
    }

    content += "}";
    await file.writeAsString(content);

    print('File image_enum_list_generator.dart creato con successo.');
  }

  /// Return a list of all files in the specific directory filtered by file extensions
  List<FileSystemEntity> _getFileEntitiesInDirectory(
      String directoryPath, List<String> fileExtensions) {
    var dir = Directory(directoryPath);
    return dir
        .listSync(recursive: false, followLinks: false)
        .where((el) => el is File && _matchWithFileExtensions(el))
        .toList();
  }

  /// Return true if this file should be organised (match with file extensions listed in the configulation)
  bool _matchWithFileExtensions(File file) {
    var fileExtensionsSet = Set.from(config.fileExtensions);
    return fileExtensionsSet.contains(p.extension(file.path));
  }

  String toCamelCase(String input) {
    return input.split('_').map((word) {
      if (word.isEmpty) {
        return '';
      }
      return word[0].toUpperCase() + word.substring(1);
    }).join('');
  }
}
