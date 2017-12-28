import 'package:library/library.dart';

void main(List<String> arguments) {
  new Iterable.generate(10, (i) => i + 2).forEach(_computeForDegree);
}

void _computeForDegree(int degree) {
  void computeForCharacteristic(int characteristic) {
    void computeForSeed(int generator) {
      final definition =
      new GaloisExtensionDefinition(generator, characteristic, degree);
      final field = new GaloisExtension(definition);
      print('degree: $degree, charactheristic: $characteristic, '
          'constant: $generator, generator: ${field.generator}');
    }

    findConstantsForSeed(degree, characteristic).forEach(computeForSeed);
  }

  findPrimesCongruentWithOne(degree, 5).forEach(computeForCharacteristic);
}
