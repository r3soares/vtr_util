import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:vtr_util/blocs/certificado_bloc.dart';
import 'package:vtr_util/blocs/loading_bloc.dart';
import 'package:vtr_util/domain/servico_vtr.dart';
import 'package:vtr_util/infra/database.dart';
import 'package:vtr_util/models/interfaces/i_veiculo_scrap.dart';
import 'package:vtr_util/pages/home_page.dart';
import 'package:vtr_util/pages/settings_page.dart';
import 'package:vtr_util/services/scrap_services/veiculo_scrap.dart';

import 'constantes_material.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Database().init();
  runApp(
    const App(),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool useMaterial3 = true;
  ThemeMode themeMode = ThemeMode.system;
  ColorSeed colorSelected = ColorSeed.baseColor;
  ColorImageProvider imageSelected = ColorImageProvider.leaves;
  ColorScheme? imageColorScheme = const ColorScheme.light();
  ColorSelectionMethod colorSelectionMethod = ColorSelectionMethod.colorSeed;

  bool get useLightMode {
    switch (themeMode) {
      case ThemeMode.system:
        return View.of(context).platformDispatcher.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  void handleBrightnessChange(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void handleMaterialVersionChange() {
    setState(() {
      useMaterial3 = !useMaterial3;
    });
  }

  void handleColorSelect(int value) {
    setState(() {
      colorSelectionMethod = ColorSelectionMethod.colorSeed;
      colorSelected = ColorSeed.values[value];
    });
  }

  void handleImageSelect(int value) {
    final String url = ColorImageProvider.values[value].url;
    ColorScheme.fromImageProvider(provider: NetworkImage(url))
        .then((newScheme) {
      setState(() {
        colorSelectionMethod = ColorSelectionMethod.image;
        imageSelected = ColorImageProvider.values[value];
        imageColorScheme = newScheme;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider<List<ServicoVtr>>(
      create: (_) => Database().servicos,
      lazy: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material 3',
        themeMode: themeMode,
        theme: ThemeData(
          colorSchemeSeed:
              colorSelectionMethod == ColorSelectionMethod.colorSeed
                  ? colorSelected.color
                  : null,
          colorScheme: colorSelectionMethod == ColorSelectionMethod.image
              ? imageColorScheme
              : null,
          useMaterial3: useMaterial3,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          colorSchemeSeed:
              colorSelectionMethod == ColorSelectionMethod.colorSeed
                  ? colorSelected.color
                  : imageColorScheme!.primary,
          useMaterial3: useMaterial3,
          brightness: Brightness.dark,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MultiProvider(
                providers: [
                  Provider<IVeiculoScrap>(
                    create: (_) => VeiculoScrap(),
                  ),
                  ChangeNotifierProvider<CertificadoBloc>(
                    create: (_) => CertificadoBloc(),
                  ),
                ],
                child: const HomePage(),
              ),
          '/settings': (context) => SettingsPage(),
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
