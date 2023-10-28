import 'dart:io';

import 'package:yaml/yaml.dart';

class DefaultConfig {
  static const String assetFolderPath = 'assets/images';
  static const String classFolderPath = 'lib/generated';

  static const List<String> fileExtensions = [
    '.jpg',
    '.png',
    '.svg',
  ];

  static const String startClassName = 'IEL';
}

class Config {
  late String assetFolderPath;
  late String classFolderPath;
  late List<String> fileExtensions;
  late String startClassName;

  Config({
    this.assetFolderPath = DefaultConfig.assetFolderPath,
    this.classFolderPath = DefaultConfig.classFolderPath,
    this.fileExtensions = DefaultConfig.fileExtensions,
    this.startClassName = DefaultConfig.startClassName,
  }) {}

  Config.fromFile(String filePath) {
    String yamlContent = File(filePath).readAsStringSync();
    YamlMap yamlMap = loadYaml(yamlContent);
    assetFolderPath = yamlMap['asset_folder_path'] ?? DefaultConfig.assetFolderPath;
    classFolderPath = yamlMap['class_folder_path'] ?? DefaultConfig.classFolderPath;
    startClassName = yamlMap['start_class_name'] ?? DefaultConfig.startClassName;
    if (yamlMap['file_extensions'] is YamlList) {
      fileExtensions = _getListFromYamlList(yamlMap['file_extensions']);
    } else {
      fileExtensions = DefaultConfig.fileExtensions;
    }
  }

  List<String> _getListFromYamlList(YamlList yamlList) {
    List<String> list = [];
    var _list = yamlList.map((el) => el.toString()).toList();
    list.addAll(_list);
    return list;
  }
}
