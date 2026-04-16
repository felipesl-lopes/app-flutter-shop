import 'dart:math';

import 'package:appshop/modules/categorias/Models/categorias_model.dart';
import 'package:appshop/modules/categorias/Provider/categorias_provider.dart';
import 'package:appshop/modules/product/Provider/product_provider.dart';
import 'package:appshop/shared/Models/product_image_model.dart';
import 'package:appshop/shared/Models/product_model.dart';
import 'package:appshop/shared/Widgets/back_app_bar.dart';
import 'package:appshop/shared/Widgets/input_decoration.dart';
import 'package:appshop/shared/constants/app_colors.dart';
import 'package:appshop/shared/core/errors/generic_exception.dart';
import 'package:appshop/shared/helpers/app_alert.dart';
import 'package:appshop/shared/utils/flushbar_helper.dart';
import 'package:appshop/shared/utils/formatters.dart';
import 'package:appshop/shared/utils/product_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoriesController = TextEditingController();
  final _percentageController = TextEditingController();
  final _promotionDateController = TextEditingController();

  List<String> _selectedCategories = [];
  List<ProductImageModel> _imageUrls = [];
  bool _isInit = true;
  bool _isLoading = false;
  ProductModel? _editedProduct;

  late Map<String, dynamic> _initialFormData;
  bool _hasChanges = false;
  late var _produtoPromocional = false;
  bool _maxDateWarningShown = false;
  bool _maxPercentageWarningShown = false;

  double parsePrice(String value) {
    final clean = value.replaceAll('.', '').replaceAll(',', '.').trim();
    return double.tryParse(clean) ?? 0;
  }

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
    final price = parsePrice(_priceController.text);
    final quantity = int.parse(_quantityController.text);
    final description = _descriptionController.text.trim();
    final imageUrls = _imageUrls;
    final categories = _selectedCategories;

    final data = <String, Object>{
      "name": name,
      "price": price,
      "quantity": quantity,
      "description": description,
      "imageUrls": imageUrls,
      "categories": categories,
    };

    if ((_percentageController.value.text.isNotEmpty ||
            _promotionDateController.value.text.isNotEmpty) &&
        _produtoPromocional == false) {}

    if (_produtoPromocional) {
      final percentage = int.tryParse(
            _percentageController.text.trim(),
          ) ??
          0;

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
      await AppAlert.showError(context, message: error.toString());
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
        _quantityController.text = _editedProduct!.quantity.toString();
        _descriptionController.text = _editedProduct!.description;
        _imageUrls = List.from(_editedProduct!.imageUrls);
        _selectedCategories = List.from(_editedProduct!.categories);
        _percentageController.text = _editedProduct!.discountPercentage != null
            ? _editedProduct!.discountPercentage.toString()
            : "";
        _promotionDateController.text = _editedProduct!.promotionEndDate != null
            ? convertDateDifference(_editedProduct!.promotionEndDate!)
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
      'quantity': _quantityController.text.trim(),
      'description': _descriptionController.text.trim(),
      'imageUrls': _imageUrls.map((e) => e.value).toList(),
      'selectedCategories': List<String>.from(_selectedCategories)..sort(),
      'discountPercentage': _percentageController.text.trim(),
      'promotionEndDate': _promotionDateController.text.trim(),
    };
  }

  void _checkForChanges() {
    final current = _getCurrentFormData();

    final hasChanged = current['name'] != _initialFormData['name'] ||
        current['price'] != _initialFormData['price'] ||
        current['description'] != _initialFormData['description'] ||
        !_listEquals(
          current['selectedCategories'],
          _initialFormData['selectedCategories'],
        ) ||
        !_listEquals(
          current['imageUrls'],
          _initialFormData['imageUrls'],
        ) ||
        current['discountPercentage'] !=
            _initialFormData['discountPercentage'] ||
        current['promotionEndDate'] != _initialFormData['promotionEndDate'] ||
        current['quantity'] != _initialFormData['quantity'];

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
    _quantityController.dispose();
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
          appBar: BackAppBar(
            title:
                _editedProduct == null ? "Adicionar produto" : "Editar produto",
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
                              } catch (error) {
                                AppAlert.showError(context,
                                    message: error.toString());
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
                          decoration: getInputDecoration("Nome do produto",
                              activityLabel: true),
                          validator: (value) => isValidName(value ?? ""),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            minVerticalPadding: 0,
                            visualDensity: VisualDensity.compact,
                            title: Text(
                              'Selecionar categoria',
                              style: TextStyle(
                                  fontSize: 16, color: AppColors.grey),
                            ),
                            trailing: Icon(Icons.arrow_drop_down),
                            onTap: () {
                              setState(() {
                                _checkForChanges();
                              });
                              selecionarCategorias(context, categorias);
                            },
                          ),
                        ),
                        SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _selectedCategories.map((id) {
                              final categoria =
                                  categorias.firstWhere((c) => c.id == id);
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                margin: EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    Text(categoria.nome),
                                    IconButton(
                                      constraints: BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      style: ButtonStyle(
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () {
                                        setState(() {});
                                        _selectedCategories
                                            .remove(categoria.id);
                                        _checkForChanges();
                                      },
                                      icon: Icon(Icons.close, size: 18),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                inputFormatters: [
                                  TextInputFormatter.withFunction(
                                      (oldValue, newValue) {
                                    String digits = newValue.text
                                        .replaceAll(RegExp(r'\D'), '');

                                    if (digits.isEmpty) {
                                      return newValue.copyWith(text: '');
                                    }

                                    double value = double.parse(digits) / 100;

                                    final formatter = NumberFormat.currency(
                                      locale: 'pt_BR',
                                      symbol: '',
                                    );

                                    final newText = formatter.format(value);

                                    return TextEditingValue(
                                      text: newText,
                                      selection: TextSelection.collapsed(
                                          offset: newText.length),
                                    );
                                  }),
                                ],
                                controller: _priceController,
                                onChanged: (_) => _checkForChanges(),
                                decoration: getInputDecoration("Preço unitário",
                                    activityLabel: true),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'Informe um valor';
                                  final price = parsePrice(value);
                                  if (price <= 0) return 'Valor inválido';
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: TextFormField(
                                controller: _quantityController,
                                onChanged: (_) => _checkForChanges(),
                                decoration: getInputDecoration("Unidades",
                                    activityLabel: true),
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    isValidQuantity(value ?? ""),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _descriptionController,
                          onChanged: (_) => _checkForChanges(),
                          decoration: getInputDecoration(
                              "Adicione todas as descrições do produto.",
                              activityHint: true),
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
                                    decoration: getInputDecoration(
                                        "URL da imagem",
                                        activityLabel: true),
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
                                                  color: AppColors.grey,
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
                                              color: AppColors.grey
                                                  .withOpacity(0.7),
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
                                        ? AppColors.black.withOpacity(0.7)
                                        : AppColors.black.withOpacity(0.4),
                                  ),
                                ),
                                Switch(
                                  value: _produtoPromocional,
                                  onChanged: (value) {
                                    setState(() {
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
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              onChanged: (value) {
                                                final number =
                                                    int.tryParse(value);

                                                if (number != null &&
                                                    number > 100) {
                                                  if (!_maxDateWarningShown) {
                                                    showAppFlushbar(context,
                                                        message:
                                                            "Desconto máximo excedido.",
                                                        type: FlushType.warning,
                                                        position:
                                                            FlushPosition.top);
                                                    _maxDateWarningShown = true;
                                                  }

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
                                                } else {
                                                  _maxDateWarningShown = false;
                                                }

                                                setState(() {});
                                                _checkForChanges();
                                              },
                                              decoration:
                                                  getInputDecoration(""),
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty)
                                                  return 'Informe um valor';
                                                final price = parsePrice(value);
                                                if (price <= 0)
                                                  return 'Valor inválido';
                                                return null;
                                              },
                                            ),
                                          ),
                                          Text(" % de desconto.")
                                        ],
                                      ),
                                      if (_percentageController
                                          .value.text.isNotEmpty)
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
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              decoration:
                                                  getInputDecoration(""),
                                              onChanged: (value) {
                                                final number =
                                                    int.tryParse(value);

                                                if (number != null &&
                                                    number > 30) {
                                                  if (!_maxPercentageWarningShown) {
                                                    showAppFlushbar(context,
                                                        message:
                                                            "Data máxima excedida.",
                                                        type: FlushType.warning,
                                                        position:
                                                            FlushPosition.top);

                                                    _maxPercentageWarningShown =
                                                        true;
                                                  }
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
                                                } else {
                                                  _maxPercentageWarningShown =
                                                      false;
                                                }

                                                setState(() {});
                                                _checkForChanges();
                                              },
                                            ),
                                          ),
                                          Text(" Dias promocionais.")
                                        ],
                                      ),
                                      if (_promotionDateController
                                          .value.text.isNotEmpty)
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
                _hasChanges && !_isLoading ? AppColors.primary : AppColors.grey,
            label: Text(
              "Salvar",
              style: TextStyle(color: AppColors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> selecionarCategorias(
      BuildContext context, List<CategoriasModel> categorias) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Selecionar categoria', textAlign: TextAlign.center),
              content: SizedBox(
                height: 400,
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: categorias.length,
                  itemBuilder: (context, index) {
                    final categoria = categorias[index];
                    return CheckboxListTile(
                      title: Text(categoria.nome),
                      value: _selectedCategories.contains(categoria.id),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            if (_selectedCategories.length == 3) {
                              showAppFlushbar(
                                context,
                                message:
                                    'Você pode selecionar no máximo 3 categorias.',
                                type: FlushType.error,
                                position: FlushPosition.top,
                              );
                              return;
                            }
                            _selectedCategories.add(categoria.id);
                          } else {
                            _selectedCategories.remove(categoria.id);
                          }
                        });
                        _checkForChanges();
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Text('Fechar'))
              ],
            );
          },
        );
      },
    );
  }
}
