import 'dart:math' as math;

import 'package:library/src/primes.dart';
import 'package:meta/meta.dart';

@immutable
class GaloisExtensionDefinition {
  final int generator;
  final int characteristic;
  final int degree;

  GaloisExtensionDefinition(this.generator, this.characteristic, this.degree) {
    if (!isPrime(characteristic)) {
      throw new ArgumentError.value(
          characteristic, 'characteristic', 'must be prime');
    }

    if (degree < 2) {
      throw new ArgumentError.value(degree, 'degree', 'must be greater than 1');
    }

    if (generator != generator % characteristic) {
      throw new ArgumentError.value(
          generator, 'generator', '0 <= generator < characteristic');
    }

    if (!isCyclicExtensionSeed(generator, degree, characteristic)) {
      throw new UnsupportedError('Combination of generator, degree and'
          ' characteristic are not supported.');
    }
  }

  @override
  int get hashCode =>
      generator.hashCode ^ characteristic.hashCode ^ degree.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GaloisExtensionDefinition &&
          runtimeType == other.runtimeType &&
          generator == other.generator &&
          characteristic == other.characteristic &&
          degree == other.degree;
}

@immutable
class GaloisExtensionElement {
  final GaloisExtensionDefinition definition;
  final Iterable<int> values;

  GaloisExtensionElement(this.definition, this.values) {
    // ignore: avoid_function_literals_in_foreach_calls
    values.forEach((v) {
      if (v != v % definition.characteristic) {
        throw new ArgumentError.value(
            values,
            'values',
            'All values should be in the [0, definition.degree) '
            'interval.');
      }
    });

    if (values.length != definition.degree) {
      throw new UnsupportedError('values should have length '
          'definition.degree');
    }
  }

  GaloisExtensionElement operator *(GaloisExtensionElement other) {
    if (other.definition != definition) {
      throw new ArgumentError.value(
          other, 'other', 'other must have the same definition');
    }

    final newValues = new Iterable.generate(definition.degree, (i) => 0)
        .toList(growable: false);
    final myValues = values.toList();
    final otherValues = other.values.toList();

    for (var i = 0; i < definition.degree; i++) {
      for (var j = 0; j < definition.degree; j++) {
        final exponent = (i + j) ~/ definition.degree;
        newValues[(i + j) % definition.degree] += myValues[i] *
            otherValues[j] *
            math.pow(definition.generator, exponent);
      }
    }

    for (var i = 0; i < definition.degree; i++) {
      newValues[i] = newValues[i] % definition.characteristic;
    }

    return new GaloisExtensionElement(definition, newValues);
  }

  GaloisExtensionElement operator +(GaloisExtensionElement other) {
    if (other.definition != definition) {
      throw new ArgumentError.value(
          other, 'other', 'other must have the same definition');
    }

    final newValues = new Iterable.generate(definition.degree, (i) => 0)
        .toList(growable: false);
    final myValues = values.toList();
    final otherValues = other.values.toList();
    for (var i = 0; i < definition.degree; i++) {
      newValues[i] = (myValues[i] + otherValues[i]) % definition.characteristic;
    }

    return new GaloisExtensionElement(definition, newValues);
  }

  @override
  String toString() => values.toList().toString();
}
