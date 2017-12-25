import 'dart:math' as math;

import 'package:shuttlecock/shuttlecock.dart';

IterableMonad<int> firstPrimes(int count) {
  final collection = <int>[];

  while (collection.length < count) {
    final lastKnownPrime = collection.isNotEmpty ? collection.last : 1;
    var next = lastKnownPrime + 1;
    while (!_isPrime(next, collection)) {
      next++;
    }
    collection.add(next);
  }

  return new IterableMonad.fromIterable(collection);
}

bool _isPrime(int next, List<int> collection) {
  int boundary = math.sqrt(next).floor();
  return !collection.where((p) => p <= boundary).any((p) => next % p == 0);
}
