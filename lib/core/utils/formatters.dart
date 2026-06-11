import 'package:intl/intl.dart';

/**
 * Formata um valor numérico para moeda brasileira (R$).
 */
String formatPrice(double total) {
  final price = NumberFormat.currency(
    locale: 'pt_BR',
    decimalDigits: 2,
    symbol: "R\$",
  ).format(total);
  return price;
}

/**
 * Converte o valor total para o preço promocional.
 */
double discountPercentageAsDouble(String? percentage, String price) {
  final _percentage = double.tryParse(
        percentage!.replaceAll(',', '.').trim(),
      ) ??
      0.0;

  final _price = double.tryParse(
        price.replaceAll(',', '.').trim(),
      ) ??
      0.0;

  return _price * (1 - (_percentage / 100));
}

/**
 * Converte a data final em dias totais.
 */
String convertDateDifference(DateTime date) {
  DateTime today = DateTime.now();
  today = DateTime(today.year, today.month, today.day);

  return date.difference(today).inDays.toString();
}
