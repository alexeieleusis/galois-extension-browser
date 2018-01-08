import 'package:library/library.dart';
import 'package:meta/meta.dart';
import 'package:shuttlecock/shuttlecock.dart';

@immutable
class CyclicGaloisExtensionDefinition {
  final int generator;
  final int characteristic;
  final int degree;

  CyclicGaloisExtensionDefinition(this.generator, this.characteristic, this.degree) {
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
      other is CyclicGaloisExtensionDefinition &&
          runtimeType == other.runtimeType &&
          generator == other.generator &&
          characteristic == other.characteristic &&
          degree == other.degree;

  IterableMonad<CyclicGaloisExtensionElement> generateElements() =>
      buildAllSequences(characteristic, degree - 1)
          .map((v) => new CyclicGaloisExtensionElement(this, v));
}
