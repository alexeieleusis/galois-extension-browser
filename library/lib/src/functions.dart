import 'dart:math' as math;

import 'package:library/library.dart';
import 'package:shuttlecock/shuttlecock.dart';

IterableMonad<Iterable<int>> buildAllSequences(int scalarCount, int length) {
  final seed = new IterableMonad.fromIterable(
      new Iterable.generate(scalarCount, (i) => [i]));
  return new Iterable.generate(length - 1).fold<IterableMonad<List<int>>>(
      seed,
      (acc, _) => acc.flatMap((vector) => new IterableMonad.fromIterable(
          new Iterable.generate(
              scalarCount, (i) => vector.toList()..insertAll(0, [i])))));
}

IterableMonad<int> findConstantsForSeed(int power, int prime) =>
    new IterableMonad.fromIterable(new Iterable.generate(prime))
        .where((c) => isCyclicExtensionSeed(c, power, prime));

IterableMonad<int> findDivisors(int n) => new IterableMonad.fromIterable(
    new Iterable.generate(n - 1, (i) => i + 2).where((d) => n % d == 0));

Polynomial<PrimeFiniteFieldScalar> findIrreduciblePolynomial(
    int degree, int characteristic) {
  // TODO: This block is repeated with FiniteResidueFieldScalar.inverse.
  final polynomials = buildAllSequences(characteristic, degree + 1)
      .skip(1)
      .map((scalars) => scalars
          .toList()
          .reversed
          .skipWhile((s) => s == 0)
          .toList()
          .reversed
          .toList())
      .where((s) => 2 <= s.length)
      .map((s) => s.map((v) => new PrimeFiniteFieldScalar(v, characteristic)))
      .map((s) => new Polynomial(s))
      .toList();
  // TODO: Filter to the actual irreducibles.
  final irreducibles = polynomials.where((p) => p.degree < degree).toList();
  final candidates = polynomials.where((p) => p.degree == degree).toList();
  return candidates
      .firstWhere((s) => _isIrreducible(s, irreducibles, characteristic));
}

IterableMonad<int> findPrimesCongruentWithOne(int module, int count) {
  final collection = <int>[];
  var next = 2;
  while (collection.length < count) {
    if (next % module == 1 && isPrime(next)) {
      collection.add(next);
    }
    next++;
  }
  return new IterableMonad.fromIterable(collection);
}

IterableMonad<int> findRoots(int candidate, int power, int prime) =>
    new IterableMonad.fromIterable(new Iterable.generate(prime)
        .where((i) => math.pow(i, power) % prime == candidate));

IterableMonad<int> firstPrimes(int count) =>
    _addPrimesWhile((acc) => acc.length < count);

bool isCyclicExtensionSeed(int constant, int power, int prime) =>
    !findDivisors(power).any((d) => findRoots(constant, d, prime).isNotEmpty);

bool isPrime(int candidate) {
  if (candidate < 2) {
    return false;
  }

  final boundary = math.sqrt(candidate).floor();
  for (var i = 2; i <= boundary; i++) {
    if (candidate % i == 0) {
      return false;
    }
  }

  return true;
}

IterableMonad<int> primesLowerThan(int boundary) {
  final collection =
      _addPrimesWhile((acc) => acc.isEmpty || acc.last < boundary);
  return collection.take(collection.length - 1);
}

IterableMonad<int> _addPrimesWhile(bool lengthPredicate(Iterable<int> acc)) {
  final collection = <int>[];
  var next = 2;
  while (lengthPredicate(collection)) {
    if (_isPrime(next, collection)) {
      collection.add(next);
    }
    next++;
  }
  return new IterableMonad.fromIterable(collection);
}

bool _isIrreducible(Polynomial<PrimeFiniteFieldScalar> candidate,
    List<Polynomial<PrimeFiniteFieldScalar>> collection, int characteristic) {
  for (var degree = 1; degree < candidate.degree; degree++) {
    final leftFactors = collection.where((p) => p.degree == degree).toList();
    final rightFactors =
        collection.where((p) => p.degree == candidate.degree - degree).toList();
    final reduced = leftFactors.fold(
        false,
        (acc, l) =>
            rightFactors.fold(acc, (acc2, r) => acc2 || candidate == l * r));
    if (reduced) {
      return false;
    }
  }

  return true;
}

bool _isPrime(int candidate, List<int> collection) {
  final boundary = math.sqrt(candidate).floor();
  return !collection.where((p) => p <= boundary).any((p) => candidate % p == 0);
}
