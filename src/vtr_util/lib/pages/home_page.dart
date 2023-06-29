import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vtr_util/blocs/certificado_bloc.dart';
import 'package:vtr_util/domain/custo_compartimento.dart';
import 'package:vtr_util/domain/servico_vtr.dart';
import 'package:vtr_util/extensions/upper_case_text_formatter.dart';
import 'package:vtr_util/models/certificado.dart';
import 'package:vtr_util/models/compartimento.dart';
import 'package:vtr_util/models/interfaces/i_veiculo_scrap.dart';
import 'package:vtr_util/models/tanque.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'pt_BR');
  bool isLoading = false;
  final TextEditingController placaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () => Navigator.pushNamed(context, '/settings'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: size.width * .15,
                    right: size.width * .15,
                    top: size.height * .05),
                child: TextField(
                  controller: placaController,
                  onSubmitted: (_) async =>
                      await _buscaPLaca(placaController.text, context),
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        splashRadius: 5,
                        iconSize: 18,
                        onPressed: () => placaController.clear(),
                        icon: const Icon(
                          Icons.clear,
                        )),
                    border: const OutlineInputBorder(),
                    labelText: 'Informe a placa',
                  ),
                  maxLength: 7,
                  inputFormatters: [UpperCaseTextFormatter()],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : TextButton(
                          onPressed: () async =>
                              await _buscaPLaca(placaController.text, context),
                          child: const Text('Buscar')),
                ),
              ),
              Expanded(
                child: _veiculoBuild(context, size),
              )
            ],
          )),
    );
  }

  _buscaPLaca(String placa, BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    print('buscando placa.. $placa');
    setState(() {
      isLoading = true;
    });
    try {
      final veiculoScrap = context.read<IVeiculoScrap>();
      final certBloc = context.read<CertificadoBloc>();
      final certificadoJson = await veiculoScrap.getByPlaca(placa);
      Certificado cert = Certificado.fromJson(certificadoJson);
      // final cert = Certificado(
      //     'versao',
      //     'ipem',
      //     'ipemEndereco',
      //     'ipemTelefone',
      //     'dataEmissao',
      //     'resultado',
      //     'tecExecutor',
      //     'tecResponsavel',
      //     'dataValidade',
      //     'dataVerificacao',
      //     'gru',
      //     Tanque(
      //         inmetro: 'inmetro',
      //         placa: 'placa',
      //         compartimentos: [
      //           Compartimento(2000, []),
      //           Compartimento(4000, []),
      //           Compartimento(7000, []),
      //           Compartimento(10000, []),
      //           Compartimento(15000, []),
      //           Compartimento(20000, []),
      //           Compartimento(30000, []),
      //           Compartimento(40000, []),
      //           Compartimento(45000, [44000, 43000]),
      //           Compartimento(50000, [49000, 47000])
      //         ],
      //         letras: [],
      //         isCofre: false,
      //         capacidadeTotal: 5000,
      //         marcaTanque: 'marcaTanque',
      //         marcaVeiculo: 'marcaVeiculo',
      //         chassiVeiculo: 'chassiVeiculo',
      //         dadosPneus: []));
      certBloc.update(cert);
      print(cert.versao);
    } catch (e) {
      final snackBar = SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(
              color: Colors.white70, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red.shade900,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _veiculoBuild(BuildContext context, Size size) {
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
    final custoTotalAnterior = custo.getCustoTotalAnterior(capacidades, setas);
    final String codigos = geraCodigosServicos(cert.tanque, custo);
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: size.height * .02, horizontal: size.width * .1),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              cert.tanque.placa,
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              cert.tanque.inmetro,
              style: const TextStyle(fontSize: 18),
            ),
            ListTile(
              title: const Text('Verificado em'),
              trailing: Text(
                cert.dataVerificacao,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Text(
              codigos.trim(),
              style: const TextStyle(fontSize: 10, letterSpacing: 1),
              maxLines: 8,
            ),
            ListTile(
              title: const Text(
                'Valor Atual',
              ),
              trailing: Text(
                formatCurrency.format(custoTotal),
                style: TextStyle(fontSize: 16, color: Colors.red.shade900),
              ),
            ),
            ListTile(
              title: const Text(
                'Valor Anterior',
              ),
              trailing: Text(
                custoTotalAnterior == 0
                    ? 'N/D'
                    : formatCurrency.format(custoTotalAnterior),
                style: TextStyle(fontSize: 16, color: Colors.red.shade900),
              ),
            ),
          ],
        ),
      ),
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
      final custoFinal = (custo.getCustoByCodServico(key) * value);
      valores.add(
          '${custo.getDescricaoCod(key)} - $key x $value = ${formatCurrency.format(custoFinal)}');
    });
    if (setas > 0) {
      valores.add(
          '${custo.getDescricaoCod(custo.codDispReferencial)} ${custo.codDispReferencial} x $setas = R\$ ${custo.custoSetas(setas).toStringAsFixed(2)}');
    }
    return valores.fold(
        '', (previousValue, element) => '$previousValue\n$element');
  }
}
