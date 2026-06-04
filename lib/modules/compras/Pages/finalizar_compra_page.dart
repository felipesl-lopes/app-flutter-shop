import 'package:appshop/modules/cart/Provider/cart_provider.dart';
import 'package:appshop/modules/compras/Provider/order_list_provider.dart';
import 'package:appshop/modules/compras/Widgets/endereco_resumo_card.dart';
import 'package:appshop/modules/endereco/Provider/endereco_provider.dart';
import 'package:appshop/shared/Models/endereco_model.dart';
import 'package:appshop/shared/Widgets/back_app_bar.dart';
import 'package:appshop/shared/Widgets/send_button.dart';
import 'package:appshop/shared/constants/app_routes.dart';
import 'package:appshop/shared/helpers/app_alert.dart';
import 'package:appshop/shared/utils/flushbar_helper.dart';
import 'package:appshop/shared/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinalizarCompraPage extends StatefulWidget {
  const FinalizarCompraPage({super.key});

  @override
  State<FinalizarCompraPage> createState() => _FinalizarCompraPageState();
}

class _FinalizarCompraPageState extends State<FinalizarCompraPage> {
  bool _isLoading = false;
  bool _showSecondStep = false;

  void _startLoadingSteps() {
    setState(() {
      _isLoading = true;
      _showSecondStep = false;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted || !_isLoading) return;

      setState(() {
        _showSecondStep = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final enderecoId = ModalRoute.of(context)!.settings.arguments as String;

    final cartProvider = Provider.of<CartProvider>(context);
    final List<EnderecoModel> enderecoList =
        Provider.of<EnderecoProvider>(context).enderecos;
    final cart = cartProvider.carrinhoDeProdutos;
    final enderecoCompleto = enderecoList.firstWhere((e) => e.id == enderecoId);

    Future<void> handleBuy() async {
      setState(() {
        _isLoading = true;
      });

      _startLoadingSteps();

      try {
        await Provider.of<OrderListProvider>(context, listen: false)
            .finalizarCompra(cartProvider, enderecoId);

        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.HOME, (route) => false);

        showAppFlushbar(context,
            message: "Compra realizada com sucesso!",
            type: FlushType.success,
            position: FlushPosition.top);
      } catch (e) {
        debugPrint(e.toString());

        AppAlert.showError(context, message: e.toString());
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }

    return Stack(
      children: [
        Scaffold(
          appBar: BackAppBar(title: 'Finalizar compra'),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Endereço selecionado:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: EnderecoResumoCard(endereco: enderecoCompleto),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Alterar endereço'),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Produtos:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (ctx, index) {
                      final item = cart[index];
                      final preco = item.product.valorFinalDoProduto();
                      final totalItem = preco * item.quantity;

                      return Card(
                        margin: EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(item.product.name),
                          subtitle: Text(
                            '${item.quantity} x ${formatPrice(preco)}',
                          ),
                          trailing: Text(
                            formatPrice(totalItem),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      formatPrice(cartProvider.valorTotal),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: SendButton('Confirmar compra', handleBuy),
                ),
              ],
            ),
          ),
        ),
        if (_isLoading)
          CheckoutProcessingOverlay(showSecondStep: _showSecondStep),
      ],
    );
  }
}

class CheckoutProcessingOverlay extends StatelessWidget {
  const CheckoutProcessingOverlay({
    super.key,
    required bool showSecondStep,
  }) : _showSecondStep = showSecondStep;

  final bool _showSecondStep;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(40),
          padding: EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 100,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: _showSecondStep
                      ? Column(
                          key: ValueKey('step2'),
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 40,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Finalizando seu pedido',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          key: ValueKey('step1'),
                          children: [
                            Icon(
                              Icons.shopping_cart_checkout,
                              size: 40,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Estamos reservando seus produtos',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 24),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
