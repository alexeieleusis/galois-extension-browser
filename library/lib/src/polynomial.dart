import 'dart:math';

import 'package:library/src/definitions.dart';
import 'package:shuttlecock/shuttlecock.dart';
import 'package:tuple/tuple.dart';

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

  int get degree => !isZero
      ? scalars.length - 1
      : throw new UnsupportedError(
          'polynomial zero does not have an associated degree');

  @override
  int get hashCode => scalars.toList().fold(0, (h, s) => h ^ s.hashCode);

  @override
  bool get isOne => scalars.length == 1 && scalars.single.isOne;

  @override
  bool get isZero => scalars.length == 1 && scalars.single.isZero;

  @override
  Polynomial<T> get one => new Polynomial([scalars.first.one]);

  @override
  Polynomial<T> get opposite => new Polynomial(scalars.map((s) => s.opposite));

  @override
  Polynomial<T> get zero => new Polynomial([scalars.first.zero]);

  Polynomial<T> operator %(Polynomial<T> divisor) =>
      longDivision(divisor).item2;

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
    if (isZero) {
      return other;
    } else if (other.isZero) {
      return this;
    }

    final thisScalars = scalars.toList();
    final otherScalars = other.scalars.toList();
    final newDegree = max(degree, other.degree);
    var newScalars = new List<T>(newDegree + 1);
    for (var i = 0; i <= newDegree; i++) {
      final scalar =
          (i < scalars.length ? thisScalars[i] : thisScalars.first.zero);
      final otherScalar =
          (i < otherScalars.length ? otherScalars[i] : otherScalars.first.zero);
      newScalars[i] = scalar + otherScalar;
    }

    // Degree might have decreased.
    newScalars = newScalars.reversed
        .skipWhile((s) => s.isZero)
        .toList()
        .reversed
        .toList();
    return new Polynomial(
        newScalars.isNotEmpty ? newScalars : [scalars.first.zero]);
  }

  @override
  bool operator ==(Object other) {
    if (!(identical(this, other) ||
        other is Polynomial &&
            (isZero && other.isZero || degree == other.degree))) {
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

  Tuple2<Polynomial<T>, Polynomial<T>> longDivision(Polynomial<T> divisor) {
    if (divisor.isZero) {
      throw new ArgumentError.value(divisor, 'division by zero');
    }

    var quotient = divisor.zero;
    var dividend = this;
    while (!dividend.isZero && dividend.degree >= divisor.degree) {
      final currentDegree = dividend.degree - divisor.degree;
      final currentFactorScalars =
          new List.filled(currentDegree + 1, divisor.scalars.first.zero);
      currentFactorScalars[currentDegree] =
          dividend.scalars.last * divisor.scalars.last.inverse;
      final currentFactor = new Polynomial(currentFactorScalars);
      final currentProduct = divisor * currentFactor;
      quotient += currentFactor;
      dividend = dividend + currentProduct.opposite;
    }

    return new Tuple2(quotient, dividend);
  }

  @override
  String toString() {
    final buffer = new StringBuffer();
    final list = scalars.toList();
    for (var i = 0; i < scalars.length; i++) {
      buffer.write('${list[i]} x^$i + ');
    }
    return buffer.toString().substring(0, buffer.length - 3);
  }

  Polynomial<T> operator ~/(Polynomial<T> divisor) =>
      longDivision(divisor).item1;
}
