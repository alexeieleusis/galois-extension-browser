import 'package:library/library.dart';

main(List<String> arguments) {
  print('char\tdeg\tgen\t\tirred');
  primesLowerThan(20).forEach((prime) {
    new Iterable.generate(10, (d) => d + 2).forEach((degree) {
      final definition = new FiniteResidueFieldDefinition(prime, degree);
      final field = new FiniteResidueField(definition);
      final generator =
          field.generator.value.scalars.map((s) => s.value).toList();
      final irreducible =
          definition.irreducible.scalars.map((s) => s.value).toList();
      print('$prime\t$degree\t$generator\t\t$irreducible');
    });
  });
}
