import 'package:appshop/core/utils/flushbar_helper.dart';
import 'package:appshop/core/widgets/back_app_bar.dart';
import 'package:appshop/core/widgets/input_decoration.dart';
import 'package:appshop/core/widgets/send_button.dart';
import 'package:appshop/modules/avaliacao/providers/avaliacao_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class AvaliacaoArgs {
  final String productId;
  final String productName;
  final String? avaliacaoId;
  final String? comentario;
  final double? nota;
  final String? orderId;

  const AvaliacaoArgs({
    required this.productId,
    required this.productName,
    this.avaliacaoId,
    this.comentario,
    this.nota,
    this.orderId,
  });
}

class AvaliacaoProdutoPage extends StatefulWidget {
  const AvaliacaoProdutoPage({super.key});

  @override
  State<AvaliacaoProdutoPage> createState() => _AvaliacaoProdutoPageState();
}

class _AvaliacaoProdutoPageState extends State<AvaliacaoProdutoPage> {
  late AvaliacaoProvider _avaliacaoProvider;
  late AvaliacaoArgs item;
  final _comentarioController = TextEditingController();
  late double _nota;

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    item = ModalRoute.of(context)!.settings.arguments as AvaliacaoArgs;

    _comentarioController.text = item.comentario ?? '';
    _nota = item.nota ?? 3;
  }

  @override
  void initState() {
    super.initState();
    _avaliacaoProvider = Provider.of<AvaliacaoProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: BackAppBar(
        title:
            item.avaliacaoId != null ? 'Editar avaliação' : 'Avaliar produto',
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Diga-nos o que você achou desse produto.",
                  style: TextStyle(
                    fontSize: 17,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: colorScheme.outline),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.inventory_2_outlined),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          item.productName,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 28),
              Text(
                "Sua nota",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  RatingBar.builder(
                    initialRating: _nota,
                    minRating: 1,
                    itemCount: 5,
                    itemBuilder: (context, _) =>
                        Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) {
                      setState(() => _nota = rating);
                    },
                  ),
                  SizedBox(width: 8),
                  Text(
                    _nota.toString(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 28),
              TextField(
                maxLines: 5,
                controller: _comentarioController,
                decoration: getInputDecoration(
                  context,
                  "Conte sua experiência com o produto",
                  activityHint: true,
                ),
              ),
              SizedBox(height: 40),
              SendButton("Enviar avaliação", () async {
                try {
                  if (item.orderId != null) {
                    await _avaliacaoProvider.enviarAvaliacao(
                      comentario: _comentarioController.text,
                      nota: _nota,
                      productId: item.productId,
                      orderId: item.orderId!,
                    );
                  } else {
                    await _avaliacaoProvider.editarAvaliacao(
                      comentario: _comentarioController.text,
                      nota: _nota,
                      productId: item.productId,
                      avaliacaoId: item.avaliacaoId!,
                    );
                  }

                  Navigator.of(context).pop(true);
                } catch (e) {
                  showAppFlushbar(context,
                      message: "Erro ao avaliar produto.!",
                      type: FlushType.error,
                      position: FlushPosition.top);
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
