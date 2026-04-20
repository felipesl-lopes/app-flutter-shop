import 'package:appshop/modules/cart/Provider/cart_provider.dart';
import 'package:appshop/modules/cart/Widgets/quantity_button.dart';
import 'package:appshop/shared/Models/cart_item_model.dart';
import 'package:appshop/shared/Widgets/image_avatar.dart';
import 'package:appshop/shared/constants/app_colors.dart';
import 'package:appshop/shared/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;

  CartItemWidget(this.cartItem);

  @override
  Widget build(BuildContext context) {
    final CartProvider cart = Provider.of<CartProvider>(context);

    Future<bool?> showRemoveItemDialog() {
      return showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Remover"),
          content: Text(
              "Deseja remover o produto ${cartItem.product.name} do carrinho?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text("Não"),
            ),
            TextButton(
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false)
                    .removeSingleItem(cartItem.product.id);
                Navigator.of(ctx).pop(true);
              },
              child: Text("Sim"),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ImageAvatar(
              imageUrl: cartItem.product.imageUrls.isNotEmpty
                  ? cartItem.product.imageUrls.first.value
                  : '',
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${cartItem.product.name}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "Total: ${formatPrice(cartItem.product.price * cartItem.quantity)}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(formatPrice(cartItem.product.price)),
                      Row(
                        children: [
                          QuantityButton(
                            onTap: () => {
                              cartItem.quantity == 1
                                  ? showRemoveItemDialog()
                                  : cart.removeSingleItem(cartItem.product.id)
                            },
                            icon: Icons.remove,
                          ),
                          Container(
                            child: Text(
                              cartItem.quantity.toString(),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
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
                              onTap: () => cart.addItem(cartItem.product),
                              icon: Icons.add),
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
