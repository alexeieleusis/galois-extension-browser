import 'package:library/library.dart';

void main(List<String> arguments) {
  final degree = 10;
  primesLowerThan(15).forEach((characteristic) {
    final polynomials = buildAllSequences(characteristic, degree + 1)
        .skip(1)
        .map((scalars) => scalars
        .toList()
        .reversed
        .skipWhile((s) => s == 0)
        .toList()
        .reversed
        .toList())
        .where((s) => 2 <= s.length)
        .map((s) =>
        s.map((v) => new PrimeFiniteFieldScalar(v, characteristic)))
        .map((s) => new Polynomial(s))
        .toList();
    final irreducibles = polynomials
        .where((p) => p.degree > 0)
        .where((p) => p.isMonic)
        .toSet();
    polynomials.forEach((left) {
      polynomials.forEach((right) {
        irreducibles.remove(left * right);
      });
    });
    print('$characteristic $degree');
    irreducibles.forEach((p) {
      print(p.scalars.map((s) => s.value).toList());
    });
  });
}
