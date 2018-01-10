import 'package:library/library.dart';
import 'package:shuttlecock/shuttlecock.dart';

class FiniteResidueField {
  final FiniteResidueFieldDefinition definition;
  IterableMonad<FiniteResidueFieldScalar> _elements;
  FiniteResidueFieldScalar _generator;
  FiniteResidueFieldScalar _one;

  FiniteResidueField(this.definition);

  IterableMonad<FiniteResidueFieldScalar> get elements =>
      _elements ??= definition.generateElements();

  FiniteResidueFieldScalar get generator {
    final discarded = new Set<FiniteResidueFieldScalar>();
    return _generator ??= elements.skip(1).firstWhere((e) {
      if (discarded.contains(e)) {
        return false;
      }

      var power = 1;
      var acc = e;
      while (acc != one) {
        discarded.add(acc);
        acc = acc * e;
        power++;
      }
//      return power == elements.length - 1;
      return power == elements.length;
    });
  }

  FiniteResidueFieldScalar get one => _one ??= new FiniteResidueFieldScalar(
      new Polynomial(
          [new PrimeFiniteFieldScalar(1, definition.characteristic)]),
      definition.irreducible);
}
