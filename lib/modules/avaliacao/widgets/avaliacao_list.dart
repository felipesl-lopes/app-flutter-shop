import 'package:appshop/modules/avaliacao/enum/scale_size.dart';
import 'package:appshop/modules/avaliacao/providers/avaliacao_provider.dart';
import 'package:appshop/modules/avaliacao/widgets/rating_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AvaliacaoList extends StatelessWidget {
  const AvaliacaoList({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<AvaliacaoProvider>(
      builder: (context, provider, _) {
        if (provider.avaliacoes.isEmpty) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Icon(
                  Icons.rate_review_outlined,
                  size: 42,
                  color: colorScheme.outline,
                ),
                SizedBox(height: 8),
                Text(
                  'Este produto ainda não possui avaliações.',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Avaliações',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12),
            if (provider.loadingAvaliacoes) ...[
              loadingAvaliations()
            ] else ...[
              ...provider.avaliacoes.map(
                (avaliacao) => Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                avaliacao.nomeUsuario,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            RatingBarWidget(
                                scaleSize: ScaleSize.small,
                                notaMedia: avaliacao.nota),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(avaliacao.comentario),
                        SizedBox(height: 8),
                        Text(
                          DateFormat("dd/MM/yyyy - HH:mm")
                              .format(avaliacao.dataCriacao),
                          style: TextStyle(
                              fontSize: 13, color: colorScheme.outline),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class loadingAvaliations extends StatelessWidget {
  const loadingAvaliations();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: EdgeInsets.all(20),
      child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 3)),
    ));
  }
}
