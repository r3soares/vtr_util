import 'dart:convert';

class Compartimento {
  final int capacidade;
  final List<int> setas;

  Compartimento(this.capacidade, this.setas);

  Map<String, dynamic> toJson() => {
        'capacidade': capacidade,
        'setas': jsonEncode(setas),
      };

  factory Compartimento.fromJson(Map<String, dynamic> json) => Compartimento(
        json['capacidade'] as int,
        List.from(json['setas']),
      );
}
