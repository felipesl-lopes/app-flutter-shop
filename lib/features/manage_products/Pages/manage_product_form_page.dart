import 'package:appshop/core/models/product_model.dart';
import 'package:appshop/core/utils/product_validators.dart';
import 'package:appshop/features/product/Provider/product_list_provider.dart';
import 'package:appshop/shared/Widgets/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _imageUrlController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<String> _imageUrls = [];
  bool _isInit = true;
  bool _isLoading = false;
  ProductModel? _editedProduct;

  void updateImage() {
    setState(() {});
  }

  Future<void> _submitForm() async {
    final isValidy = _formKey.currentState?.validate() ?? false;
    if (!isValidy) {
      return;
    }

    setState(() => _isLoading = true);

    final name = _nameController.text.trim();
    final price = double.parse(_priceController.text);
    final description = _descriptionController.text.trim();
    final imageUrls = _imageUrls;

    final data = <String, Object>{
      "name": name,
      "price": price,
      "description": description,
      "imageUrls": imageUrls,
    };

    if (_editedProduct != null) {
      data["id"] = _editedProduct!.id;
    }

    try {
      await Provider.of<ProductListProvider>(
        context,
        listen: false,
      ).saveProduct(data);
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Ocorreu um erro."),
          content: Text("Ocorreu um erro ao salvar o produto."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Ok"),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = true);
      Navigator.of(context).pop();
    }
  }

  void _addImage() {
    FocusScope.of(context).unfocus();
    final url = _imageUrlController.text.trim();

    if (url.isEmpty || isValidImageUrl(url) != null) {
      return;
    }

    setState(() {
      _imageUrls.add(url);
      _imageUrlController.clear();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final arg = ModalRoute.of(context)!.settings.arguments;
      if (arg != null) {
        _editedProduct = arg as ProductModel;

        _nameController.text = _editedProduct!.name;
        _priceController.text = _editedProduct!.price.toString();
        _descriptionController.text = _editedProduct!.description;
        _imageUrls = List.from(_editedProduct!.imageUrls);
      }

      _isInit = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          _editedProduct == null ? "Adicionar produto" : "Editar produto",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: getInputDecoration("Nome"),
                      validator: (value) => isValidName(value ?? ""),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _priceController,
                      decoration: getInputDecoration("Preço"),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) => isValidPrice(value ?? ""),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: getInputDecoration("Descrição"),
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      validator: (value) => isValidDescription(value ?? ""),
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _imageUrlController,
                                decoration: getInputDecoration("URL da imagem"),
                                keyboardType: TextInputType.url,
                              ),
                            ),
                            TextButton(
                                onPressed: _addImage,
                                child: Text("Adicionar imagem"))
                          ],
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _imageUrls.map((url) {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  url,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitForm,
        backgroundColor: Colors.purple,
        label: Text(
          "Salvar",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
