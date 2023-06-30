import 'dart:convert';

import 'package:vtr_util/domain/servico_vtr.dart';
import 'package:vtr_util/services/preferences.dart';

class Database {
  static final Database _instance = Database._internal();
  final List<ServicoVtr> servicos = [];

  factory Database() {
    return _instance;
  }

  Database._internal();

  Future<List<ServicoVtr>> init() async {
    try {
      if (await Preferences.readData('361') != null) {
        var decoder = const JsonDecoder();
        servicos.addAll([
          ServicoVtr.fromJson(
              decoder.convert(await Preferences.readData('361'))),
          ServicoVtr.fromJson(
              decoder.convert(await Preferences.readData('362'))),
          ServicoVtr.fromJson(
              decoder.convert(await Preferences.readData('363'))),
          ServicoVtr.fromJson(
              decoder.convert(await Preferences.readData('364'))),
          ServicoVtr.fromJson(
              decoder.convert(await Preferences.readData('365'))),
          ServicoVtr.fromJson(
              decoder.convert(await Preferences.readData('366'))),
          ServicoVtr.fromJson(
              decoder.convert(await Preferences.readData('367'))),
          ServicoVtr.fromJson(
              decoder.convert(await Preferences.readData('368'))),
        ]);
        return servicos;
      }
      servicos.addAll([
        ServicoVtr(361, 4000, 187.86, 0, 1.67, 'Até 4.000L'),
        ServicoVtr(362, 6000, 222.65, 0, 1.99, 'De 4.001L até 6.000L'),
        ServicoVtr(363, 8000, 296.41, 0, 2.65, 'De 6.001L até 8.000L'),
        ServicoVtr(364, 10000, 371.55, 0, 3.31, 'De 8.001L até 10.000L'),
        ServicoVtr(365, 20000, 743.11, 0, 6.64, 'De 10.001L até 20.000L'),
        ServicoVtr(366, 40000, 1148.07, 0, 10.27, 'De 20.001L até 40.000L'),
        ServicoVtr(367, 100000, 2268.31, 0, 20.3, 'Acima de 40.000L'),
        ServicoVtr(368, 0, 180.90, 0, 1.62, 'Disp. de ref. adicional'),
      ]);
      var encoder = const JsonEncoder();
      for (var s in servicos) {
        await Preferences.saveData(
            s.cod.toString(), encoder.convert(s.toJson()));
      }
      return servicos;
    } on Exception {
      print('Erro ao buscar dados no shared Preferences');
      rethrow;
    }
  }
}
