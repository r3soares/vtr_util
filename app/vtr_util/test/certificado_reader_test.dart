import 'dart:io';

import 'package:test/test.dart';
import 'package:vtr_util/models/compartimento.dart';
import 'package:vtr_util/services/pdf_services/certificado_pdf_reader.dart';

void main() {
  group('invariante: capacidade total = soma dos compartimentos', () {
    test('todos os PDFs na pasta', () {
      final pasta = Directory(r'/home/nokaut/Documentos/Certificados');
      final reader = CertificadoPdfReader();
      for (var fs in pasta.listSync()) {
        final file = File(fs.path);
        if (!file.path.endsWith('.pdf')) continue;

        final result = reader.getDadosCertificado(file.readAsStringSync());
        final tanque = result['tanque'] as Map<String, dynamic>;
        final compartimentos = tanque['compartimentos'] as List<Compartimento>;
        final capacidadeTotal = tanque['capacidadeTotal'] as int;

        expect(compartimentos, isNotEmpty,
            reason: '${fs.path}: compartimentos vazio');
        for (final c in compartimentos) {
          expect(c.capacidade, greaterThan(0),
              reason: '${fs.path}: compartimento com capacidade zero');
        }
        final soma = compartimentos.fold<int>(0, (s, c) => s + c.capacidade);
        expect(capacidadeTotal, equals(soma),
            reason:
                '${fs.path}: capacidadeTotal ($capacidadeTotal) ≠ soma ($soma)');
      }
    });
  });

  group('VT3012 - MKV7E98', () {
    late Map<String, dynamic> result;
    late Map<String, dynamic> tanque;
    late List<Compartimento> compartimentos;

    setUpAll(() {
      final file =
          File(r'/home/nokaut/Documentos/Certificados/MKV7E98.pdf');
      result =
          CertificadoPdfReader().getDadosCertificado(file.readAsStringSync());
      tanque = result['tanque'] as Map<String, dynamic>;
      compartimentos = tanque['compartimentos'] as List<Compartimento>;
    });

    test('versão', () => expect(result['versao'], equals('VT3012')));
    test('data de emissão',
        () => expect(result['dataEmissao'], equals('04/05/2026')));
    test('resultado', () => expect(result['resultado'], equals('APROVADO')));
    test('placa', () => expect(tanque['placa'], equals('MKV7E98')));
    test('inmetro', () => expect(tanque['inmetro'], equals('A41998')));
    test('número de compartimentos',
        () => expect(compartimentos, hasLength(4)));
    test('capacidades individuais', () {
      expect(compartimentos.map((c) => c.capacidade).toList(),
          equals([15000, 10000, 5000, 5000]));
    });
    test('capacidade total',
        () => expect(tanque['capacidadeTotal'], equals(35000)));
    test('capacidade total = soma', () {
      final soma = compartimentos.fold<int>(0, (s, c) => s + c.capacidade);
      expect(tanque['capacidadeTotal'], equals(soma));
    });
  });
}
