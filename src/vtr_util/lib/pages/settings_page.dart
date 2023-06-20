import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vtr_util/domain/servico_vtr.dart';
import 'package:vtr_util/services/preferences.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);
  final List<TextEditingController> controllersAtual = [];
  final List<TextEditingController> controllersAnterior = [];
  final List<TextEditingController> controllersPontos = [];

  @override
  Widget build(BuildContext context) {
    List<ServicoVtr> servicos = context.read<List<ServicoVtr>>();
    controllersAtual.addAll(List.generate(servicos.length,
        (i) => TextEditingController(text: '${servicos[i].valor}')));
    controllersAnterior.addAll(List.generate(servicos.length,
        (i) => TextEditingController(text: '${servicos[i].valorAnterior}')));
    controllersPontos.addAll(List.generate(servicos.length,
        (i) => TextEditingController(text: '${servicos[i].pontos}')));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atribuições'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Column(
                children: _geraCodigosServicos(servicos),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: ElevatedButton(
                    child: const Text('Salvar'),
                    onPressed: () async => {
                          await _salvaDados(servicos),
                          await _showDialogReiniciarApp(context),
                        }),
              ),
            )
          ],
        ),
      ),
    );
  }

  _geraCodigosServicos(List<ServicoVtr> servicos) {
    List<Widget> lista = [];
    for (int i = 0; i < servicos.length; i++) {
      lista.add(Expanded(
        flex: 1,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    '${servicos[i].cod}: ',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )),
            Expanded(
              flex: 2,
              child: Center(
                child: TextField(
                  controller: controllersAtual[i],
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'R\$ Atual',
                      labelStyle: TextStyle(color: Colors.green[700])),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: TextField(
                  controller: controllersAnterior[i],
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'R\$  Anterior',
                      labelStyle: TextStyle(color: Colors.red[900])),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: TextField(
                  controller: controllersPontos[i],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Pontos',
                  ),
                ),
              ),
            ),
          ],
        ),
      ));
    }
    return lista;
  }

  _salvaDados(List<ServicoVtr> servicos) async {
    servicos.clear();
    servicos.addAll([
      ServicoVtr(
          361,
          4000,
          double.tryParse(controllersAtual[0].text) ?? 0,
          double.tryParse(controllersAnterior[0].text) ?? 0,
          double.tryParse(controllersPontos[0].text) ?? 0,
          'Até 4.000L'),
      ServicoVtr(
          362,
          6000,
          double.tryParse(controllersAtual[1].text) ?? 0,
          double.tryParse(controllersAnterior[1].text) ?? 0,
          double.tryParse(controllersPontos[1].text) ?? 0,
          'De 4.001L até 6.000L'),
      ServicoVtr(
          363,
          8000,
          double.tryParse(controllersAtual[2].text) ?? 0,
          double.tryParse(controllersAnterior[2].text) ?? 0,
          double.tryParse(controllersPontos[2].text) ?? 0,
          'De 6.001L até 8.000L'),
      ServicoVtr(
          364,
          10000,
          double.tryParse(controllersAtual[3].text) ?? 0,
          double.tryParse(controllersAnterior[3].text) ?? 0,
          double.tryParse(controllersPontos[3].text) ?? 0,
          'De 8.001L até 10.000L'),
      ServicoVtr(
          365,
          20000,
          double.tryParse(controllersAtual[4].text) ?? 0,
          double.tryParse(controllersAnterior[4].text) ?? 0,
          double.tryParse(controllersPontos[4].text) ?? 0,
          'De 10.001L até 20.000L'),
      ServicoVtr(
          366,
          40000,
          double.tryParse(controllersAtual[5].text) ?? 0,
          double.tryParse(controllersAnterior[5].text) ?? 0,
          double.tryParse(controllersPontos[5].text) ?? 0,
          'De 20.001L até 40.000L'),
      ServicoVtr(
          367,
          100000,
          double.tryParse(controllersAtual[6].text) ?? 0,
          double.tryParse(controllersAnterior[6].text) ?? 0,
          double.tryParse(controllersPontos[6].text) ?? 0,
          'Acima de 40.000L'),
      ServicoVtr(
          368,
          0,
          double.tryParse(controllersAtual[7].text) ?? 0,
          double.tryParse(controllersAnterior[7].text) ?? 0,
          double.tryParse(controllersPontos[7].text) ?? 0,
          'Dispositivo de referência adicional'),
    ]);
    var encoder = const JsonEncoder();
    for (var s in servicos) {
      await Preferences.saveData(s.cod.toString(), encoder.convert(s.toJson()));
    }
  }

  _restartApp(BuildContext context) async {
    await Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  Future<void> _showDialogReiniciarApp(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dados salvos com sucesso!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('O app precisa ser reiniciado.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () async {
                await _restartApp(context);
              },
            ),
          ],
        );
      },
    );
  }
}
