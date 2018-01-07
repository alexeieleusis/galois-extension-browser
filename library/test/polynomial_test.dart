import 'package:library/src/polynomial.dart';
import 'package:library/src/prime_finite_field_scalar.dart';
import 'package:test/test.dart';

void main() {
  group('Polynomial', () {
    test('multiplication', () {
      final zero = new PrimeFiniteFieldScalar(0, 3);
      final one = new PrimeFiniteFieldScalar(1, 3);
      final x = new Polynomial([zero, one]);
      final other = new Polynomial([one, one, one]);

      final product = x * other;

      expect(product.scalars.toList(), [zero, one, one, one]);
    });

    test('sum', () {
      final zero = new PrimeFiniteFieldScalar(0, 3);
      final one = new PrimeFiniteFieldScalar(1, 3);
      final x = new Polynomial([zero, one]);
      final other = new Polynomial([one, one, one]);

      final sum = x + other;

      expect(sum.scalars.toList(), [one, one + one, one]);
    });

    test('one', () {
      final scalarOne = new PrimeFiniteFieldScalar(1, 3);

      final one = new Polynomial([scalarOne]);

      expect(one, one.one);
      expect(one.isOne, true);
    });

    test('one', () {
      final scalarZero = new PrimeFiniteFieldScalar(0, 3);

      final zero = new Polynomial([scalarZero]);

      expect(zero, zero.zero);
      expect(zero.isZero, true);
    });
  });
}
