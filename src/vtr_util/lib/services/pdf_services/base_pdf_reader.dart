import 'dart:convert';
import 'dart:io';

import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:vtr_util/services/pdf_services/certificados/certificado_base.dart';

//MGO4408
//OKF7788
//MGY7143
//QHQ7024
//QIJ9456
//OZK7445
//QIM1712
class BasePdfReader {
  String loadPdf(String pdf) {
    loadTesteEscala();
    return '';
    //Load an existing PDF document.
    final PdfDocument document = PdfDocument(inputBytes: ascii.encode(pdf));
    //Extract the text from all the pages.
    final text = PdfTextExtractor(document).extractTextLines(startPageIndex: 0);
    //Dispose the document.
    document.dispose();
    return text[0].text;
  }

  loadTeste(String uri, String nome) {
    final PdfDocument document =
        PdfDocument(inputBytes: File(uri).readAsBytesSync());
    final temp = PdfTextExtractor(document).extractTextLines(startPageIndex: 0);
    otimizaDoc(temp, nome);
  }

  loadTesteEscala() {
    for (var f in Directory('D:\\Temp\\certificados').listSync()) {
      loadTeste(f.path, f.uri.pathSegments.last);
    }
  }

  //Vai para a classe CertificadoPdfReader
  otimizaDoc(List<TextLine> temp, String nome) {
    final linhas = limpaLixoInicial(temp);
    String teste = '';
    final List<String> docFinal = [];
    for (var e in linhas) {
      if (isLixo(e.text)) continue;
      docFinal.add(e.text);
      teste += '${e.text}\n';
    }
    getDadosCert(docFinal);

    //Teste
    print('${linhas.length}(${docFinal.length})');
    File('D:\\Temp\\Resultados\\${nome.replaceAll('.pdf', '')}.txt')
        .writeAsStringSync(teste);
    //
  }

  getDadosCert(List<String> docFinal) {
    CertificadoBase cert = CertificadoBase(certificado: docFinal);
    print(cert.tecResponsavel);
  }

  //Vai para a classe CertificadoPdfReader
  List<TextLine> limpaLixoInicial(List<TextLine> textos) {
    int indexInicial = textos.indexWhere((e) => e.text == 'NÍVEL 1');
    textos.removeRange(indexInicial, indexInicial + 54);
    indexInicial = textos.indexWhere((e) => e.text == 'a');
    textos.removeRange(indexInicial, indexInicial + 8);
    return textos;
  }

  //Vai para a classe CertificadoPdfReader
  bool isLixo(String texto) {
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
    if (texto == 'REFERÊNCIA DAS DIMENSÕESDIMENSÕES DO TANQUECOFRE')
      return true;
    if (texto == 'IDENTIFICAÇÃO DO VEÍCULODIMENSÕES DOS PNEUS') return true;
    if (texto == 'Marca:Ano de Fabricação:Nº de Série:') return true;
    if (texto == 'Licença:UF:') return true;
    if (texto == 'Nº do CHASSI:') return true;
    if (texto == 'PNEUSPRESSÃO (kPa)') return true;
    if (texto == 'CERTIFICADO DE VERIFICAÇÃO DE VEÍCULO ') return true;
    if (texto == 'TANQUE RODOVIÁRIO ') return true;
    if (texto == 'VALOR: R\$') return true;
    if (texto.startsWith('Este Certificado deve permanecer no veículo'))
      return true;
    if (texto.startsWith('prévia desgaseificação. Os espaços vazio,'))
      return true;
    // if (texto == 'IDENTIFICAÇÃO DO TANQUE DE CARGA') return true;
    if (texto ==
        'INSTITUTO NACIONAL DE METROLOGIA, QUALIDADE E TECNOLOGIA - INMETRO')
      return true;
    if (texto ==
        'MINISTÉRIO DO DESENVOLVIMENTO, INDÚSTRIA, COMÉRCIO E SERVIÇOS')
      return true;
    if (texto == 'Nº.CERTIFICADO') return true;
    if (texto == 'A autenticidade deste documento poderá ser conferida em:')
      return true;
    if (texto == 'ou pela leitura do QR-CODE.') return true;
    if (texto == 'CERTIFICADO DE VERIFICAÇÃO DE VEÍCULO TANQUE RODOVIÁRIO ')
      return true;
    if (texto == 'Marca:') return true;
    if (texto == '1º EIXO') return true;
    if (texto == '2º EIXO') return true;
    if (texto == '3º EIXO') return true;
    if (texto == '4º EIXO') return true;
    if (texto == 'DOC') return true;
    if (texto == 'DOCNº. CERTIFICADO') return true;
    return false;
  }
}
