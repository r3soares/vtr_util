import 'package:intl/intl.dart';

abstract class Constants {
  static DateFormat get formatoData => DateFormat('dd-MM-yyyy');
  static DateFormat get formatoDataHora => DateFormat('dd-MM-yyyy HH:mm');
  static DateFormat get formatoHora => DateFormat('HH:mm');
  static DateFormat get formatoDiaDaSemana =>
      DateFormat('EEEE dd/MM/yy', 'pt_BR');
}
