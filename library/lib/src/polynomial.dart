import 'dart:math';

import 'package:library/src/definitions.dart';
import 'package:shuttlecock/shuttlecock.dart';

class Polynomial<T extends FieldScalar<T>> {
  final IterableMonad<T> scalars;

  Polynomial(Iterable<T> scalars)
      : scalars = new IterableMonad<T>.fromIterable(scalars) {
    if (scalars.isEmpty) {
      throw new ArgumentError.value(scalars, 'scalars should not be empty');
    }

    if (scalars.last.isZero) {
      throw new ArgumentError.value(scalars, 'last scalar should be non zero');
    }
  }

  int get degree => scalars.length - 1;

  Polynomial<T> operator *(Polynomial<T> other) {
    final thisScalars = scalars.toList();
    final otherScalars = other.scalars.toList();
    final newScalars = new Iterable.generate(
        degree + other.degree + 1, (_) => scalars.first.zero).toList();
    for (var i = 0; i < scalars.length; i++) {
      for (var j = 0; j < other.scalars.length; j++) {
        newScalars[i + j] += thisScalars[i] * otherScalars[j];
      }
    }

    return new Polynomial(newScalars);
  }

  Polynomial<T> operator +(Polynomial<T> other) {
    final thisScalars = scalars.toList();
    final otherScalars = other.scalars.toList();
    final newDegree = max(degree, other.degree);
    final newScalars = new List<T>(newDegree + 1);
    for (var i = 0; i <= newDegree; i++) {
      final scalar =
          (i < scalars.length ? thisScalars[i] : thisScalars.first.zero);
      final otherScalar =
          (i < otherScalars.length ? otherScalars[i] : otherScalars.first.zero);
      newScalars[i] = scalar + otherScalar;
    }

    return new Polynomial(newScalars);
  }
}
