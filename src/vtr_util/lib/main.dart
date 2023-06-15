import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vtr_util/domain/servico_vtr.dart';
import 'package:vtr_util/infra/database.dart';
import 'package:vtr_util/pages/settings_page.dart';
import 'package:vtr_util/services/pdf_services/base_pdf_reader.dart';
import 'package:vtr_util/services/pdf_services/certificado_pdf_reader.dart';
import 'package:vtr_util/services/scrap_services/veiculo_scrap.dart';

void main() async {
  //VeiculoScrap().getByPlaca('MLA7704');
  WidgetsFlutterBinding.ensureInitialized();
  final servicos = await Database().init();
  // final pdfReader = BasePdfReader();
  // pdfReader.loadPdf(''); //Teste
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Provider<List<ServicoVtr>>(
            create: (_) => servicos,
            child: const MainApp(),
          ),
      '/settings': (context) => Provider<List<ServicoVtr>>(
            create: (_) => servicos,
            child: SettingsPage(),
          ),
    },
    debugShowCheckedModeBanner: false,
  ));
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
