import 'package:library/library.dart';
import 'package:meta/meta.dart';
import 'package:shuttlecock/shuttlecock.dart';

@immutable
class FiniteResidueFieldDefinition {
  final Polynomial<PrimeFiniteFieldScalar> irreducible;
  final int characteristic;
  final int degree;

  FiniteResidueFieldDefinition(this.characteristic, this.degree)
      : irreducible = findIrreduciblePolynomial(degree, characteristic) {
    if (!isPrime(characteristic)) {
      throw new ArgumentError.value(
          characteristic, 'characteristic', 'must be prime');
    }

    if (degree < 2) {
      throw new ArgumentError.value(degree, 'degree', 'must be greater than 1');
    }
  }

  @override
  int get hashCode =>
      irreducible.hashCode ^ characteristic.hashCode ^ degree.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FiniteResidueFieldDefinition &&
          runtimeType == other.runtimeType &&
          irreducible == other.irreducible &&
          characteristic == other.characteristic &&
          degree == other.degree;

  IterableMonad<FiniteResidueFieldScalar> generateElements() =>
      buildAllSequences(characteristic, degree)
          .skip(1)
          .map((scalars) => scalars
              .toList()
              .reversed
              .skipWhile((s) => s == 0)
              .toList()
              .reversed
              .toList())
          .map((v) => new FiniteResidueFieldScalar(
              new Polynomial(
                  v.map((s) => new PrimeFiniteFieldScalar(s, characteristic))),
              irreducible));
}
