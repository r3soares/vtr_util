import 'dart:convert';

import 'package:vtr_util/models/compartimento.dart';

import '../../../models/tanque.dart';

class CertificadoExtractor {
  final List<String> certificado;
  late String versao;
  late String ipem;
  late String ipemEndereco;
  late String ipemTelefone;
  late String dataEmissao;
  late String resultado;
  late String tecExecutor;
  late String tecResponsavel;
  late String validade;
  late String gru;
  late Tanque tanque;
  CertificadoExtractor({required this.certificado}) {
    ipem = _getIpem();
    ipemEndereco = _getIpemEndereco();
    ipemTelefone = _getIpemTelefone();
    versao = _getVersao();
    _corrigePosicaoVersaoEmissao();
    dataEmissao = _getDataEmissao();
    resultado = _getResultado();
    tecExecutor = _getTecnicoExecutor();
    tecResponsavel = _getTecnicoResponsavel();
    validade = _getValidade();
    gru = _getGRU();
    final (String inmetro, int compartimentos) = _getInmetroCompartimentos();
    final capTotalTanque = _getCapTotalTanque();
    final letras = _getLetrasTanque();
    final isCofre = _getIsCofre();
    final (List<String> dadosPneus, String placa, String chassi) =
        _getDadosPneusPlacaChassi();
    final (String marcaVeiculo, String marcaTanque) =
        _getMarcaVeiculoMarcaTanque();
    final (List<int> capacidades, List<List<int>> setas) =
        _getDadosCompartimentos(compartimentos);
    tanque = Tanque(
        inmetro: inmetro,
        placa: placa,
        compartimentos: _criaCompartimentos(capacidades, setas),
        letras: letras,
        isCofre: isCofre,
        capacidadeTotal: int.parse(capTotalTanque),
        marcaTanque: marcaTanque,
        marcaVeiculo: marcaVeiculo,
        chassiVeiculo: chassi,
        dadosPneus: dadosPneus);
  }

  Map<String, dynamic> toJson() => {
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

  _criaCompartimentos(List<int> capacidades, List<List<int>> setas) {
    List<Compartimento> compartimentos = [];
    for (var i = 0; i < capacidades.length; i++) {
      compartimentos.add(Compartimento(capacidades[i], setas[i]));
    }
    return compartimentos;
  }

  _getIpem() => certificado[0];

  _getIpemEndereco() => certificado[1];

  _getIpemTelefone() => certificado[2].replaceFirst('Telefone/Fax:', '');

  _getVersao() => switch (certificado[3].substring(0, 6)) {
        'VT3011' => 'VT3011',
        'VT3012' => 'VT3012',
        _ => 'VT3012',
      };
  _corrigePosicaoVersaoEmissao() {
    if (versao == 'VT3012') {
      certificado.insert(3, versao);
      certificado[4] = certificado[4].replaceFirst(versao, '');
    }
  }

  _getDataEmissao() => certificado[4].replaceFirst('Data de Emissão: ', '');

  _getResultado() =>
      certificado[5].contains('APROVADO') ? 'APROVADO' : 'REPROVADO';

  _getTecnicoExecutor() {
    if (versao == 'VT3012') {
      var executor = certificado[6].replaceFirst('Técnico Executor-', '');
      executor = executor.substring(0, executor.indexOf('Técnico'));
      return executor;
    }
    return '';
  }

  _getTecnicoResponsavel() {
    if (versao == 'VT3012') {
      var resp = certificado[6].replaceFirst('Técnico Responsável-', '|');
      resp = resp.split('|')[1];
      return resp;
    }
    return '';
  }

  _getValidade() {
    final int posicao =
        certificado.indexWhere((e) => e.startsWith('VÁLIDO ATÉ'));
    switch (versao) {
      case 'VT3012':
        return certificado[posicao + 1];
      case 'VT3011':
        return certificado[posicao].replaceFirst('VÁLIDO ATÉ', '');
    }
  }

  _getGRU() => switch (versao) {
        'VT3012' => '',
        'VT3011' =>
          certificado.firstWhere((e) => e.startsWith('GRU:')).split(' ')[1],
        _ => ''
      };
  _getInmetroCompartimentos() {
    final dado = certificado
        .firstWhere((e) => e.startsWith('Nº do INMETRO:Nº de Compartimentos:'));
    final temp = dado.split(':')[3].split(' ');
    final inmetro = temp[0];
    final capacidade = temp[1].substring(1, temp[1].length - 1);
    switch (capacidade) {
      case 'um':
        return (inmetro, 1);
      case 'dois':
        return (inmetro, 2);
      case 'três':
        return (inmetro, 3);
      case 'quatro':
        return (inmetro, 4);
      case 'cinco':
        return (inmetro, 5);
      case 'seis':
        return (inmetro, 6);
      case 'sete':
        return (inmetro, 7);
      case 'oito':
        return (inmetro, 8);
      case 'nove':
        return (inmetro, 9);
      case 'dez':
        return (inmetro, 10);
    }
  }

  _getCapTotalTanque() {
    final posicao = certificado
        .indexWhere((e) => e.startsWith('Nº do INMETRO:Nº de Compartimentos:'));
    return certificado[posicao + 2].trim().replaceFirst('.', '');
  }

  _getLetrasTanque() {
    final int posInicial =
        certificado.indexWhere((e) => e.startsWith('Ref.Ref.mmmm')) + 1;
    final int posFinal =
        certificado.indexWhere((e) => e.startsWith('Sem Cofre'));
    List<String> letras = []; //a,b,c,d,e,f,g,h
    for (var i = posInicial; i < posFinal; i++) {
      letras.add(certificado[i]);
    }
    if (letras.length < 8) {
      //se não tiver cofre, preencher vazio
      letras.add('');
      letras.add('');
    }
    return letras;
  }

  _getIsCofre() {
    final int posicao =
        certificado.indexWhere((e) => e.startsWith('Sem Cofre'));
    return !certificado[posicao].contains('X');
  }

  _getDadosPneusPlacaChassi() {
    int posicao = certificado.indexWhere((e) => e.startsWith('DIMENSÕES')) + 1;
    List<String> dadosPneus = [];
    for (int i = posicao; i < posicao + 10; i++) {
      if (certificado[i][0] == ' ') {
        dadosPneus.add(certificado[i].trim());
      } else {
        break;
      }
    }
    posicao += dadosPneus.length;
    final posFinal = posicao + dadosPneus.length;
    for (var i = posicao; i < posFinal; i++) {
      dadosPneus.add(certificado[i]);
    }
    final placa = certificado[posFinal];
    final chassi = certificado[posFinal + 1];
    return (dadosPneus, placa, chassi);
  }

  _getMarcaVeiculoMarcaTanque() {
    int posicao = certificado.indexOf('POSIÇÃO DISP.REF. (mm)');
    final marcaVeiculo = certificado[posicao + 1];
    final marcaTanque = certificado[posicao + 2];
    return (marcaVeiculo, marcaTanque);
  }

  _getDadosCompartimentos(int quantidade) {
    int posicao = certificado.indexOf('POSIÇÃO DISP.REF. (mm)') + 3;
    final List<int> dados = [];
    for (int i = posicao; i < certificado.length; i++) {
      final dado = certificado[i];
      if (dado.length > 6) break;
      final int? numero = int.tryParse(dado);
      if (numero == null) break;
      dados.add(numero);
    }
    final List<int> capacidades = [];
    List<List<int>> setas = List.generate(quantidade, (index) => []);
    for (var i = 0; i < quantidade; i++) {
      capacidades.add(dados[0]);
      dados.removeRange(0, 4);
    }
    if (dados.length > 4) {
      while (dados.length > 3) {
        for (var i = 0; i < quantidade; i++) {
          setas[i].add(dados[0]);
          dados.removeRange(0, 3);
        }
      }
    }
    return (capacidades, setas);
  }
}
