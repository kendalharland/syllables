import 'package:syllables/src/strings.dart';
import 'package:syllables/src/cmu_dict.dart';

/// Default dictionary.
final _dict = buildCmuDict();

/// Counts the syllables in [word].
///
/// If word contains spaces, the syllables for each actual word in [words] are
/// summed.
///
/// [overrides] can be used to manually specify syllable counts for words.  If
/// the syllables for a word cannot be computed, or if the word is in
/// [overrides], the override is used instead.
int countSyllables(String word, {Map<String, int> overrides: const {}}) {
  if (overrides.containsKey(word)) return overrides[word];

  var normalWord = word.toLowerCase().replaceAll(unallowedChars, ' ').trim();
  if (normalWord.contains(' ')) {
    var words = normalWord.split(' ')..removeWhere((w) => w.trim().isEmpty);
    return countSyllablesAll(words.toList(), overrides: overrides);
  } else {
    return _dict[normalWord] ?? 0;
  }
}

/// Counts the syllables of every word in [words].
///
/// See [countSyllables] for more details.
int countSyllablesAll(
  List<String> words, {
  Map<String, int> overrides: const {},
}) {
  return words.fold(
      0, (count, word) => count + countSyllables(word, overrides: overrides));
}
