import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vtr_util/domain/servico_vtr.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final servicos = context.read<List<ServicoVtr>>();
    return Scaffold(
      body: Center(
        child: Text(servicos[0].descricao),
      ),
    );
  }
}
