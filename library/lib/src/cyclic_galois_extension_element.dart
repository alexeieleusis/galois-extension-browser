import 'dart:math' as math;

import 'package:library/library.dart';
import 'package:meta/meta.dart';

@immutable
class CyclicGaloisExtensionElement {
  final CyclicGaloisExtensionDefinition definition;
  final Iterable<int> values;

  CyclicGaloisExtensionElement(this.definition, this.values) {
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

  CyclicGaloisExtensionElement operator *(CyclicGaloisExtensionElement other) {
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

    return new CyclicGaloisExtensionElement(definition, newValues);
  }

  CyclicGaloisExtensionElement operator +(CyclicGaloisExtensionElement other) {
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

    return new CyclicGaloisExtensionElement(definition, newValues);
  }

  @override
  bool operator ==(Object other) {
    if (!(identical(this, other) ||
        other is CyclicGaloisExtensionElement && definition == other.definition)) {
      return false;
    }

    final CyclicGaloisExtensionElement element = other;
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
