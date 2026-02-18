import 'dart:math';

import 'package:appshop/core/errors/generic_exception.dart';
import 'package:appshop/core/models/product_image_model.dart';
import 'package:appshop/core/models/product_model.dart';
import 'package:appshop/core/utils/flushbar_helper.dart';
import 'package:appshop/core/utils/formatters.dart';
import 'package:appshop/core/utils/product_validators.dart';
import 'package:appshop/features/categorias/Provider/categorias_provider.dart';
import 'package:appshop/features/product/Provider/product_provider.dart';
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
  final _categoriesController = TextEditingController();
  final _percentageController = TextEditingController();
  final _promotionDateController = TextEditingController();

  String? _selectedCategory;

  List<ProductImageModel> _imageUrls = [];
  bool _isInit = true;
  bool _isLoading = false;
  ProductModel? _editedProduct;

  late Map<String, dynamic> _initialFormData;
  bool _hasChanges = false;
  late var _produtoPromocional = false;

  Future<void> _submitForm() async {
    final isValidy = _formKey.currentState?.validate() ?? false;
    if (!isValidy) {
      return;
    }

    if (_imageUrls.isEmpty) {
      showAppFlushbar(
        context,
        message: "Adicione pelo menos uma imagem.",
        type: FlushType.error,
        position: FlushPosition.top,
      );
      return;
    }

    setState(() => _isLoading = true);

    final name = _nameController.text.trim();
    final price = double.parse(_priceController.text);
    final description = _descriptionController.text.trim();
    final imageUrls = _imageUrls;
    final categories = _selectedCategory == null ? [] : [_selectedCategory!];

    final data = <String, Object>{
      "name": name,
      "price": price,
      "description": description,
      "imageUrls": imageUrls,
      "categories": categories,
    };

    if (_produtoPromocional) {
      final percentage = double.tryParse(
            _percentageController.text.replaceAll(',', '.').trim(),
          ) ??
          0.0;

      final days = int.tryParse(
            _promotionDateController.text.trim(),
          ) ??
          0;

      final promotionDate = DateTime.now().add(
        Duration(days: days),
      );

      data["isPromotional"] = true;
      data["discountPercentage"] = percentage;
      data["promotionEndDate"] = promotionDate.toIso8601String();
    }

    if (_editedProduct != null) {
      data["id"] = _editedProduct!.id;
    }

    try {
      await Provider.of<ProductProvider>(
        context,
        listen: false,
      ).salvarProduto(data);

      _initialFormData = _getCurrentFormData();
      _hasChanges = false;
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
      rethrow;
    } finally {
      setState(() => _isLoading = true);
      Navigator.of(context).pop();
    }
  }

  void _addImage() {
    final url = _imageUrlController.text.trim();

    if (url.isEmpty || isValidImageUrl(url) != null) {
      showAppFlushbar(
        context,
        message: url.isEmpty
            ? "Digite a URL da imagem."
            : "Tipo de imagem inválido.",
        type: FlushType.error,
        position: FlushPosition.top,
      );
      return;
    }

    if (_imageUrls.length >= 10) {
      showAppFlushbar(context,
          message: "Limite de imagens atingido.",
          type: FlushType.info,
          position: FlushPosition.top);
      return;
    }

    FocusScope.of(context).unfocus();

    final newImage =
        ProductImageModel(id: Random().nextDouble().toString(), value: url);

    setState(() {
      _imageUrls.add(newImage);
      _imageUrlController.clear();
      _checkForChanges();
    });
  }

  void _removeImage(String id) {
    setState(() {
      _imageUrls.removeWhere((img) => img.id == id);
    });
    _checkForChanges();
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Descartar alterações?'),
            content: Text('Você tem alterações não salvas.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text('Descartar'),
              ),
            ],
          ),
        ) ??
        false;
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
        _selectedCategory = _editedProduct!.categories.isNotEmpty
            ? _editedProduct!.categories.first
            : null;
        _percentageController.text =
            _editedProduct!.discountPercentage.toString();
        _promotionDateController.text = _editedProduct!.promotionEndDate != null
            ? _editedProduct!.promotionEndDate!
                .difference(DateTime.now())
                .inDays
                .toString()
            : '';
        _produtoPromocional = _editedProduct!.isPromotional;
      }

      _initialFormData = _getCurrentFormData();
      _isInit = false;
    }
  }

  Map<String, dynamic> _getCurrentFormData() {
    return {
      'name': _nameController.text.trim(),
      'price': _priceController.text.trim(),
      'description': _descriptionController.text.trim(),
      'imageUrls': _imageUrls.map((e) => e.value).toList(),
      'selectedCategory': _selectedCategory,
      'discountPercentage': _percentageController.text.trim(),
      'promotionEndDate': _promotionDateController.text.trim(),
      'isPromotional': _produtoPromocional,
    };
  }

  void _checkForChanges() {
    final current = _getCurrentFormData();

    final hasChanged = current['name'] != _initialFormData['name'] ||
        current['price'] != _initialFormData['price'] ||
        current['description'] != _initialFormData['description'] ||
        current['selectedCategory'] != _initialFormData['selectedCategory'] ||
        !_listEquals(
          current['imageUrls'],
          _initialFormData['imageUrls'],
        ) ||
        current['discountPercentage'] !=
            _initialFormData['discountPercentage'] ||
        current['promotionEndDate'] != _initialFormData['promotionEndDate'] ||
        current['isPromotional'] != _initialFormData['isPromotional'];

    if (hasChanged != _hasChanges) {
      setState(() => _hasChanges = hasChanged);
    }
  }

  bool _listEquals(List a, List b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _categoriesController.dispose();
    _percentageController.dispose();
    _promotionDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);

    final days = int.tryParse(_promotionDateController.text) ?? 0;

    final promotionDate = DateTime.now().add(
      Duration(days: days),
    );

    final categorias = Provider.of<CategoriasProvider>(context, listen: false)
        .categorias
        .toList();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              _editedProduct == null ? "Adicionar produto" : "Editar produto",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.purple,
            actions: [
              if (_editedProduct != null)
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Confirmar exclusão"),
                        content: Text(
                            "Deseja excluir o produto ${_editedProduct?.name}?"),
                        actions: [
                          TextButton(
                            child: Text("Cancelar"),
                            onPressed: () => {
                              Navigator.of(ctx).pop(),
                            },
                          ),
                          TextButton(
                            child: Text("Confirmar"),
                            onPressed: () async {
                              try {
                                Navigator.of(ctx).pop();
                                await Provider.of<ProductProvider>(
                                  context,
                                  listen: false,
                                ).deletarProduto(_editedProduct!);
                              } on GenericExeption catch (error) {
                                msg.showSnackBar(
                                    SnackBar(content: Text(error.toString())));
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
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
                          onChanged: (_) => _checkForChanges(),
                          decoration: getInputDecoration("Nome"),
                          validator: (value) => isValidName(value ?? ""),
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField(
                          value: _selectedCategory,
                          decoration: getInputDecoration("Categoria"),
                          items: categorias.map((categoria) {
                            return DropdownMenuItem(
                              value: categoria.id,
                              child: Text(categoria.nome),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                              _categoriesController.text = value ?? '';
                              _checkForChanges();
                            });
                          },
                          validator: (value) => isValidCategory(value ?? ""),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _priceController,
                          onChanged: (_) => _checkForChanges(),
                          decoration: getInputDecoration("Preço"),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          validator: (value) => isValidPrice(value ?? ""),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _descriptionController,
                          onChanged: (_) => _checkForChanges(),
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
                                    decoration:
                                        getInputDecoration("URL da imagem"),
                                    keyboardType: TextInputType.url,
                                  ),
                                ),
                                TextButton(
                                    onPressed: _addImage,
                                    child: Text("Adicionar imagem"))
                              ],
                            ),
                            SizedBox(height: 10),
                            Text("Imagens ${_imageUrls.length}/10"),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _imageUrls.map((image) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Image.network(
                                              image.value,
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 8,
                                          right: 8,
                                          child: Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.7),
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: InkWell(
                                              onTap: () =>
                                                  _removeImage(image.id),
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Produto promocional?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: _produtoPromocional
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade500,
                                  ),
                                ),
                                Switch(
                                  value: _produtoPromocional,
                                  onChanged: (value) {
                                    setState(() {
                                      _checkForChanges();
                                      _produtoPromocional = value;
                                    });
                                  },
                                )
                              ],
                            ),
                            if (_produtoPromocional)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            child: TextFormField(
                                              controller: _percentageController,
                                              onChanged: (value) {
                                                final number = double.tryParse(
                                                    value.replaceAll(',', '.'));

                                                if (number != null &&
                                                    number > 100) {
                                                  _percentageController.text =
                                                      "100";
                                                  _percentageController
                                                          .selection =
                                                      TextSelection
                                                          .fromPosition(
                                                    TextPosition(
                                                        offset:
                                                            _percentageController
                                                                .text.length),
                                                  );
                                                }
                                                setState(() {});
                                                _checkForChanges();
                                              },
                                              decoration:
                                                  getInputDecoration(""),
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              validator: (value) =>
                                                  isValidPrice(value ?? ""),
                                            ),
                                          ),
                                          Text(" % de desconto.")
                                        ],
                                      ),
                                      Text("Valor final: ${formatPrice(
                                        discountPercentageAsDouble(
                                            _percentageController.text,
                                            _priceController.text),
                                      )}")
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            child: TextFormField(
                                              controller:
                                                  _promotionDateController,
                                              decoration:
                                                  getInputDecoration(""),
                                              onChanged: (value) {
                                                final number = double.tryParse(
                                                    value.replaceAll(',', '.'));

                                                if (number != null &&
                                                    number > 30) {
                                                  _promotionDateController
                                                      .text = "30";
                                                  _promotionDateController
                                                          .selection =
                                                      TextSelection
                                                          .fromPosition(
                                                    TextPosition(
                                                        offset:
                                                            _promotionDateController
                                                                .text.length),
                                                  );
                                                }
                                                setState(() {});
                                                _checkForChanges();
                                              },
                                            ),
                                          ),
                                          Text(" Dias promocionais.")
                                        ],
                                      ),
                                      Text(
                                        "Data: ${promotionDate.day.toString().padLeft(2, '0')}/"
                                        "${promotionDate.month.toString().padLeft(2, '0')}/"
                                        "${promotionDate.year}",
                                      ),
                                    ],
                                  )
                                ],
                              ),
                          ],
                        ),
                        SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _hasChanges && !_isLoading ? _submitForm : null,
            backgroundColor:
                _hasChanges && !_isLoading ? Colors.purple : Colors.grey,
            label: Text(
              "Salvar",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
