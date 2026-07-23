import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/modules/avaliacao/enum/scale_size.dart';
import 'package:appshop/modules/avaliacao/providers/avaliacao_provider.dart';
import 'package:appshop/modules/avaliacao/widgets/loading_avaliations.dart';
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

        final possuiMaisAvaliacoes = provider.avaliacoes.length > 3;

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
              LoadingAvaliations()
            ] else ...[
              ...provider.avaliacoes.take(3).map(
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
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: avaliacao.nomeUsuario,
                                            style: TextStyle(
                                                color: colorScheme.outline,
                                                fontWeight: FontWeight.bold)),
                                        WidgetSpan(child: SizedBox(width: 6)),
                                        if (avaliacao.minhaAvaliacao == true)
                                          TextSpan(
                                              text: '(você)',
                                              style: TextStyle(
                                                  color: colorScheme.outline)),
                                      ],
                                    ),
                                  ),
                                ),
                                RatingBarWidget(
                                    scaleSize: ScaleSize.small,
                                    notaMedia: avaliacao.nota),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              avaliacao.comentario,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat("dd/MM/yyyy - HH:mm")
                                      .format(avaliacao.dataCriacao),
                                  style: TextStyle(
                                      fontSize: 13,
                                      color:
                                          colorScheme.outline.withOpacity(0.7)),
                                ),
                                TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    child: Text("Editar avaliação"),
                                    onPressed: () {}
                                    // os parametros não batem,
                                    // onPressed: () => Navigator.of(context)
                                    //     .pushNamed(AppRoutes.AVALIACAO_PRODUTO, arguments: {'item': avaliacao}),
                                    )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              if (possuiMaisAvaliacoes)
                Center(
                  child: TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(AppRoutes.LISTA_AVALIACOES),
                      child: Text("Ver todas as avaliações")),
                )
            ],
          ],
        );
      },
    );
  }
}
