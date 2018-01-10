import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:library/library.dart';

@Component(
  selector: 'residue-field-viewer',
  styleUrls: const ['residue_field_viewer.css'],
  templateUrl: 'residue_field_viewer.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
  ],
  providers: const [],
)
class ResidueFieldViewer implements OnInit {
  SelectionModel<int> characteristicSelection = new SelectionModel.withList();

  SelectionOptions<int> characteristicSelectionOptions;

  SelectionModel<int> degreeSelection = new SelectionModel.withList();

  SelectionOptions<int> degreeSelectionOptions = new SelectionOptions(
      [new OptionGroup(new Iterable.generate(100, (i) => i + 2).toList())]);

  final List<RelativePosition> preferredPositions = const [
    RelativePosition.AdjacentBottomLeft,
    RelativePosition.AdjacentBottomRight
  ];

  FiniteResidueField extension;

  ResidueFieldViewer() {
    degreeSelection.selectionChanges.listen((_) {
      characteristicSelection.clear();
      if (degreeSelection.selectedValues.isEmpty) {
        degreeSelection.select(degreeSelectionOptions.optionsList.first);
        return;
      }

      final primes = primesLowerThan(20).toList();
      characteristicSelectionOptions =
          new SelectionOptions([new OptionGroup(primes)]);
      characteristicSelection.select(primes.first);
    });

    characteristicSelection.selectionChanges.listen((_) {
      if (characteristicSelection.selectedValues.isEmpty) {
        characteristicSelection
            .select(characteristicSelectionOptions.optionsList.first);
        return;
      }
      final degree = degreeSelection.selectedValues.first;
      final characteristic = characteristicSelection.selectedValues.first;
      final definition =
          new FiniteResidueFieldDefinition(characteristic, degree);
      extension = new FiniteResidueField(definition);
    });
  }

  String get characteristicSelectorText =>
      characteristicSelection.selectedValues.isEmpty
          ? 'Select field characteristic'
          : characteristicSelection.selectedValues.first.toString();

  String get detectiveSelectorText => degreeSelection.selectedValues.isEmpty
      ? 'Select extension degree'
      : degreeSelection.selectedValues.first.toString();

  String format(FiniteResidueFieldScalar scalar) {
    if (scalar == null) {
      return '';
    }

    return '${scalar.value.scalars.map((s) => s.value).toList()}';
  }

  @override
  void ngOnInit() {
    degreeSelection.select(degreeSelectionOptions.optionsList.first);
  }
}
