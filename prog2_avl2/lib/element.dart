import 'atom.dart';

class Element {
  final String name;
  final Atom symbol;
  final String latinName;
  final int weight;

  Element({
    required this.name,
    required String symbol,
    required this.latinName,
    required this.weight,
  }) : symbol = Atom(symbol);
}
