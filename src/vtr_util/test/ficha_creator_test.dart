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
        proprietario: 'FULANO DAS GRAÇAS SOBRE RODAS',
        cnpj: '07.410.785/0001-36',
        ano: '2015',
        gru: '15355688856556',
        inmetro: '566287',
        marca: 'RANDON',
        municipio: 'Moji Das Cruzes',
        numSerie: '65974456',
        placa: 'IOF1520',
        uf: 'SP',
        versao: 'VT3012',
        ipem: 'IMETROSC',
        ipemEndereco: 'Rua Rosa Orsi Dalcoquio, 800',
        ipemTelefone: '4733481418',
        dataEmissao: '03/01/2024',
        resultado: 'APROVADO',
        tecExecutor: 'Sastre',
        tecResponsavel: 'Cabral',
        dataValidade: '03/01/2026',
        dataVerificacao: '03/01/2024',
        chassi: '56847562854423364',
        tanque: Tanque(
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
