import 'dart:math' as math;

import 'package:shuttlecock/shuttlecock.dart';

IterableMonad<Iterable<int>> buildAllSequences(int scalarCount, int length) {
  final seed = new IterableMonad.fromIterable(
      new Iterable.generate(scalarCount, (i) => [i]));
  return new Iterable.generate(length).fold<IterableMonad<List<int>>>(
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

bool _isPrime(int candidate, List<int> collection) {
  final boundary = math.sqrt(candidate).floor();
  return !collection.where((p) => p <= boundary).any((p) => candidate % p == 0);
}
