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

  //Vai para a classe CertificadoPdfReader
  bool _isLixo(String texto) {
    if (texto.startsWith('***')) return true;
    if (texto == 'a') return true;
    if (texto == 'b') return true;
    if (texto == 'c') return true;
    if (texto == 'd') return true;
    if (texto == 'e') return true;
    if (texto == 'f') return true;
    if (texto == 'g') return true;
    if (texto == 'h') return true;
    if (texto == 'NÍVEL 1') return true;
    if (texto == 'CAPACIDADE (litros)') return true;
    if (texto == 'ESPAÇO TOTAL (mm)') return true;
    if (texto == 'ESPAÇO VAZIO (mm)') return true;
    if (texto == 'ESPAÇO CHEIO (mm)') return true;
    if (texto == 'CAPACIDADE E DIMENSÕES') return true;
    if (texto == 'COMPARTIMENTOS NUMERADOS A PARTIR DA CABINE') return true;
    if (texto == '1º') return true;
    if (texto == 'C1N1') return true;
    if (texto == '2º') return true;
    if (texto == 'C2N1') return true;
    if (texto == '3º') return true;
    if (texto == 'C3N1') return true;
    if (texto == '4º') return true;
    if (texto == 'C4N1') return true;
    if (texto == '5º') return true;
    if (texto == 'C5N1') return true;
    if (texto == '6º') return true;
    if (texto == 'C6N1') return true;
    if (texto == '7º') return true;
    if (texto == 'C7N1') return true;
    if (texto == '8º') return true;
    if (texto == 'C8N1') return true;
    if (texto == '9º') return true;
    if (texto == 'C9N1') return true;
    if (texto == '10º') return true;
    if (texto == 'C10N1') return true;
    if (texto == 'NÍVEL 2') return true;
    if (texto == 'C1N2C2N2C3N2C4N2C5N2C6N2C7N2C8N2C9N2C10N2') return true;
    if (texto == 'NÍVEL 3') return true;
    if (texto == 'C1N3C2N3C3N3C4N3C5N3C6N3C7N3C8N3C9N3C10N3') return true;
    if (texto == 'NÍVEL 4') return true;
    if (texto == 'C1N4C2N4C3N4C4N4C5N4C6N4C7N4C8N4C9N4C10N4') return true;
    if (texto == 'NÍVEL 5') return true;
    if (texto == 'C1N5C2N5C3N5C4N5C5N5C6N5C7N5C8N5C9N5C10N5') return true;
    if (texto == 'NÍVEL 6') return true;
    if (texto == 'C1N6C2N6C3N6C4N6C5N6C6N6C7N6C8N6C9N6C10N6') return true;
    if (texto == 'TUBULAÇÃO DE DESCARGA') return true;
    if (texto == 'VOLUME DA TUBULAÇÃO (litros)') return true;
    if (texto == 'Endereço: ') return true;
    if (texto == 'Pág.: 1') return true;
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
    if (texto == 'REFERÊNCIA DAS DIMENSÕES DIMENSÕES DO TANQUE COFRE') {
      return true;
    }
    if (texto == 'IDENTIFICAÇÃO DO VEÍCULODIMENSÕES DOS PNEUS') return true;
    if (texto == 'Marca:Ano de Fabricação:Nº de Série:') return true;
    if (texto == 'Marca: Ano de Fabricação: Nº de Série:') return true;
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
    //Não estou tratando ainda
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
