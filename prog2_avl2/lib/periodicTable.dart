import 'dart:convert';
import 'dart:io';

import 'element.dart';

class PeriodicTable {
  static final PeriodicTable _instance = PeriodicTable._();
  late final Map<String, Element> _elements;

  factory PeriodicTable() => _instance;

  PeriodicTable._() {
    _loadElements();
  }

  void _loadElements() {
    try {
      final jsonContent = File('elements.json').readAsStringSync();
      final elementsJson = jsonDecode(jsonContent);
      
      final elementsList = elementsJson.map<Element>((e) {
        return Element(
          symbol: e['symbol'],
          name: e['name'],
          latinName: e['latinName'],
          weight: int.parse(e['weight'].toString()),
        );
      }).toList();

      _elements = Map<String, Element>.fromIterable(
        elementsList,
        key: (element) => element.name,
        value: (element) => element,
      );
    } catch (e) {
      print('Erro');
      _elements = {};
    }
  }

  static Map<String, Element> get elements {
    return _instance._elements.isNotEmpty ? _instance._elements : {};
  }
}

void main() {
  print(PeriodicTable.elements);
}
