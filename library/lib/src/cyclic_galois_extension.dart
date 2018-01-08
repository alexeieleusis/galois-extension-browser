import 'package:library/library.dart';
import 'package:shuttlecock/shuttlecock.dart';

class CyclicGaloisExtension {
  final CyclicGaloisExtensionDefinition definition;
  IterableMonad<CyclicGaloisExtensionElement> _elements;
  CyclicGaloisExtensionElement _generator;
  CyclicGaloisExtensionElement _one;

  CyclicGaloisExtension(this.definition);

  IterableMonad<CyclicGaloisExtensionElement> get elements =>
      _elements ??= definition.generateElements();

  CyclicGaloisExtensionElement get generator {
    final discarded = new Set<CyclicGaloisExtensionElement>();
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

  CyclicGaloisExtensionElement get one =>
      _one ??= new CyclicGaloisExtensionElement(definition,
          new Iterable.generate(definition.degree, (i) => i == 0 ? 1 : 0));
}
