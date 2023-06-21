// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:collection/collection.dart';

import 'package:vtr_util/models/compartimento.dart';

class Tanque {
  final String inmetro;
  final String placa;
  final List<Compartimento> compartimentos;
  final List<String> letras;
  final bool isCofre;
  final int capacidadeTotal;
  final String marcaTanque;
  final String marcaVeiculo;
  final String chassiVeiculo;
  final List<String> dadosPneus;

  Tanque(
      {required this.inmetro,
      required this.placa,
      required this.compartimentos,
      required this.letras,
      required this.isCofre,
      required this.capacidadeTotal,
      required this.marcaTanque,
      required this.marcaVeiculo,
      required this.chassiVeiculo,
      required this.dadosPneus});

  Map<String, dynamic> toJson() => {
        'inmetro': inmetro,
        'placa': placa,
        'compartimentos': compartimentos,
        'letras': letras,
        'isCofre': isCofre,
        'capacidadeTotal': capacidadeTotal,
        'marcaTanque': marcaTanque,
        'marcaVeiculo': marcaVeiculo,
        'chassiVeiculo': chassiVeiculo,
        'dadosPneus': dadosPneus,
      };

  factory Tanque.fromJson(Map<String, dynamic> json) {
    return Tanque(
      inmetro: json['inmetro'] as String,
      placa: json['placa'] as String,
      compartimentos: List.from(json['compartimentos']),
      letras: List.from(json['letras']),
      isCofre: json['isCofre'] as bool,
      capacidadeTotal: json['capacidadeTotal'] as int,
      marcaTanque: json['marcaTanque'] as String,
      marcaVeiculo: json['marcaVeiculo'] as String,
      chassiVeiculo: json['chassiVeiculo'] as String,
      dadosPneus: List.from(json['dadosPneus']),
    );
  }

  @override
  String toString() {
    return 'Tanque(inmetro: $inmetro, placa: $placa, compartimentos: $compartimentos, letras: $letras, isCofre: $isCofre, capacidadeTotal: $capacidadeTotal, marcaTanque: $marcaTanque, marcaVeiculo: $marcaVeiculo, chassiVeiculo: $chassiVeiculo, dadosPneus: $dadosPneus)';
  }

  @override
  bool operator ==(covariant Tanque other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.inmetro == inmetro &&
        other.placa == placa &&
        listEquals(other.compartimentos, compartimentos) &&
        listEquals(other.letras, letras) &&
        other.isCofre == isCofre &&
        other.capacidadeTotal == capacidadeTotal &&
        other.marcaTanque == marcaTanque &&
        other.marcaVeiculo == marcaVeiculo &&
        other.chassiVeiculo == chassiVeiculo &&
        listEquals(other.dadosPneus, dadosPneus);
  }

  @override
  int get hashCode {
    return inmetro.hashCode ^
        placa.hashCode ^
        compartimentos.hashCode ^
        letras.hashCode ^
        isCofre.hashCode ^
        capacidadeTotal.hashCode ^
        marcaTanque.hashCode ^
        marcaVeiculo.hashCode ^
        chassiVeiculo.hashCode ^
        dadosPneus.hashCode;
  }
}
