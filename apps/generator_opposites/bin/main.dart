import 'dart:math';

import 'package:library/library.dart';

void main(List<String> arguments) {
  new Iterable.generate(5, (i) => i + 2).forEach(_computeForDegree);
}

void _computeForDegree(int degree) {
  void computeForCharacteristic(int characteristic) {
    void computeForSeed(int generator) {
      final definition =
          new GaloisExtensionDefinition(generator, characteristic, degree);
      final field = new GaloisExtension(definition);
      final itemCount = pow(characteristic, degree).toInt() - 1;
      print('degree: $degree, charactheristic: $characteristic, '
          'constant: $generator, generator: ${field.generator}');
      GaloisExtensionElement current;
      for (var power = 0; power < itemCount; power++) {
        current = current == null ? field.one : current * field.generator;
        GaloisExtensionElement oppositeCandidate;
        var oppositePower = -1;
        while (oppositeCandidate == null ||
            (current + oppositeCandidate).values.any((d) => d != 0)) {
          oppositeCandidate = oppositeCandidate == null
              ? field.one
              : oppositeCandidate * field.generator;
          oppositePower++;
        }
        print('\tpower: $power opposite: $oppositePower element: $current'
            ' opposite: $oppositeCandidate');
      }
    }

    findConstantsForSeed(degree, characteristic).forEach(computeForSeed);
  }

  findPrimesCongruentWithOne(degree, 2).forEach(computeForCharacteristic);
}
