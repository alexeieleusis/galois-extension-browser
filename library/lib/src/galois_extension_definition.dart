import 'package:library/src/galois_extension_element.dart';
import 'package:library/src/primes.dart';
import 'package:meta/meta.dart';
import 'package:shuttlecock/shuttlecock.dart';

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

  IterableMonad<GaloisExtensionElement> generateElements() {
    final seed = new IterableMonad.fromIterable(
        new Iterable.generate(characteristic, (i) => [i]));
    return new Iterable.generate(degree - 1)
        .fold<IterableMonad<List<int>>>(
            seed,
            (acc, _) => acc.flatMap((vector) => new IterableMonad.fromIterable(
                new Iterable.generate(characteristic,
                    (i) => vector.toList()..insertAll(0, [i])))))
        .map((v) {
      print(v);
      return new GaloisExtensionElement(this, v);
    });
  }
}
