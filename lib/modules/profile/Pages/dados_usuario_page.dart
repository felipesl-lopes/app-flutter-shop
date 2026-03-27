import 'package:appshop/shared/Widgets/back_app_bar.dart';
import 'package:flutter/material.dart';

class DadosUsuarioPage extends StatelessWidget {
  const DadosUsuarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        title: "Dados do usuário",
      ),
    );
  }
}
