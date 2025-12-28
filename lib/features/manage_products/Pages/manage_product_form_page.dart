import 'package:appshop/core/utils/product_validators.dart';
import 'package:appshop/features/product/Provider/product_provider.dart';
import 'package:appshop/features/product/Provider/product_list.dart';
import 'package:appshop/shared/Widgets/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _imageUrlController = TextEditingController();
  final _nameFocus = FocusNode();
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;
  ProductProvider? _editedProduct;

  @override
  void dispose() {
    super.dispose();
    _nameFocus.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_editedProduct == null) {
      final arg = ModalRoute.of(context)!.settings.arguments;
      if (arg != null) {
        _editedProduct = arg as ProductProvider;
        _formData["id"] = _editedProduct!.id;
        _formData["name"] = _editedProduct!.name;
        _formData["price"] = _editedProduct!.price;
        _formData["description"] = _editedProduct!.description;
        _formData["imageUrl"] = _editedProduct!.imageUrl;

        _imageUrlController.text = _editedProduct!.imageUrl;
      }
    }
  }

  void updateImage() {
    setState(() {});
  }

  Future<void> _submitForm() async {
    final isValidy = _formKey.currentState?.validate() ?? false;
    if (!isValidy) {
      return;
    }
    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    try {
      await Provider.of<ProductList>(
        context,
        listen: false,
      ).saveProduct(_formData);
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: getInputDecoration("Nome"),
                      initialValue: _formData["name"]?.toString(),
                      focusNode: _nameFocus,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_nameFocus),
                      textInputAction: TextInputAction.next,
                      onSaved: (name) => _formData["name"] = name ?? "",
                      validator: (value) => isValidName(value ?? ""),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: getInputDecoration("Preço"),
                      initialValue: _formData["price"]?.toString(),
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocus,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocus),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      onSaved: (price) =>
                          _formData["price"] = double.parse(price ?? "0"),
                      validator: (value) => isValidPrice(value ?? ""),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: getInputDecoration("Descrição"),
                      initialValue: _formData["description"]?.toString(),
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocus,
                      maxLines: 5,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocus),
                      textInputAction: TextInputAction.next,
                      onSaved: (description) =>
                          _formData["description"] = description ?? "",
                      validator: (value) => isValidDescription(value ?? ""),
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: getInputDecoration("URL da imagem"),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocus,
                            onSaved: (imageUrl) =>
                                _formData["imageUrl"] = imageUrl ?? "",
                            validator: (value) => isValidImageUrl(value ?? ""),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 10),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text("Informe a URL")
                              : Container(
                                  width: 100,
                                  height: 100,
                                  child: FittedBox(
                                    child:
                                        Image.network(_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          alignment: Alignment.center,
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
