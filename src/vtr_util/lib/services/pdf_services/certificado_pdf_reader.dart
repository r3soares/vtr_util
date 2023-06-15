import 'package:vtr_util/services/pdf_services/base_pdf_reader.dart';

class CertificadoPdfReader extends BasePdfReader {
  getDadosCertificado(String certificadoPdf) {
    String texto = loadPdf(certificadoPdf);
    print(texto);
  }
}
