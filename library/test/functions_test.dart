import 'package:library/library.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    test('first primes', () {
      expect(firstPrimes(1), [2]);
      expect(firstPrimes(2), [2, 3]);
      expect(firstPrimes(3), [2, 3, 5]);
      expect(firstPrimes(4), [2, 3, 5, 7]);
      expect(firstPrimes(5), [2, 3, 5, 7, 11]);
    });

    test('primes lower than', () {
      expect(primesLowerThan(3), [2]);
      expect(primesLowerThan(4), [2, 3]);
      expect(primesLowerThan(6), [2, 3, 5]);
      expect(primesLowerThan(8), [2, 3, 5, 7]);
      expect(primesLowerThan(12), [2, 3, 5, 7, 11]);
    });

    test('primes lower than', () {
      expect(findPrimesCongruentWithOne(4, 3), [5, 13, 17]);
    });

    test('divisors', () {
      expect(findDivisors(36), [2, 3, 4, 6, 9, 12, 18, 36]);
    });

    test('divisors', () {
      expect(findRoots(5, 3, 13), [7, 8, 11]);
      expect(findRoots(2, 5, 41), []);
      expect(findRoots(3, 6, 7), []);
      expect(findRoots(3, 2, 7), []);
      expect(findRoots(3, 3, 7), []);
    });

    test('primitive root', () {
      expect(isCyclicExtensionSeed(2, 5, 41), true);
      expect(isCyclicExtensionSeed(3, 6, 7), true);
      expect(isCyclicExtensionSeed(0, 6, 7), false);
    });

    test('primitive root', () {
      expect(findConstantsForSeed(6, 7), [3, 5]);
      expect(findConstantsForSeed(10, 11), [2, 6, 7, 8]);
    });

    test('irreducible polynomial characteristic 2', () {
      final p = findIrreduciblePolynomial(2, 2);

      expect(p.scalars.map((s) => s.value), [1, 1, 1]);
    });

    test('irreducible polynomial characteristic 3', () {
      final p = findIrreduciblePolynomial(2, 3);

      expect(p.scalars.map((s) => s.value), [1, 0, 1]);
    });
  });
}
