import 'package:intl/intl.dart';

String formatPrice(double total) {
  final price = NumberFormat.currency(
    locale: 'pt_BR',
    decimalDigits: 2,
    symbol: "R\$",
  ).format(total);
  return price;
}
