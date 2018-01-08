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

    test('zero', () {
      final scalarZero = new PrimeFiniteFieldScalar(0, 3);

      final zero = new Polynomial([scalarZero]);

      expect(zero, zero.zero);
      expect(zero.isZero, true);
    });

    test('long division', () {
      final dividendScalars = [6, 5, 4, 3, 2];
      final divisorScalars = [4, 1];
      final dividend = new Polynomial(
          dividendScalars.map((s) => new PrimeFiniteFieldScalar(s, 7)));
      final divisor = new Polynomial(
          divisorScalars.map((s) => new PrimeFiniteFieldScalar(s, 7)));

      final division = dividend.longDivision(divisor);

      expect(((divisor * division.item1) + division.item2), dividend);
      expect(division.item1.scalars.map((s) => s.value), [0, 3, 2, 2]);
      expect(division.item2.scalars.map((s) => s.value), [6]);
    });
  });
}
