import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test/test.dart';
import 'package:vtr_util/models/certificado.dart';
import 'package:vtr_util/models/compartimento.dart';
import 'package:vtr_util/models/tanque.dart';
import 'package:vtr_util/services/pdf_services/ficha_pdf_creator.dart';

void main() {
  test('Criando ficha do vtr', () async {
    WidgetsFlutterBinding.ensureInitialized();
    Certificado cert = Certificado(
        'VT3012',
        'IMETROSC',
        'Rua Rosa Orsi Dalcoquio, 800',
        '4733481418',
        '03/01/2024',
        'APROVADO',
        'Sastre',
        'Cabral',
        '03/01/2026',
        '03/01/2024',
        '56847562854423364',
        Tanque(
            inmetro: '566287',
            placa: 'IOF1520',
            compartimentos: [
              Compartimento(5000, []),
              Compartimento(5000, []),
              Compartimento(2000, []),
              Compartimento(2000, []),
              Compartimento(2000, []),
              Compartimento(4000, []),
              Compartimento(4000, []),
              Compartimento(1000, []),
              Compartimento(2000, []),
              Compartimento(1000, [])
            ],
            letras: [
              '22000',
              '1250',
              '1250',
              '1300',
              '1350',
              '500',
              '1000',
              '300'
            ],
            isCofre: true,
            capacidadeTotal: 28000,
            marcaTanque: 'RANDON',
            marcaVeiculo: 'RANDON',
            chassiVeiculo: 'A2SHU675KMBS89',
            dadosPneus: ['22.5R15']));

    final fichaCreator = FichaPdfCreator();
    await fichaCreator.criaFicha(cert);

    //final Directory dir = await getApplicationSupportDirectory();
    final Directory dir = Directory(r'D:\Temp\');
    final path = dir.path;
    File file = File('$path/Output.pdf');
    expect(await file.exists(), true);
  });
}
