extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() =>
      replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');

  String get toCamelCase {
    List<String> words = split(RegExp(r'[_-]'));
    String camelCase = words.first.toLowerCase();
    for (int i = 1; i < words.length; i++) {
      camelCase += words[i].capitalize;
    }
    return camelCase;
  }

  String get capitalize => isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;
}
