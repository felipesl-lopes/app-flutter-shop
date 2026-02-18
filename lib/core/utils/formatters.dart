import 'package:intl/intl.dart';

String formatPrice(double total) {
  final price = NumberFormat.currency(
    locale: 'pt_BR',
    decimalDigits: 2,
    symbol: "R\$",
  ).format(total);
  return price;
}

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
