import 'dart:convert';
import 'dart:io';

class Molecule implements Comparable<Molecule> {
  final String formula;
  final String name;

  Molecule({required this.formula, required this.name}) {
    _validateFormula();
  }

  void _validateFormula() {
    final RegExp formulaValida = RegExp(r'^[A-Za-z0-9]+$');
    if (!formulaValida.hasMatch(formula)) {
      throw FormatException('Invalid formula: $formula');
    }
  }

  int get weight => _calculateFormulaWeight(formula, _loadElementsJson());

  Map<String, dynamic> _loadElementsJson() {
    final jsonData = File('elements.json').readAsStringSync();
    final decodedData = jsonDecode(jsonData);

    if (decodedData is List) {
      final elementsMap = <String, dynamic>{};
      for (final element in decodedData) {
        final symbol = element['symbol'] as String;
        elementsMap[symbol] = element;
      }
      return elementsMap;
    } else if (decodedData is Map) {
      return decodedData.cast<String, dynamic>();
    } else {
      throw Exception('Formato de JSON não suportado');
    }
  }

  int _calculateFormulaWeight(String formula, Map<String, dynamic> elementsJson) {
    int totalWeight = 0;
    int currentIndex = 0;

    while (currentIndex < formula.length) {
      String currentSymbol = formula[currentIndex];

      int nextIndex = currentIndex + 1;
      while (nextIndex < formula.length && _isLowerCaseLetter(formula[nextIndex])) {
        currentSymbol += formula[nextIndex];
        nextIndex++;
      }

      String numericPart = '';
      while (nextIndex < formula.length && _isNumeric(formula[nextIndex])) {
        numericPart += formula[nextIndex];
        nextIndex++;
      }

      int atomCount = numericPart.isNotEmpty ? int.parse(numericPart) : 1;

      int elementWeight = _findWeightBySymbol(currentSymbol, elementsJson);
      totalWeight += elementWeight * atomCount;

      currentIndex = nextIndex;
    }

    return totalWeight;
  }

  int _findWeightBySymbol(String symbol, Map<String, dynamic> elementsJson) {
    final element = elementsJson[symbol];

    if (element != null) {
      final weight = element['weight'];
      if (weight is int) {
        return weight;
      } else if (weight is String) {
        return int.parse(weight);
      } else {
        throw Exception('Invalid weight symbol: $symbol');
      }
    } else {
      throw Exception('Element no found: $symbol');
    }
  }

  bool _isNumeric(String s) {
    return int.tryParse(s) != null;
  }

  bool _isLowerCaseLetter(String s) {
    return RegExp(r'[a-z]').hasMatch(s);
  }

  @override
  int compareTo(Molecule other) {
    return weight.compareTo(other.weight);
  }
}
