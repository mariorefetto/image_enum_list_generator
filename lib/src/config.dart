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

  static const String customClassName = 'ImageEnumList';
}

class Config {
  late String assetFolderPath;
  late String classFolderPath;
  late List<String> fileExtensions;
  late String customClassName;

  Config({
    this.assetFolderPath = DefaultConfig.assetFolderPath,
    this.classFolderPath = DefaultConfig.classFolderPath,
    this.fileExtensions = DefaultConfig.fileExtensions,
    this.customClassName = DefaultConfig.customClassName,
  });

  Config.fromFile(String filePath) {
    String yamlContent = File(filePath).readAsStringSync();
    YamlMap yamlMap = loadYaml(yamlContent);
    assetFolderPath = yamlMap['asset_folder_path'] ?? DefaultConfig.assetFolderPath;
    classFolderPath = yamlMap['class_folder_path'] ?? DefaultConfig.classFolderPath;
    customClassName = yamlMap['custom_class_name'] ?? DefaultConfig.customClassName;
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
