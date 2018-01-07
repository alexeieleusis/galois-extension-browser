import 'package:library/src/definitions.dart';

class PrimeFiniteFieldScalar extends FiniteFieldScalar<PrimeFiniteFieldScalar> {
  final int value;

  PrimeFiniteFieldScalar(int value, int characteristic)
      : value = value % characteristic,
        super(characteristic);

  @override
  int get hashCode => value.hashCode ^ super.hashCode;

  @override
  bool get isOne => value == 1;

  @override
  bool get isZero => value == 0;

  @override
  PrimeFiniteFieldScalar get one =>
      new PrimeFiniteFieldScalar(1, characteristic);

  @override
  PrimeFiniteFieldScalar get zero =>
      new PrimeFiniteFieldScalar(0, characteristic);

  @override
  PrimeFiniteFieldScalar operator *(PrimeFiniteFieldScalar other) {
    if (other.characteristic != characteristic) {
      throw new ArgumentError.value(
          other, 'elements should have the same characteristic');
    }

    return new PrimeFiniteFieldScalar(value * other.value, characteristic);
  }

  @override
  PrimeFiniteFieldScalar operator +(PrimeFiniteFieldScalar other) {
    if (other.characteristic != characteristic) {
      throw new ArgumentError.value(
          other, 'elements should have the same characteristic');
    }

    return new PrimeFiniteFieldScalar(value + other.value, characteristic);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrimeFiniteFieldScalar &&
          characteristic == other.characteristic &&
          value == other.value;

  @override
  String toString() => '$value (mod $characteristic)';
}
