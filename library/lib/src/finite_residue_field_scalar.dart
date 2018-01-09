import 'package:library/library.dart';

class FiniteResidueFieldScalar
    extends FiniteFieldScalar<FiniteResidueFieldScalar> {
  final Polynomial<PrimeFiniteFieldScalar> value;
  final Polynomial<PrimeFiniteFieldScalar> irreducible;

  FiniteResidueFieldScalar(
      Polynomial<PrimeFiniteFieldScalar> value, this.irreducible)
      : value = value % irreducible,
        super(value.scalars.first.characteristic) {
    if (value.scalars.first.characteristic !=
        irreducible.scalars.first.characteristic) {
      throw new ArgumentError.value(
          value, 'value and irreducible must have the same characteristic');
    }
  }

  @override
  int get hashCode => super.hashCode ^ value.hashCode ^ irreducible.hashCode;

  @override
  FiniteResidueFieldScalar get inverse {
    // TODO: Implement Euclid's algorithm and stop relying in brute force.
    final polynomials = buildAllSequences(characteristic, irreducible.degree)
        .skip(1)
        .map((scalars) => scalars
            .toList()
            .reversed
            .skipWhile((s) => s == 0)
            .toList()
            .reversed
            .toList())
        .map((s) => s.map((v) => new PrimeFiniteFieldScalar(v, characteristic)))
        .map((s) => new Polynomial(s))
        .map((p) => new FiniteResidueFieldScalar(p, irreducible))
        .where((s) => !s.isZero)
        .toList();

    return polynomials.firstWhere((p) => (this * p).isOne);
  }

  @override
  bool get isOne => value.isOne;

  @override
  bool get isZero => value.isZero;

  @override
  FiniteResidueFieldScalar get one =>
      new FiniteResidueFieldScalar(value.one, irreducible);

  @override
  FiniteResidueFieldScalar get opposite =>
      new FiniteResidueFieldScalar(value.opposite % irreducible, irreducible);

  @override
  FiniteResidueFieldScalar get zero =>
      new FiniteResidueFieldScalar(value.zero, irreducible);

  @override
  FiniteResidueFieldScalar operator *(FiniteResidueFieldScalar other) =>
      new FiniteResidueFieldScalar(value * other.value, irreducible);

  @override
  FiniteResidueFieldScalar operator +(FiniteResidueFieldScalar other) =>
      new FiniteResidueFieldScalar(value + other.value, irreducible);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is FiniteResidueFieldScalar &&
          value == other.value &&
          irreducible == other.irreducible;

  @override
  String toString() => '$value [mod $irreducible]';
}
