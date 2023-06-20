import 'package:flutter/material.dart';
import 'package:vtr_util/models/certificado.dart';

class CertificadoBloc extends ChangeNotifier {
  Certificado? cert;

  update(Certificado c) {
    cert = c;
    notifyListeners();
  }
}
