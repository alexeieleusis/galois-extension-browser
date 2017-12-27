import 'dart:math' as math;

import 'package:library/src/galois_extension_definition.dart';
import 'package:meta/meta.dart';

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

  @override
  int get hashCode => definition.hashCode ^ values.hashCode;

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
  bool operator ==(Object other) {
    if (!(identical(this, other) ||
        other is GaloisExtensionElement && definition == other.definition)) {
      return false;
    }

    final GaloisExtensionElement element = other;
    final myValues = values.toList();
    final otherValues = element.values.toList();
    for (var index = 0; index < myValues.length; index++) {
      if (myValues[index] != otherValues[index]) {
        return false;
      }
    }
    return true;
  }

  @override
  String toString() => values.toList().toString();
}
