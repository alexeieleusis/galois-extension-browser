import 'package:library/src/galois_extension_definition.dart';
import 'package:library/src/galois_extension_element.dart';
import 'package:shuttlecock/shuttlecock.dart';

class GaloisExtension {
  final GaloisExtensionDefinition definition;
  IterableMonad<GaloisExtensionElement> _elements;
  GaloisExtensionElement _generator;
  GaloisExtensionElement _one;

  GaloisExtension(this.definition);

  IterableMonad<GaloisExtensionElement> get elements =>
      _elements ??= definition.generateElements();

  GaloisExtensionElement get generator {
    final discarded = new Set<GaloisExtensionElement>();
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
      return power == elements.length - 1;
    });
  }

  GaloisExtensionElement get one => _one ??= new GaloisExtensionElement(
      definition,
      new Iterable.generate(definition.degree, (i) => i == 0 ? 1 : 0));
}
