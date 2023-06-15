import 'package:vtr_util/domain/extensions.dart';

import 'servico_vtr.dart';

class CustoCompartimento {
  late ServicoVtr servicoSeta;
  late List<ServicoVtr> servicos;

  CustoCompartimento(List<ServicoVtr> servicosVtr) {
    servicoSeta = servicosVtr.firstWhere((e) => e.cod == 368);
    servicos = servicosVtr;
  }

  double getCusto(int cap, int setas) {
    if (cap == 0) return 0;
    double custoCompartimento =
        servicos.firstWhere((s) => cap <= s.capacidadeMaxima).valor;

    double custoSetas = setas > 0 ? this.custoSetas(setas) : 0;

    return (custoCompartimento + custoSetas).toPrecision(2);
  }

  double getCustoAnterior(int cap, int setas) {
    if (cap == 0) return 0;
    double custoCompartimento =
        servicos.firstWhere((s) => cap <= s.capacidadeMaxima).valorAnterior;

    double custoSetas = setas > 0 ? custoSetasAnterior(setas) : 0;

    return (custoCompartimento + custoSetas).toPrecision(2);
  }

  double custoSetas(int setas) => setas * servicoSeta.valor;
  double custoSetasAnterior(int setas) => setas * servicoSeta.valorAnterior;

  double getCustoTotal(List<int> caps, int setas) {
    double custoCompartimento = 0;
    double custoSetas = 0;
    for (var c in caps) {
      custoCompartimento += getCusto(c, 0);
    }
    custoSetas = this.custoSetas(setas);
    return (custoCompartimento + custoSetas).toPrecision(2);
  }

  double getCustoTotalAnterior(List<int> caps, int setas) {
    double custoCompartimento = 0;
    double custoSetas = 0;
    for (var c in caps) {
      custoCompartimento += getCustoAnterior(c, 0);
    }
    custoSetas = custoSetasAnterior(setas);
    return (custoCompartimento + custoSetas).toPrecision(2);
  }

  getCodServico(int cap) =>
      servicos.firstWhere((s) => cap <= s.capacidadeMaxima).cod.toString();

  double getCustoByCodServico(String cod) =>
      servicos.firstWhere((s) => cod == s.cod.toString()).valor;

  double getCustoAnteriorByCodServico(String cod) =>
      servicos.firstWhere((s) => cod == s.cod.toString()).valorAnterior;

  get codDispReferencial => servicoSeta.cod.toString();
}
