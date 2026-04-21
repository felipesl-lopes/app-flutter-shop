import 'package:appshop/modules/cart/Provider/cart_provider.dart';
import 'package:appshop/shared/constants/app_colors.dart';
import 'package:appshop/shared/constants/app_routes.dart';
import 'package:appshop/shared/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardIncentivoCarrinho extends StatefulWidget {
  const CardIncentivoCarrinho({super.key});

  @override
  State<CardIncentivoCarrinho> createState() => _CardIncentivoCarrinhoState();
}

class _CardIncentivoCarrinhoState extends State<CardIncentivoCarrinho> {
  @override
  Widget build(BuildContext context) {
    final CartProvider _cartItens = Provider.of<CartProvider>(context);
    final bool _carrinhoVazio = _cartItens.carrinhoDeProdutos.isEmpty;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            _carrinhoVazio
                ? Navigator.of(context).pushNamed(AppRoutes.SEARCH_PRODUCT)
                : Navigator.of(context).pushNamed(AppRoutes.CART);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _carrinhoVazio
                        ? Icons.add_shopping_cart
                        : Icons.shopping_cart,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _carrinhoVazio
                            ? "Comece a comprar agora"
                            : "Finalize suas compras",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black.withOpacity(0.6),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _carrinhoVazio
                            ? "Explore nossos produtos e encontre o que você precisa"
                            : "${_cartItens.totalDeItens} ${_cartItens.carrinhoDeProdutos.length == 1 ? 'item' : 'itens'} • ${formatPrice(_cartItens.valorTotal)}",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.black.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.black.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
