import 'package:appshop/modules/endereco/Provider/endereco_provider.dart';
import 'package:appshop/shared/Models/endereco_model.dart';
import 'package:appshop/shared/Widgets/back_app_bar.dart';
import 'package:appshop/shared/Widgets/input_decoration.dart';
import 'package:appshop/shared/Widgets/send_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NovoEnderecoPage extends StatefulWidget {
  const NovoEnderecoPage({super.key});

  @override
  State<NovoEnderecoPage> createState() => _NovoEnderecoPageState();
}

class _NovoEnderecoPageState extends State<NovoEnderecoPage> {
  final _formKey = GlobalKey<FormState>();

  final _ufController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _bairroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _ruaController = TextEditingController();
  final _cepController = TextEditingController();
  final _complementoController = TextEditingController();

  @override
  void dispose() {
    _ufController.dispose();
    _cidadeController.dispose();
    _bairroController.dispose();
    _numeroController.dispose();
    _ruaController.dispose();
    _cepController.dispose();
    _complementoController.dispose();
    super.dispose();
  }

  String? validate(String value, String field) {
    if (value.trim().isEmpty) return 'Informe $field';
    return null;
  }

  Future<void> salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final endereco = EnderecoModel(
      id: '',
      cep: _cepController.text.trim(),
      rua: _ruaController.text.trim(),
      numero: _numeroController.text.trim(),
      complemento: _complementoController.text.trim(),
      bairro: _bairroController.text.trim(),
      cidade: _cidadeController.text.trim(),
      uf: _ufController.text.trim(),
    );

    await Provider.of<EnderecoProvider>(context, listen: false)
        .adicionarEndereco(endereco);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(title: 'Novo endereço'),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Preencha os dados para adicionar um novo endereço de entrega. '
                  'Certifique-se de que as informações estão corretas para evitar problemas na entrega.',
                  style: TextStyle(fontSize: 13),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Localização',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              TextFormField(
                controller: _cepController,
                decoration: getInputDecoration("CEP", activityLabel: true),
                validator: (v) => validate(v ?? '', 'o CEP'),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _ruaController,
                decoration: getInputDecoration("Rua", activityLabel: true),
                validator: (v) => validate(v ?? '', 'a rua'),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _numeroController,
                      decoration: getInputDecoration(
                        "Número",
                        activityLabel: true,
                      ),
                      validator: (v) => validate(v ?? '', 'o número'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _complementoController,
                      decoration: getInputDecoration(
                        "Complemento",
                        activityLabel: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _bairroController,
                decoration: getInputDecoration("Bairro", activityLabel: true),
                validator: (v) => validate(v ?? '', 'o bairro'),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _cidadeController,
                      decoration:
                          getInputDecoration("Cidade", activityLabel: true),
                      validator: (v) => validate(v ?? '', 'a cidade'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _ufController,
                      decoration: getInputDecoration("UF", activityLabel: true),
                      validator: (v) => validate(v ?? '', 'o estado'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              SendButton('Salvar endereço', salvar),
            ],
          ),
        ),
      ),
    );
  }
}
