import 'package:appshop/shared/utils/formatters.dart';
import 'package:flutter/material.dart';

class PromotionCountdownText extends StatelessWidget {
  final bool isPromotional;
  final DateTime? promotionEndDate;

  const PromotionCountdownText(
      {required this.isPromotional, this.promotionEndDate});

  @override
  Widget build(BuildContext context) {
    if (promotionEndDate == null) {
      return SizedBox.shrink();
    }

    final dias = convertDateDifference(promotionEndDate!);

    String texto;

    if (dias == '1') {
      texto = 'Aproveite agora! Essa promoção termina amanhã.';
    } else if (dias == '0') {
      texto = 'Aproveite agora! Essa promoção termina hoje.';
    } else {
      texto = 'Aproveite essa promoção por mais $dias dias.';
    }

    return Column(
      children: [
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: Colors.transparent),
          child: Text(
            texto,
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 15,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
