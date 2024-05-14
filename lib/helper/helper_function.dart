import 'package:intl/intl.dart';

//convert amount string to double
double convertAmount(String string) {
  double? amount = double.tryParse(string);
  return amount ?? 0;
}

//convert quantity string to double
double convertQuantity(String string) {
  double? quantity = double.tryParse(string);
  return quantity ?? 0;
}

//format double amount to KSH
String formatAmount(double amount) {
  final format = NumberFormat.currency(locale: 'en_US', symbol: '\KSH', decimalDigits: 2);
  return format.format(amount);
}