import 'dart:convert';
import 'package:syncfusion_flutter_pdf/pdf.dart';

//MGO4408
//OKF7788
//MGY7143
//QHQ7024
//QIJ9456
//OZK7445
//QIM1712
class BasePdfReader {
  List<TextLine> loadPdf(String pdf) {
    //loadTesteEscala();
    //return '';
    //Load an existing PDF document.
    final PdfDocument document = PdfDocument(inputBytes: ascii.encode(pdf));
    //Extract the text from all the pages.
    final text = PdfTextExtractor(document).extractTextLines(startPageIndex: 0);
    //Dispose the document.
    document.dispose();
    return text;
  }
}
