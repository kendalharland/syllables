import 'dart:io';
import 'package:syllables/src/strings.dart';
import 'package:packages/packages.dart';

/// Builds a dictionary mapping words to syllable counts from src/data/cmudict*
Map<String, int> buildCmuDict() {
  var p = new Packages();
  var dictFile = new File(p
      .resolvePackageUri(Uri.parse('package:syllables/src/data/cmudict.0.7a'))
      .uri
      .path);
  var dict = _buildDictFromLines(dictFile.readAsLinesSync());
  return dict;
}

Map<String, int> _buildDictFromLines(List<String> dictLines) {
  final map = <String, int>{};

  for (var line in dictLines) {
    var parts = line.split('  ');
    var word = parts.first.toLowerCase();

    if (word.contains(unallowedChars)) {
      continue;
    }

    var sounds = parts.last.toLowerCase();
    var syllableCount =
        sounds.split(' ').where((sound) => 'aeiouy'.contains(sound[0])).length;

    if (sounds.startsWith('y')) {
      syllableCount -= 1;
    }

    word = word.replaceAll(unallowedChars, '');

    if (!map.containsKey(word)) {
      map[word] = syllableCount;
    }
  }
  return map;
}
