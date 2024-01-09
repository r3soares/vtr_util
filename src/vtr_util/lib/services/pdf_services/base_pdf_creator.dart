import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

abstract class BasePdfCreator {
  PdfDocument createPdf() {
    final PdfDocument document = PdfDocument();
    return document;
  }

  savePdf(PdfDocument doc) async {
    //final Directory dir = await getApplicationSupportDirectory();
    final Directory dir = Directory(r'D:\Temp\');
    final path = dir.path;
    //Create an empty file to write PDF data
    File file = File('$path/Output.pdf');
    //Write PDF data
    List<int> bytes = await doc.save();
    await file.writeAsBytes(bytes, flush: true, mode: FileMode.write);
    doc.dispose();

    //OpenFile.open('$path/Output.pdf');
  }
}
