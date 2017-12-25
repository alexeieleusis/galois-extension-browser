import 'package:library/src/primes.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    test('First Test', () {
      expect(firstPrimes(1), [2]);
      expect(firstPrimes(2), [2, 3]);
      expect(firstPrimes(3), [2, 3, 5]);
      expect(firstPrimes(4), [2, 3, 5, 7]);
      expect(firstPrimes(5), [2, 3, 5, 7, 11]);
    });
  });
}
