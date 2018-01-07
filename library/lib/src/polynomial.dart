import 'dart:math';

import 'package:library/src/definitions.dart';
import 'package:shuttlecock/shuttlecock.dart';

class Polynomial<T extends FieldScalar<T>>
    extends RingWithOneScalar<Polynomial<T>> {
  final IterableMonad<T> scalars;

  Polynomial(Iterable<T> scalars)
      : scalars = new IterableMonad<T>.fromIterable(scalars) {
    if (scalars.isEmpty) {
      throw new ArgumentError.value(scalars, 'scalars should not be empty');
    }

    if (scalars.length > 1 && scalars.last.isZero) {
      throw new ArgumentError.value(scalars, 'last scalar should be non zero');
    }
  }

  int get degree => scalars.length - 1;

  @override
  int get hashCode => scalars.toList().fold(0, (h, s) => h ^ s.hashCode);

  @override
  bool get isOne => scalars.single.isOne;

  @override
  bool get isZero => scalars.single.isZero;

  @override
  Polynomial<T> get one => new Polynomial([scalars.first.one]);

  @override
  Polynomial<T> get opposite => new Polynomial(scalars.map((s) => s.opposite));

  @override
  Polynomial<T> get zero => new Polynomial([scalars.first.zero]);

  @override
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

  @override
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

  @override
  bool operator ==(Object other) {
    if (!(identical(this, other) ||
        other is Polynomial && degree == other.degree)) {
      return false;
    }

    // ignore: test_types_in_equals
    final otherScalars = (other as Polynomial).scalars.toList();
    final scalarsList = scalars.toList();
    for (var i = 0; i < scalars.length; i++) {
      if (scalarsList[i] != otherScalars[i]) {
        return false;
      }
    }

    return true;
  }
}
