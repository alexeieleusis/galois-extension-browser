import 'package:library/library.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    test('multiplication', () {
      final definition = new CyclicGaloisExtensionDefinition(6, 11, 10);
      final first = new CyclicGaloisExtensionElement(
          definition, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      final second = new CyclicGaloisExtensionElement(
          definition, [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]);
      final third = first * second;
      expect(third.values, [10, 8, 4, 3, 10, 8, 2, 8, 9, 10]);
    });

    test('sum', () {
      final definition = new CyclicGaloisExtensionDefinition(6, 11, 10);
      final first = new CyclicGaloisExtensionElement(
          definition, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      final second = new CyclicGaloisExtensionElement(
          definition, [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]);
      final third = first + second;
      expect(third.values, [9, 9, 9, 9, 9, 9, 9, 9, 9, 9]);
    });
  });
}
