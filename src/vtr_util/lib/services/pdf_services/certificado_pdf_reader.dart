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
  _otimizaDoc(List<TextLine> temp) {
    final linhas = _limpaLixoInicial(temp);
    //String teste = '';
    final List<String> docFinal = [];
    for (var e in linhas) {
      if (_isLixo(e.text)) continue;
      docFinal.add(e.text);
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
    textos.removeRange(indexInicial, indexInicial + 8);
    return textos;
  }

  //Vai para a classe CertificadoPdfReader
  bool _isLixo(String texto) {
    if (texto.startsWith('***')) return true;
    if (texto == 'Endereço: ') return true;
    if (texto == 'Pág.:1') return true;
    if (texto == '/') return true;
    if (texto == '1') return true;
    if (texto == 'Endereço:') return true;
    if (texto == 'Município/UF:') return true;
    if (texto == 'EXEC.') return true;
    if (texto == 'IDENTIFICAÇÃO DO TANQUE DE CARGA') return true;
    // if (texto == 'DOCNº. CERTIFICADO') return true;
    if (texto == 'REFERÊNCIA DAS DIMENSÕESDIMENSÕES DO TANQUECOFRE') {
      return true;
    }
    if (texto == 'IDENTIFICAÇÃO DO VEÍCULODIMENSÕES DOS PNEUS') return true;
    if (texto == 'Marca:Ano de Fabricação:Nº de Série:') return true;
    if (texto == 'Licença:UF:') return true;
    if (texto == 'Nº do CHASSI:') return true;
    if (texto == 'PNEUSPRESSÃO (kPa)') return true;
    if (texto == 'CERTIFICADO DE VERIFICAÇÃO DE VEÍCULO ') return true;
    if (texto == 'TANQUE RODOVIÁRIO ') return true;
    if (texto == 'VALOR: R\$') return true;
    if (texto.startsWith('Este Certificado deve permanecer no veículo')) {
      return true;
    }
    if (texto.startsWith('prévia desgaseificação. Os espaços vazio,')) {
      return true;
    }
    // if (texto == 'IDENTIFICAÇÃO DO TANQUE DE CARGA') return true;
    if (texto ==
        'INSTITUTO NACIONAL DE METROLOGIA, QUALIDADE E TECNOLOGIA - INMETRO') {
      return true;
    }
    if (texto ==
        'MINISTÉRIO DO DESENVOLVIMENTO, INDÚSTRIA, COMÉRCIO E SERVIÇOS') {
      return true;
    }
    if (texto == 'Nº.CERTIFICADO') return true;
    if (texto == 'A autenticidade deste documento poderá ser conferida em:') {
      return true;
    }
    if (texto == 'ou pela leitura do QR-CODE.') return true;
    if (texto == 'CERTIFICADO DE VERIFICAÇÃO DE VEÍCULO TANQUE RODOVIÁRIO ') {
      return true;
    }
    if (texto == 'Marca:') return true;
    if (texto == '1º EIXO') return true;
    if (texto == '2º EIXO') return true;
    if (texto == '3º EIXO') return true;
    if (texto == '4º EIXO') return true;
    if (texto == 'DOC') return true;
    if (texto == 'DOCNº. CERTIFICADO') return true;
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
