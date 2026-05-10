import 'package:appshop/modules/endereco/Provider/endereco_provider.dart';
import 'package:appshop/shared/Widgets/back_app_bar.dart';
import 'package:appshop/shared/Widgets/send_button.dart';
import 'package:appshop/shared/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelecionarEnderecoPage extends StatefulWidget {
  const SelecionarEnderecoPage({super.key});

  @override
  State<SelecionarEnderecoPage> createState() => _SelecionarEnderecoPageState();
}

class _SelecionarEnderecoPageState extends State<SelecionarEnderecoPage> {
  String? _selectedEnderecoId;

  @override
  Widget build(BuildContext context) {
    final enderecos = Provider.of<EnderecoProvider>(context).enderecos;

    return Scaffold(
      appBar: BackAppBar(title: 'Selecionar endereço'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Selecione o endereço da entrega.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: enderecos.length,
            itemBuilder: (context, index) {
              final end = enderecos[index];
              final isSelected = _selectedEnderecoId == end.id;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedEnderecoId = end.id;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    color: isSelected
                        ? Colors.blue.withOpacity(0.05)
                        : Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${end.rua}, ${end.numero}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (end.complemento.isNotEmpty) Text(end.complemento),
                      Text("${end.bairro} - ${end.cidade}/${end.uf}"),
                      Text(
                        "CEP: ${end.cep}",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SendButton(
              'Novo endereço',
              () async {
                await Navigator.of(context).pushNamed(AppRoutes.NOVO_ENDERECO);
              },
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: SendButton(
                  'Voltar',
                  () => Navigator.of(context).pop(),
                  secondaryButton: true,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: SendButton(
                  'Continuar',
                  _selectedEnderecoId == null
                      ? null
                      : () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.FINALIZE_PURCHASE,
                            arguments: _selectedEnderecoId,
                          );
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
