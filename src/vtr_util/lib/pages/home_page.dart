import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vtr_util/domain/servico_vtr.dart';
import 'package:vtr_util/models/certificado.dart';
import 'package:vtr_util/models/interfaces/i_veiculo_scrap.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final servicos = context.read<List<ServicoVtr>>();
    TextEditingController placaController = TextEditingController();
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 150, vertical: 8),
                child: TextField(
                  controller: placaController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Informe a placa',
                  ),
                  maxLength: 7,
                  onChanged: (value) {
                    placaController.value = TextEditingValue(
                        text: value.toUpperCase(),
                        selection: placaController.selection);
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                      onPressed: () async =>
                          await _buscaPLaca(placaController.text, context),
                      child: const Text('Buscar')),
                ),
              )
            ],
          )),
    );
  }

  _buscaPLaca(String placa, BuildContext context) async {
    print('buscando placa.. $placa');
    final veiculoScrap = context.read<IVeiculoScrap>();
    final certificadoJson = await veiculoScrap.getByPlaca(placa);
    Certificado cert = Certificado.fromJson(certificadoJson);
    print(cert.versao);
  }
}
