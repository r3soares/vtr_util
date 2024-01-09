// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:vtr_util/models/tanque.dart';

class Certificado {
  final String proprietario;
  final String cnpj;
  final String inmetro;
  final String numSerie;
  final String marca;
  final String placa;
  final String chassi;
  final String ano;
  final String municipio;
  final String uf;
  final String versao;
  final String ipem;
  final String ipemEndereco;
  final String ipemTelefone;
  final String dataEmissao;
  final String resultado;
  final String tecExecutor;
  final String tecResponsavel;
  final String dataValidade;
  final String dataVerificacao;
  final String gru;
  final Tanque tanque;

  Certificado(
      {required this.proprietario,
      required this.cnpj,
      required this.versao,
      required this.ipem,
      required this.ipemEndereco,
      required this.ipemTelefone,
      required this.dataEmissao,
      required this.resultado,
      required this.tecExecutor,
      required this.tecResponsavel,
      required this.dataValidade,
      required this.dataVerificacao,
      required this.gru,
      required this.tanque,
      required this.inmetro,
      required this.numSerie,
      required this.marca,
      required this.placa,
      required this.chassi,
      required this.ano,
      required this.municipio,
      required this.uf});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'proprietario': proprietario,
      'cnpj': cnpj,
      'inmetro': inmetro,
      'numSerie': numSerie,
      'marca': marca,
      'placa': placa,
      'chassi': chassi,
      'ano': ano,
      'municipio': municipio,
      'uf': uf,
      'versao': versao,
      'ipem': ipem,
      'ipemEndereco': ipemEndereco,
      'ipemTelefone': ipemTelefone,
      'dataEmissao': dataEmissao,
      'resultado': resultado,
      'tecExecutor': tecExecutor,
      'tecResponsavel': tecResponsavel,
      'dataValidade': dataValidade,
      'dataVerificacao': dataVerificacao,
      'gru': gru,
      'tanque': tanque.toJson(),
    };
  }

  factory Certificado.fromJson(Map<String, dynamic> json) {
    return Certificado(
      proprietario: json['proprietario'] as String,
      cnpj: json['cnpj'] as String,
      versao: json['versao'] as String,
      ipem: json['ipem'] as String,
      ipemEndereco: json['ipemEndereco'] as String,
      ipemTelefone: json['ipemTelefone'] as String,
      dataEmissao: json['dataEmissao'] as String,
      resultado: json['resultado'] as String,
      tecExecutor: json['tecExecutor'] as String,
      tecResponsavel: json['tecResponsavel'] as String,
      dataValidade: json['dataValidade'] as String,
      dataVerificacao: json['dataVerificacao'] as String,
      gru: json['gru'] as String,
      tanque: Tanque.fromJson(json['tanque'] as Map<String, dynamic>),
      inmetro: json['inmetro'] as String,
      numSerie: json['numSerie'] as String,
      marca: json['marca'] as String,
      placa: json['placa'] as String,
      chassi: json['chassi'] as String,
      ano: json['ano'] as String,
      municipio: json['municipio'] as String,
      uf: json['uf'] as String,
    );
  }

  @override
  String toString() {
    return 'Certificado(proprietario: $proprietario,cnpj: $cnpj,versao: $versao, ipem: $ipem, ipemEndereco: $ipemEndereco, ipemTelefone: $ipemTelefone, dataEmissao: $dataEmissao, resultado: $resultado, tecExecutor: $tecExecutor, tecResponsavel: $tecResponsavel, validade: $dataValidade, gru: $gru, tanque: $tanque)';
  }

  @override
  bool operator ==(covariant Certificado other) {
    if (identical(this, other)) return true;

    return other.proprietario == proprietario &&
        other.cnpj == cnpj &&
        other.versao == versao &&
        other.ipem == ipem &&
        other.ipemEndereco == ipemEndereco &&
        other.ipemTelefone == ipemTelefone &&
        other.dataEmissao == dataEmissao &&
        other.resultado == resultado &&
        other.tecExecutor == tecExecutor &&
        other.tecResponsavel == tecResponsavel &&
        other.dataValidade == dataValidade &&
        other.gru == gru &&
        other.tanque == tanque;
  }

  @override
  int get hashCode {
    return proprietario.hashCode ^
        cnpj.hashCode ^
        versao.hashCode ^
        ipem.hashCode ^
        ipemEndereco.hashCode ^
        ipemTelefone.hashCode ^
        dataEmissao.hashCode ^
        resultado.hashCode ^
        tecExecutor.hashCode ^
        tecResponsavel.hashCode ^
        dataValidade.hashCode ^
        gru.hashCode ^
        tanque.hashCode;
  }
}
