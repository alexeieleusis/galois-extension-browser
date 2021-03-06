import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:library/library.dart';

@Component(
  selector: 'field-builder',
  styleUrls: const ['field_builder.css'],
  templateUrl: 'field_builder.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
  ],
  providers: const [],
)
class FieldBuilder implements OnInit {
  SelectionModel<int> characteristicSelection = new SelectionModel.withList();

  SelectionOptions<int> characteristicSelectionOptions;

  SelectionModel<int> degreeSelection = new SelectionModel.withList();

  SelectionOptions<int> degreeSelectionOptions = new SelectionOptions(
      [new OptionGroup(new Iterable.generate(100, (i) => i + 2).toList())]);

  CyclicGaloisExtensionDefinition definition;

  SelectionModel<int> generatorSelection = new SelectionModel.withList();

  SelectionOptions<int> generatorSelectionOptions;

  final List<RelativePosition> preferredPositions = const [
    RelativePosition.AdjacentBottomLeft,
    RelativePosition.AdjacentBottomRight
  ];

  CyclicGaloisExtension extension;

  FieldBuilder() {
    degreeSelection.selectionChanges.listen((_) {
      characteristicSelection.clear();
      generatorSelection.clear();
      if (degreeSelection.selectedValues.isEmpty) {
        definition = null;
        degreeSelection.select(degreeSelectionOptions.optionsList.first);
        return;
      }

      final degree = degreeSelection.selectedValues.first;
      final primes = findPrimesCongruentWithOne(degree, 50).toList();
      characteristicSelectionOptions =
          new SelectionOptions([new OptionGroup(primes)]);
      characteristicSelection.select(primes.first);
    });

    characteristicSelection.selectionChanges.listen((_) {
      generatorSelection.clear();
      if (characteristicSelection.selectedValues.isEmpty) {
        definition = null;
        characteristicSelection
            .select(characteristicSelectionOptions.optionsList.first);
        return;
      }
      final degree = degreeSelection.selectedValues.first;
      final characteristic = characteristicSelection.selectedValues.first;
      final candidates = findConstantsForSeed(degree, characteristic).toList();
      generatorSelectionOptions =
          new SelectionOptions([new OptionGroup(candidates)]);
      generatorSelection.select(candidates.first);
    });

    generatorSelection.selectionChanges.listen((_) {
      if (generatorSelection.selectedValues.isEmpty) {
        definition = null;
        generatorSelection.select(generatorSelectionOptions.optionsList.first);
        return;
      }

      definition = new CyclicGaloisExtensionDefinition(
          _generator, _characteristic, _degree);
      extension = new CyclicGaloisExtension(definition);
    });
  }

  String get characteristicSelectorText =>
      characteristicSelection.selectedValues.isEmpty
          ? 'Select field characteristic'
          : characteristicSelection.selectedValues.first.toString();

  String get detectiveSelectorText => degreeSelection.selectedValues.isEmpty
      ? 'Select extension degree'
      : degreeSelection.selectedValues.first.toString();

  String get generatorSelectorText => generatorSelection.selectedValues.isEmpty
      ? 'Select field generator'
      : generatorSelection.selectedValues.first.toString();

  int get _characteristic => characteristicSelection.selectedValues.first;

  int get _degree => degreeSelection.selectedValues.first;

  int get _generator => generatorSelection.selectedValues.first;

  @override
  void ngOnInit() {
    degreeSelection.select(degreeSelectionOptions.optionsList.first);
  }
}
