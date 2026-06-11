import 'package:appshop/core/widgets/input_decoration.dart';
import 'package:flutter/material.dart';

Future<void> modalFiltroProduto({required BuildContext context}) async {
  final colorScheme = Theme.of(context).colorScheme;

  RangeValues _currentRangeValues = const RangeValues(0, 0);

  final _productName = TextEditingController();
  final _description = TextEditingController();
  final _maxAccount = TextEditingController();
  late bool _onlyFavorites = false;
  late bool _onlyPromotionals = false;
  final FocusNode promocionalFocus = FocusNode();

  return showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (context, setState) {
        void limparFiltros() {
          setState(() {
            _currentRangeValues = RangeValues(0, 0);
            _productName.text = '';
            _description.text = '';
            _onlyPromotionals = false;
            _onlyFavorites = false;
          });
        }

        void aplicarFiltro() {
          print(_productName.text);
          print(_description.text);
        }

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    color: colorScheme.surfaceContainerLowest,
                  ),
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.filter_list_alt, color: colorScheme.onSurface),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Filtros',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: Icon(Icons.close, color: colorScheme.onSurface),
                        style: IconButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    color: colorScheme.surface,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          InputColumn(
                            title: 'Nome do produto',
                            input: TextFormField(
                              controller: _productName,
                              decoration: getInputDecoration(
                                  context, 'Digite o nome do produto',
                                  activityHint: true),
                            ),
                          ),
                          SizedBox(height: 20),
                          InputColumn(
                            title: 'Descrição',
                            input: TextFormField(
                              controller: _description,
                              decoration: getInputDecoration(
                                  context, 'Digite uma palavra-chave',
                                  activityHint: true),
                            ),
                          ),
                          SizedBox(height: 20),
                          InputColumn(
                              title: 'Faixa de preço',
                              input: Column(
                                children: [
                                  RangeSlider(
                                    min: 0,
                                    max: 1000,
                                    values: _currentRangeValues,
                                    labels: RangeLabels(
                                      _currentRangeValues.start
                                          .round()
                                          .toString(),
                                      _currentRangeValues.end
                                          .round()
                                          .toString(),
                                    ),
                                    onChanged: (RangeValues values) {
                                      setState(() {
                                        double start =
                                            (values.start / 10).round() * 10;
                                        double end =
                                            (values.end / 10).round() * 10;
                                        _currentRangeValues =
                                            RangeValues(start, end);
                                      });
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'R\$ ${_currentRangeValues.start.floor()}',
                                        style: TextStyle(
                                            color: colorScheme.onSurface),
                                      ),
                                      Text(
                                        'R\$ ${_currentRangeValues.end.floor()}',
                                        style: TextStyle(
                                            color: colorScheme.onSurface),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          SizedBox(height: 20),
                          InputColumn(
                            title: 'Categorias',
                            input: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 12),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: colorScheme.outlineVariant),
                                  borderRadius: BorderRadius.circular(8)),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                minVerticalPadding: 0,
                                visualDensity: VisualDensity.compact,
                                title: Text(
                                  'Selecionar categoria',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: colorScheme.onSurfaceVariant),
                                ),
                                trailing: Icon(Icons.arrow_drop_down,
                                    color: colorScheme.onSurface),
                                onTap: () {
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SwitchListTile(
                            value: _onlyFavorites,
                            onChanged: (value) =>
                                setState(() => _onlyFavorites = value),
                            title: Text('Apenas favoritos'),
                            subtitle:
                                Text('Mostrar somente produtos favoritos'),
                            secondary: Icon(Icons.favorite,
                                color: colorScheme.primary),
                          ),
                          SwitchListTile(
                            value: _onlyPromotionals,
                            onChanged: (value) {
                              setState(() => _onlyPromotionals = value);
                              if (value) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  promocionalFocus.requestFocus();
                                });
                              }
                            },
                            title: Text('Apenas promocionais'),
                            subtitle:
                                Text('Mostrar somente produtos promocionais'),
                            secondary: Icon(Icons.local_offer,
                                color: colorScheme.primary),
                          ),
                          if (_onlyPromotionals)
                            Column(
                              children: [
                                SizedBox(height: 20),
                                InputColumn(
                                  title: 'Desconto mínimo',
                                  input: TextFormField(
                                    focusNode: promocionalFocus,
                                    controller: _maxAccount,
                                    keyboardType: TextInputType.number,
                                    decoration: getInputDecoration(context,
                                        'Digite a porcentagem de desconto',
                                        activityHint: true),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    color: colorScheme.surfaceContainerLowest,
                  ),
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: BorderSide(
                                      width: 1,
                                      color: colorScheme.outlineVariant,
                                    ))),
                            onPressed: limparFiltros,
                            child: Text(
                              'Limpar filtros',
                              style: TextStyle(color: colorScheme.onSurface),
                            )),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: aplicarFiltro,
                          child: Text(
                            'Aplicar filtros',
                            style: TextStyle(color: colorScheme.onPrimary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class InputColumn extends StatelessWidget {
  final String title;
  final Widget input;

  const InputColumn({
    required this.title,
    required this.input,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
        SizedBox(height: 8),
        input
      ],
    );
  }
}
