import 'package:flutter/material.dart';

class LoadingBloc extends ChangeNotifier {
  bool isLoading = false;

  update(bool isLoading) {
    isLoading = isLoading;
    notifyListeners();
  }
}
