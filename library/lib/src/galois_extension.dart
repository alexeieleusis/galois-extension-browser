import 'package:library/src/galois_extension_definition.dart';
import 'package:library/src/galois_extension_element.dart';
import 'package:shuttlecock/shuttlecock.dart';

class GaloisExtension {
  final GaloisExtensionDefinition definition;
  final IterableMonad<GaloisExtensionElement> elements;
  GaloisExtensionElement _generator;
  GaloisExtensionElement _one;

  GaloisExtension(this.definition) : elements = definition.generateElements();

  GaloisExtensionElement get generator =>
      _generator ??= elements.skip(1).firstWhere((e) {
        var power = 1;
        var acc = e;
        while (acc != one) {
          acc = acc * e;
          power++;
        }
        return power == elements.length - 1;
      });

  GaloisExtensionElement get one => _one ??= elements.skip(1).first;
}
