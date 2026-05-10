import 'package:appshop/modules/endereco/Provider/endereco_provider.dart';
import 'package:appshop/shared/Models/endereco_model.dart';
import 'package:appshop/shared/Widgets/back_app_bar.dart';
import 'package:appshop/shared/Widgets/input_decoration.dart';
import 'package:appshop/shared/Widgets/send_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelecionarEnderecoPage extends StatefulWidget {
  const SelecionarEnderecoPage({super.key});

  @override
  State<SelecionarEnderecoPage> createState() => _SelecionarEnderecoPageState();
}

class _SelecionarEnderecoPageState extends State<SelecionarEnderecoPage> {
  final _formKey = GlobalKey<FormState>();
  final _ufController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _bairroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _ruaController = TextEditingController();
  final _cepController = TextEditingController();
  final _complementoController = TextEditingController();

  String? _selectedEnderecoId;

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

  String? isValidNotEmpty(String value, String field) {
    if (value.trim().isEmpty) {
      return 'Informe $field';
    }
    return null;
  }

  String? isValidCEP(String value) {
    if (value.trim().isEmpty) {
      return 'Informe o CEP';
    }
    if (value.length < 8) {
      return 'CEP inválido';
    }
    return null;
  }

  String? isValidUF(String value) {
    if (value.trim().isEmpty) {
      return 'Informe o estado';
    }
    if (value.length != 2) {
      return 'Use a sigla (ex: RJ)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final EnderecoProvider _enderecos = Provider.of<EnderecoProvider>(context);

    Future<void> _adicionarEndereco() async {
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

      await _enderecos.adicionarEndereco(
        endereco,
      );
    }

    Future<void> novoEndereco() {
      final height = MediaQuery.of(context).size.height;

      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Novo endereço'),
          content: SizedBox(
            height: height * 0.5,
            width: double.maxFinite,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _cepController,
                      decoration:
                          getInputDecoration("CEP", activityLabel: true),
                      validator: (value) => isValidCEP(value ?? ""),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _ruaController,
                      decoration:
                          getInputDecoration("Rua", activityLabel: true),
                      validator: (value) =>
                          isValidNotEmpty(value ?? "", "a rua"),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _numeroController,
                      decoration:
                          getInputDecoration("Número", activityLabel: true),
                      validator: (value) =>
                          isValidNotEmpty(value ?? "", "o número"),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _complementoController,
                      decoration: getInputDecoration("Complemento",
                          activityLabel: true),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _bairroController,
                      decoration:
                          getInputDecoration("Bairro", activityLabel: true),
                      validator: (value) =>
                          isValidNotEmpty(value ?? "", "o bairro"),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _cidadeController,
                      decoration:
                          getInputDecoration("Cidade", activityLabel: true),
                      validator: (value) =>
                          isValidNotEmpty(value ?? "", "a cidade"),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _ufController,
                      decoration: getInputDecoration("UF", activityLabel: true),
                      validator: (value) => isValidUF(value ?? ""),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    child: Text('Cancelar'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: SendButton(
                    'Adicionar',
                    () async {
                      FocusScope.of(context).unfocus();

                      if (_formKey.currentState!.validate()) {
                        await _adicionarEndereco();
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: BackAppBar(title: 'Selecionar endereço'),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Text('Selecione o endereço da entrega.',
                  style: TextStyle(fontSize: 16)),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _enderecos.enderecos.length,
              itemBuilder: (context, index) {
                final end = _enderecos.enderecos[index];

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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        if (end.complemento.isNotEmpty)
                          Text(
                            end.complemento,
                            style: TextStyle(fontSize: 14),
                          ),
                        SizedBox(height: 4),
                        Text(
                          "${end.bairro} - ${end.cidade}/${end.uf}",
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "CEP: ${end.cep}",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (_enderecos.enderecos.length < 3)
              SendButton(
                'Novo endereço',
                novoEndereco,
                color: Colors.blue,
              ),
          ],
        ),
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
            )),
            SizedBox(width: 60),
            Expanded(
              child: SendButton(
                'Continuar',
                _selectedEnderecoId == null
                    ? null
                    : () {
                        // passar apenas o id do endereço e buscar o mesmo na tela seguinte;
                        // pegar o carrinho através do cartProvider e addOrder(_cart);
                        print(_selectedEnderecoId);
                      },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
