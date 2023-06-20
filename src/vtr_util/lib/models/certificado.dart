// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:vtr_util/models/tanque.dart';

class Certificado {
  final String versao;
  final String ipem;
  final String ipemEndereco;
  final String ipemTelefone;
  final String dataEmissao;
  final String resultado;
  final String tecExecutor;
  final String tecResponsavel;
  final String validade;
  final String gru;
  final Tanque tanque;

  Certificado(
      this.versao,
      this.ipem,
      this.ipemEndereco,
      this.ipemTelefone,
      this.dataEmissao,
      this.resultado,
      this.tecExecutor,
      this.tecResponsavel,
      this.validade,
      this.gru,
      this.tanque);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'versao': versao,
      'ipem': ipem,
      'ipemEndereco': ipemEndereco,
      'ipemTelefone': ipemTelefone,
      'dataEmissao': dataEmissao,
      'resultado': resultado,
      'tecExecutor': tecExecutor,
      'tecResponsavel': tecResponsavel,
      'validade': validade,
      'gru': gru,
      'tanque': tanque.toJson(),
    };
  }

  factory Certificado.fromJson(Map<String, dynamic> json) {
    return Certificado(
      json['versao'] as String,
      json['ipem'] as String,
      json['ipemEndereco'] as String,
      json['ipemTelefone'] as String,
      json['dataEmissao'] as String,
      json['resultado'] as String,
      json['tecExecutor'] as String,
      json['tecResponsavel'] as String,
      json['validade'] as String,
      json['gru'] as String,
      Tanque.fromJson(json['tanque'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() {
    return 'Certificado(versao: $versao, ipem: $ipem, ipemEndereco: $ipemEndereco, ipemTelefone: $ipemTelefone, dataEmissao: $dataEmissao, resultado: $resultado, tecExecutor: $tecExecutor, tecResponsavel: $tecResponsavel, validade: $validade, gru: $gru, tanque: $tanque)';
  }

  @override
  bool operator ==(covariant Certificado other) {
    if (identical(this, other)) return true;

    return other.versao == versao &&
        other.ipem == ipem &&
        other.ipemEndereco == ipemEndereco &&
        other.ipemTelefone == ipemTelefone &&
        other.dataEmissao == dataEmissao &&
        other.resultado == resultado &&
        other.tecExecutor == tecExecutor &&
        other.tecResponsavel == tecResponsavel &&
        other.validade == validade &&
        other.gru == gru &&
        other.tanque == tanque;
  }

  @override
  int get hashCode {
    return versao.hashCode ^
        ipem.hashCode ^
        ipemEndereco.hashCode ^
        ipemTelefone.hashCode ^
        dataEmissao.hashCode ^
        resultado.hashCode ^
        tecExecutor.hashCode ^
        tecResponsavel.hashCode ^
        validade.hashCode ^
        gru.hashCode ^
        tanque.hashCode;
  }
}
