import 'dart:io';

import 'package:test/test.dart';
import 'package:vtr_util/services/pdf_services/certificado_pdf_reader.dart';

void main() {
  test('Counter value should be incremented', () {
    String pastaCertificados = r'C:\Users\darkr\Documents\temp\certificados';
    final certificadoReader = CertificadoPdfReader();
    final pasta = Directory(pastaCertificados);
    for (var fileSystem in pasta.listSync()) {
      final file = File(fileSystem.path);
      final certificado =
          certificadoReader.getDadosCertificado(file.readAsStringSync());
      expect(certificado, isNotNull);
    }
  });
}
