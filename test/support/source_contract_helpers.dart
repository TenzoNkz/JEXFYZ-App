/// Utilities for Dart source-contract tests.
///
/// Use these only for syntactic Dart fragments. Do not normalize user-facing copy,
/// protocol payloads, or persisted values where whitespace is semantically meaningful.
String compactDartSource(String source) =>
    source.replaceAll(RegExp(r'\s+'), '');

bool containsDartFragment(String source, String fragment) =>
    compactDartSource(source).contains(compactDartSource(fragment));

int indexOfDartFragment(String source, String fragment) =>
    compactDartSource(source).indexOf(compactDartSource(fragment));

int countDartFragments(String source, String fragment) {
  final haystack = compactDartSource(source);
  final needle = compactDartSource(fragment);
  if (needle.isEmpty) return 0;
  var count = 0;
  var offset = 0;
  while (true) {
    final index = haystack.indexOf(needle, offset);
    if (index < 0) return count;
    count++;
    offset = index + needle.length;
  }
}
