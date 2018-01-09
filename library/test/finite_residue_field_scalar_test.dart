import 'package:library/library.dart';
import 'package:test/test.dart';

void main() {
  group('FiniteResidueFieldScalar', () {
    test('inverse', () {
      final characteristic = 3;
      final irreducibleScalars =
          [1, 0, 1].map((s) => new PrimeFiniteFieldScalar(s, characteristic));
      final valueScalars =
          [1, 1].map((s) => new PrimeFiniteFieldScalar(s, characteristic));
      final irreducible = new Polynomial(irreducibleScalars);
      final value = new Polynomial(valueScalars);

      final scalar = new FiniteResidueFieldScalar(value, irreducible);
      final inverse = scalar.inverse;
      final product = scalar * inverse;

      expect(product, scalar.one);
      expect(inverse.value.scalars.map((s) => s.value), [2, 1]);
    });
  });
}
