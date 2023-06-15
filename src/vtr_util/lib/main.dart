import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vtr_util/services/pdf_services/base_pdf_reader.dart';
import 'package:vtr_util/services/pdf_services/certificado_pdf_reader.dart';
import 'package:vtr_util/services/scrap_services/veiculo_scrap.dart';

void main() {
  //VeiculoScrap().getByPlaca('MLA7704');
  final pdfReader = BasePdfReader();
  pdfReader.loadPdf(''); //Teste
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
