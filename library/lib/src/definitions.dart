import 'package:library/library.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FieldScalar<T extends FieldScalar<T>> {
  /// Do not use, temporarily here while a better design to get it emerges.
  bool get isOne;

  /// Do not use, temporarily here while a better design to get it emerges.
  bool get isZero;

  /// Do not use, temporarily here while a better design to get it emerges.
  T get one;

  /// Do not use, temporarily here while a better design to get it emerges.
  T get zero;

  T operator *(T other);

  T operator +(T other);
}

abstract class FiniteFieldScalar<T extends FiniteFieldScalar<T>>
    extends FieldScalar<T> {
  final int characteristic;

  FiniteFieldScalar(this.characteristic) {
    if (!isPrime(characteristic)) {
      throw new ArgumentError.value(
          characteristic, 'characteristic must be a prime number');
    }
  }

  @override
  int get hashCode => characteristic.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FiniteFieldScalar && characteristic == other.characteristic;
}

