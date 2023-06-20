import 'package:intl/intl.dart';
import 'package:vtr_util/models/interfaces/i_veiculo_scrap.dart';
import 'package:vtr_util/services/pdf_services/certificado_pdf_reader.dart';
import 'package:vtr_util/services/scrap_services/base_scrap.dart';
import 'package:vtr_util/services/scrap_services/urls.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';

//MLA7704
//
class VeiculoScrap extends BaseScrap implements IVeiculoScrap {
  final DateFormat formato = DateFormat('dd/MM/yyyy');

  @override
  Future<Map<String, dynamic>> getByPlaca(String placa) async {
    final dados = {
      'Placa': placa,
      'SelectedTipoClassificacaoInstrumento': '315',
    };

    final htmlHistoricoVeiculo = await loadPage(URL_INSTRUMENTROS, dados);
    final dadosCertificado = _getUltimaVerificacao(htmlHistoricoVeiculo);

    final htmlDetalhesCertificado =
        await loadPage(URL_DETALHES, dadosCertificado);
    final dadosVeiculo = _getDadosVeiculo(htmlDetalhesCertificado);

    final dadosConsulta = {
      'id': dadosVeiculo['ultimoCertificado'],
      'tipoInstrumento': 'VeiculoTanque',
      'uf': dadosVeiculo['uf'],
    };
    final pdf = await loadPage(URL_CERTIFICADO, dadosConsulta);
    final dadosFinaisEmJson = await _getPDFCertificado(pdf);
    return dadosFinaisEmJson;
  }

  Map<String, String> _getUltimaVerificacao(String html) {
    final bs = BeautifulSoup(html);
    if (bs.find('Nenhum Resultado Encontrado para os filtros selecionados!') !=
        null) {
      print('Nenhuma placa encontrada');
      throw Error();
    }

    final tabela = bs.find('*', id: 'Grid')!.table;
    final trs = tabela!.findAll('tr');
    trs.removeAt(0); //Remove Cabeçalho da tabela
    var ultimaVerificacao = '';
    var dataMaisAtual = DateTime.now().subtract(const Duration(days: 360000));
    for (var child in trs) {
      final tds = child.findAll('td');
      final dataValidade = formato.parse(tds[9].text);
      if (dataMaisAtual.isBefore(dataValidade)) {
        dataMaisAtual = dataValidade;
        final onclick = tds[11]
            .a!['onclick']; //"onDetailClick('VeiculoTanque', '138661', 'SC')"
        final verificacao = onclick!
            .substring(14, onclick.length - 1)
            .replaceAll(' ', ''); //.[14:-1].replaceAll(" ", "");
        ultimaVerificacao = verificacao;
      }
    }
    ultimaVerificacao = ultimaVerificacao.replaceAll('\'', '');
    final dadosIdentificacao = ultimaVerificacao.split(',');
    final mapIdVerificacao = {
      'tipoInstrumento': dadosIdentificacao[0],
      'id': dadosIdentificacao[1],
      'uf': dadosIdentificacao[2],
    };
    return mapIdVerificacao;
  }

  Map _getDadosVeiculo(String html) {
    final bs = BeautifulSoup(html);
    final campos = bs.findAll('*', class_: 'form-control');
    final veiculo = {};

    for (final Bs4Element dado in campos) {
      switch (dado.attributes['id']) {
        case "NomeProprietarioVeiculo":
          {
            veiculo['proprietario'] = dado.attributes['value'];
            break;
          }
        case "NumeroCgcFormatado":
          {
            veiculo['cnpj'] = dado.attributes['value'];
            break;
          }
        case "MunicipioProprietario":
          {
            veiculo['municipio'] = dado.attributes['value'];
            break;
          }
        case "NrSerie":
          {
            veiculo['numSerie'] = dado.attributes['value'];
            break;
          }
        case "NrInmetro":
          {
            veiculo['inmetro'] = dado.attributes['value'];
            break;
          }
        case "MarcaVeiculo":
          {
            veiculo['marca'] = dado.attributes['value'];
            break;
          }
        case "Placa":
          {
            veiculo['placa'] = dado.attributes['value'];
            break;
          }
        case "Chassi":
          {
            veiculo['chassi'] = dado.attributes['value'];
            break;
          }
        case "Ano":
          {
            veiculo['ano'] = dado.attributes['value'];
            break;
          }
        case "UfVeiculo":
          {
            veiculo['uf'] = dado.attributes['value'];
            break;
          }
        default:
          continue;
      }
    }
    final tabela = bs.find('tbody');
    veiculo['ultimoCertificado'] = _getNumeroCertificado(tabela!);
    return veiculo;
  }

  String _getNumeroCertificado(Bs4Element tabela) {
    int certificado = 0;
    for (final item in tabela.children) {
      //Há varios dados aqui (Local - Certificado - Data - Validade - Resultado - Link)
      //item.children[1] é o campo do Certificado
      final cert = item.children[1].text;
      final numero = int.tryParse(cert) ?? 0;
      if (certificado < numero) {
        certificado = numero;
      }
    }
    return certificado.toString();
  }

  Future<Map<String, dynamic>> _getPDFCertificado(String pdf) async {
    final pdfReader = CertificadoPdfReader();
    return pdfReader.getDadosCertificado(pdf);
    //pdfReader.loadPdf(pdf);
  }
}
