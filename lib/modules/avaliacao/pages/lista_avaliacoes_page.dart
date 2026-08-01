import 'package:appshop/core/widgets/back_app_bar.dart';
import 'package:appshop/modules/avaliacao/widgets/avaliacao_list.dart';
import 'package:flutter/material.dart';

class ListaAvaliacoesPage extends StatelessWidget {
  const ListaAvaliacoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String productName = args['productName'];
    final String productId = args['productId'];

    return Scaffold(
      appBar: BackAppBar(title: 'Avaliações'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: AvaliacaoList(
            productName: productName,
            productId: productId,
            mostrarTodas: true,
          ),
        ),
      ),
    );
  }
}
