import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vtr_util/blocs/certificado_bloc.dart';
import 'package:vtr_util/domain/custo_compartimento.dart';
import 'package:vtr_util/domain/servico_vtr.dart';
import 'package:vtr_util/models/certificado.dart';
import 'package:vtr_util/models/compartimento.dart';
import 'package:vtr_util/models/interfaces/i_veiculo_scrap.dart';
import 'package:vtr_util/models/tanque.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
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
              ),
              Expanded(
                child: _veiculoBuild(context),
              )
            ],
          )),
    );
  }

  _buscaPLaca(String placa, BuildContext context) async {
    print('buscando placa.. $placa');
    final veiculoScrap = context.read<IVeiculoScrap>();
    final certBloc = context.read<CertificadoBloc>();
    final certificadoJson = await veiculoScrap.getByPlaca(placa);
    Certificado cert = Certificado.fromJson(certificadoJson);
    certBloc.update(cert);
    print(cert.versao);
  }

  Widget _veiculoBuild(BuildContext context) {
    final servicos = context.read<List<ServicoVtr>>();
    final certBloc = context.watch<CertificadoBloc>();
    if (certBloc.cert == null) return const SizedBox.shrink();
    final cert = certBloc.cert!;
    List<int> capacidades = [];
    final Map<String, int> codigosServico = {};
    CustoCompartimento custo = CustoCompartimento(servicos);
    int setas = 0;
    for (var e in cert.tanque.compartimentos) {
      capacidades.add(e.capacidade);
      setas += e.setas.length;
      final codigo = custo.getCodServico(e.capacidade);
      codigosServico.putIfAbsent('$codigo', () => 1);
    }
    final custoTotal = custo.getCustoTotal(capacidades, setas);
    final codigos = geraCodigosServicos(cert.tanque, custo);
    return GridView.count(
      primary: false,
      childAspectRatio: .5,
      padding: const EdgeInsets.all(20),
      shrinkWrap: true,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 4,
      children: <Widget>[
        Card(
          child: Column(
            children: [
              const Text(
                'Informações gerais',
                style: TextStyle(fontSize: 20),
              ),
              ListTile(
                title: const Text('Valor GRU'),
                trailing: Text('R\$$custoTotal'),
              ),
              ListTile(
                  title: const Text('Compartimentos'),
                  trailing: Text('${capacidades.length}')),
              ListTile(
                title: const Text('Setas'),
                trailing: Text('$setas'),
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            children: [
              const Text(
                'Códigos de serviço',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                '$codigos',
                style: const TextStyle(fontSize: 20),
                maxLines: 8,
              ),
            ],
          ),
        ),
      ],
    );
  }

  geraCodigosServicos(Tanque tanque, CustoCompartimento custo) {
    Map<String, int> mapCodigos = {};
    int setas = 0;
    List<Compartimento> lista = tanque.compartimentos;
    for (var e in lista) {
      String codCusto = custo.getCodServico(e.capacidade);
      mapCodigos.update(
        codCusto,
        (value) => ++value,
        ifAbsent: () => 1,
      );
      setas += e.setas.length;
    }
    List<String> valores = [];
    mapCodigos.forEach((key, value) {
      valores.add(
          '$value x $key = R\$ ${(custo.getCustoByCodServico(key) * value).toStringAsFixed(2)}');
    });
    if (setas > 0) {
      valores.add(
          '$setas x ${custo.codDispReferencial} = R\$ ${custo.custoSetas(setas).toStringAsFixed(2)}');
    }
    return valores.fold(
        '', (previousValue, element) => '$previousValue\n$element');
  }
}
