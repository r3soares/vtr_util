import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'base_pdf_reader.dart';
import 'certificados/certificado_extractor.dart';

class CertificadoPdfReader extends BasePdfReader {
  Map<String, dynamic> getDadosCertificado(String certificadoPdf) {
    final texto = loadPdf(certificadoPdf);
    final certificado = _otimizaDoc(texto);
    return certificado;
  }

  //Vai para a classe CertificadoPdfReader
  _otimizaDoc(List<TextLine> linhas) {
    //final linhas = _limpaLixoInicial(temp);
    //String teste = '';
    final List<String> docFinal = [];
    for (var e in linhas) {
      if (_isLixo(e.text)) continue;
      docFinal.add(e.text.trim());
      //teste += '${e.text}\n';
    }
    final certificado = _extraiCertificado(docFinal);
    return certificado;

    //Teste
    // print('${linhas.length}(${docFinal.length})');
    // File('D:\\Temp\\Resultados\\${nome.replaceAll('.pdf', '')}.txt')
    //     .writeAsStringSync(teste);
    //
  }

  Map<String, dynamic> _extraiCertificado(List<String> docFinal) {
    CertificadoExtractor cert = CertificadoExtractor(certificado: docFinal);
    return cert.toJson();
  }

  //Vai para a classe CertificadoPdfReader
  List<TextLine> _limpaLixoInicial(List<TextLine> textos) {
    int indexInicial = textos.indexWhere((e) => e.text == 'NÍVEL 1');
    textos.removeRange(indexInicial, indexInicial + 54);
    indexInicial = textos.indexWhere((e) => e.text == 'a');
    if (indexInicial == -1) return textos;
    textos.removeRange(indexInicial, indexInicial + 8);
    return textos;
  }

  static const _termosFiltrados = {
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
    'NÍVEL 1', 'NÍVEL 2', 'NÍVEL 3', 'NÍVEL 4', 'NÍVEL 5', 'NÍVEL 6',
    'CAPACIDADE (litros)', 'ESPAÇO TOTAL (mm)', 'ESPAÇO VAZIO (mm)', 'ESPAÇO CHEIO (mm)',
    'CAPACIDADE E DIMENSÕES', 'COMPARTIMENTOS NUMERADOS A PARTIR DA CABINE',
    '1º', 'C1N1', '2º', 'C2N1', '3º', 'C3N1', '4º', 'C4N1', '5º', 'C5N1',
    '6º', 'C6N1', '7º', 'C7N1', '8º', 'C8N1', '9º', 'C9N1', '10º', 'C10N1',
    'C1N2C2N2C3N2C4N2C5N2C6N2C7N2C8N2C9N2C10N2',
    'C1N3C2N3C3N3C4N3C5N3C6N3C7N3C8N3C9N3C10N3',
    'C1N4C2N4C3N4C4N4C5N4C6N4C7N4C8N4C9N4C10N4',
    'C1N5C2N5C3N5C4N5C5N5C6N5C7N5C8N5C9N5C10N5',
    'C1N6C2N6C3N6C4N6C5N6C6N6C7N6C8N6C9N6C10N6',
    'TUBULAÇÃO DE DESCARGA', 'VOLUME DA TUBULAÇÃO (litros)',
    'Endereço: ', 'Endereço:', 'Município/UF:',
    'Pág.: 1', '/', '1',
    'EXEC.', 'IDENTIFICAÇÃO DO TANQUE DE CARGA',
    'REFERÊNCIA DAS DIMENSÕESDIMENSÕES DO TANQUECOFRE',
    'REFERÊNCIA DAS DIMENSÕES DIMENSÕES DO TANQUE COFRE',
    'IDENTIFICAÇÃO DO VEÍCULODIMENSÕES DOS PNEUS',
    'Marca:Ano de Fabricação:Nº de Série:', 'Marca: Ano de Fabricação: Nº de Série:',
    'Licença:UF:', 'Nº do CHASSI:', 'PNEUSPRESSÃO (kPa)',
    'CERTIFICADO DE VERIFICAÇÃO DE VEÍCULO ', 'TANQUE RODOVIÁRIO ', 'VALOR: R\$',
    'INSTITUTO NACIONAL DE METROLOGIA, QUALIDADE E TECNOLOGIA - INMETRO',
    'MINISTÉRIO DO DESENVOLVIMENTO, INDÚSTRIA, COMÉRCIO E SERVIÇOS',
    'Nº.CERTIFICADO', 'A autenticidade deste documento poderá ser conferida em:',
    'ou pela leitura do QR-CODE.',
    'CERTIFICADO DE VERIFICAÇÃO DE VEÍCULO TANQUE RODOVIÁRIO ',
    'Marca:', '1º EIXO', '2º EIXO', '3º EIXO', '4º EIXO',
    'DOC', 'DOCNº. CERTIFICADO',
  };

  //Vai para a classe CertificadoPdfReader
  bool _isLixo(String texto) {
    if (texto.startsWith('***')) return true;
    if (_termosFiltrados.contains(texto)) return true;
    if (texto.startsWith('Este Certificado deve permanecer no veículo')) return true;
    if (texto.startsWith('prévia desgaseificação. Os espaços vazio,')) return true;
    if (texto.startsWith('Bairro')) return true;
    return false;
  }

  // _loadTeste(String uri, String nome) {
  //   final PdfDocument document =
  //       PdfDocument(inputBytes: File(uri).readAsBytesSync());
  //   final temp = PdfTextExtractor(document).extractTextLines(startPageIndex: 0);
  //   _otimizaDoc(temp);
  // }

  // _loadTesteEscala() {
  //   for (var f in Directory('D:\\Temp\\certificados').listSync()) {
  //     _loadTeste(f.path, f.uri.pathSegments.last);
  //   }
  // }
}
