import 'package:appshop/modules/avaliacao/enum/scale_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingBarWidget extends StatelessWidget {
  final ScaleSize scaleSize;
  final int? totalAvaliacoes;
  final double notaMedia;

  const RatingBarWidget({
    super.key,
    required this.scaleSize,
    required this.notaMedia,
    this.totalAvaliacoes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RatingBarIndicator(
          rating: notaMedia,
          itemBuilder: (context, index) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemCount: 5,
          itemSize: scaleSize.value,
        ),
        SizedBox(width: 4),
        Text(notaMedia.toString()),
        SizedBox(width: 8),
        if (totalAvaliacoes != null)
          Text(
            "(" + totalAvaliacoes.toString() + ' avaliações)',
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w900,
            ),
          ),
      ],
    );
  }
}
