import 'dart:convert';
import 'dart:io';

class Atom {
  final String symbol;

  Atom(this.symbol) {
    if (!isValidSymbol(symbol)) {
      throw Exception('Invalid formula');
    }
  }

  bool isValidSymbol(String symbol) {
    final jsonData = _loadElementsFromJson();

    return jsonData.any((element) => element['symbol'] == symbol);
  }

  List<Map<String, dynamic>> _loadElementsFromJson() {
    final file = File('elements.json');
    final jsonData = jsonDecode(file.readAsStringSync());
    if (jsonData is List<Map<String, dynamic>>) {
      return jsonData;
    } else {
      throw FormatException('Invalid format');
    }
  }

  @override
  String toString() => symbol;
}
