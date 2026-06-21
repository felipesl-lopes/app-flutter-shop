import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/core/enums/endereco_result_action.dart';
import 'package:appshop/core/utils/flushbar_helper.dart';
import 'package:appshop/core/widgets/back_app_bar.dart';
import 'package:appshop/core/widgets/send_button.dart';
import 'package:appshop/modules/endereco/providers/endereco_provider.dart';
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
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: GestureDetector(
                          onTap: () async {
                            final result = await Navigator.of(context)
                                .pushNamed(AppRoutes.NOVO_ENDERECO,
                                    arguments: end);

                            print(result);

                            if (result == EnderecoResultAction.updated) {
                              showAppFlushbar(
                                context,
                                message: 'Endereço atualizado',
                                type: FlushType.success,
                                position: FlushPosition.top,
                              );
                            }

                            if (result == EnderecoResultAction.created) {
                              showAppFlushbar(
                                context,
                                message: 'Endereço adicionado',
                                type: FlushType.success,
                                position: FlushPosition.top,
                              );
                            }

                            if (result == EnderecoResultAction.deleted) {
                              showAppFlushbar(
                                context,
                                message: 'Endereço removido',
                                type: FlushType.success,
                                position: FlushPosition.top,
                              );
                            }
                          },
                          child: Text(
                            'Editar endereço',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (enderecos.length < 3) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
                onPressed: () async => await Navigator.of(context)
                    .pushNamed(AppRoutes.NOVO_ENDERECO),
                child: Text('Novo endereço',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 10),
          ],
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
