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
      required this.dadosPneus});
}
