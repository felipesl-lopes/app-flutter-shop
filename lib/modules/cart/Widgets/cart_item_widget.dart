import 'package:appshop/modules/cart/Provider/cart_provider.dart';
import 'package:appshop/modules/cart/Widgets/quantity_button.dart';
import 'package:appshop/shared/Models/cart_item_model.dart';
import 'package:appshop/shared/Models/product_model.dart';
import 'package:appshop/shared/Widgets/image_avatar.dart';
import 'package:appshop/shared/constants/app_colors.dart';
import 'package:appshop/shared/utils/flushbar_helper.dart';
import 'package:appshop/shared/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;

  CartItemWidget(this.cartItem);

  @override
  Widget build(BuildContext context) {
    final CartProvider cart = Provider.of<CartProvider>(context);
    final ProductModel product = cartItem.product;

    Future<bool?> showRemoveItemDialog() {
      return showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Remover"),
          content:
              Text("Deseja remover o produto ${product.name} do carrinho?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text("Não"),
            ),
            TextButton(
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false)
                    .removeSingleItem(product.id);
                Navigator.of(ctx).pop(true);
              },
              child: Text("Sim"),
            ),
          ],
        ),
      );
    }

    final _productWithDiscount =
        product.isPromotional ? product.valorFinalDoProduto() : null;

    return Card(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            InkWell(
              child: ImageAvatar(
                imageUrl: product.imageUrls.isNotEmpty
                    ? product.imageUrls.first.value
                    : '',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Unid. disponíveis: ${product.quantity.toString()}'),
                          Row(
                            children: [
                              Text(
                                formatPrice(product.price),
                                style: _productWithDiscount == null
                                    ? null
                                    : TextStyle(
                                        fontSize: 15,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor:
                                            AppColors.black.withOpacity(0.5),
                                        color: AppColors.black.withOpacity(0.5),
                                      ),
                              ),
                              SizedBox(width: 6),
                              if (_productWithDiscount != null)
                                Text(formatPrice(_productWithDiscount)),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            formatPrice(_productWithDiscount ??
                                cartItem.product.price * cartItem.quantity),
                          ),
                          Row(
                            children: [
                              QuantityButton(
                                onTap: () => {
                                  cartItem.quantity == 1
                                      ? showRemoveItemDialog()
                                      : cart.removeSingleItem(product.id)
                                },
                                icon: Icons.remove,
                              ),
                              Container(
                                child: Text(
                                  cartItem.quantity.toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                height: 28,
                                width: 40,
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.5, color: AppColors.grey),
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              QuantityButton(
                                  onTap: () async {
                                    try {
                                      await cart.adcItemAoCarrinho(product);
                                    } catch (e) {
                                      showAppFlushbar(
                                        context,
                                        message: e.toString(),
                                        type: FlushType.error,
                                      );
                                    }
                                  },
                                  icon: Icons.add),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
