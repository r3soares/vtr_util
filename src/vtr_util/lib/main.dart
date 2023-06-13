import 'package:flutter/material.dart';
import 'package:vtr_util/services/scrap_services/veiculo_scrap.dart';

void main() {
  VeiculoScrap().getByPlaca('MLA7704');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
