import 'package:appshop/shared/Widgets/input_decoration.dart';
import 'package:appshop/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';

Future<void> modalFiltroProduto({required BuildContext context}) async {
  RangeValues _currentRangeValues = const RangeValues(0, 0);

  final _productName = TextEditingController();
  final _description = TextEditingController();
  final _maxAccount = TextEditingController();
  late bool _onlyFavorites = false;
  late bool _onlyPromotionals = false;

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
                    color: AppColors.background,
                  ),
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.filter_list_alt),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Filtros',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: Icon(Icons.close),
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
                    color: Colors.white,
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
                                  'Digite o nome do produto',
                                  activityHint: true),
                            ),
                          ),
                          SizedBox(height: 20),
                          InputColumn(
                            title: 'Descrição',
                            input: TextFormField(
                              controller: _description,
                              decoration: getInputDecoration(
                                  'Digite uma palavra-chave',
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
                                          'R\$ ${_currentRangeValues.start.floor()}'),
                                      Text(
                                          'R\$ ${_currentRangeValues.end.floor()}'),
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
                            secondary: Icon(Icons.favorite),
                          ),
                          SwitchListTile(
                            value: _onlyPromotionals,
                            onChanged: (value) =>
                                setState(() => _onlyPromotionals = value),
                            title: Text('Apenas promocionais'),
                            subtitle:
                                Text('Mostrar somente produtos promocionais'),
                            secondary: Icon(Icons.local_offer),
                          ),
                          if (_onlyPromotionals)
                            Column(
                              children: [
                                SizedBox(height: 20),
                                InputColumn(
                                  title: 'Desconto mínimo',
                                  input: TextFormField(
                                    controller: _maxAccount,
                                    keyboardType: TextInputType.number,
                                    decoration: getInputDecoration(
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
                    color: AppColors.background,
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
                                    ))),
                            onPressed: limparFiltros,
                            child: Text('Limpar filtros')),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: aplicarFiltro,
                          child: Text(
                            'Aplicar filtros',
                            style: TextStyle(color: AppColors.white),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        input
      ],
    );
  }
}
