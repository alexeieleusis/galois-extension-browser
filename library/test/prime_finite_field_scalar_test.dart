import 'package:library/src/prime_finite_field_scalar.dart';
import 'package:test/test.dart';

void main() {
  group('Prime finite field scalar', () {
    test('inverse', () {
      final elements = [1, 2, 3, 4, 5, 6];
      final inverses = [1, 4, 5, 2, 3, 6];
      for (var i = 0; i < elements.length; i++) {
        final element = new PrimeFiniteFieldScalar(elements[i], 7);

        expect(element.inverse.value, inverses[i], reason: 'at index $i');
        expect(element * element.inverse, element.one);
      }
    });

    test('opposite', () {
      final elements = [1, 2, 3, 4, 5, 6];
      final inverses = [6, 5, 4, 3, 2, 1];
      for (var i = 0; i < elements.length; i++) {
        final element = new PrimeFiniteFieldScalar(elements[i], 7);

        expect(element.opposite.value, inverses[i], reason: 'at index $i');
        expect(element + element.opposite, element.zero);
      }
    });
  });
}
