import 'package:appshop/modules/cart/Provider/cart_provider.dart';
import 'package:appshop/modules/product/widgets/discount_badge.dart';
import 'package:appshop/modules/product/widgets/product_detail_page.dart';
import 'package:appshop/shared/Models/product_model.dart';
import 'package:appshop/shared/Widgets/image_fallback_icon.dart';
import 'package:appshop/shared/utils/formatters.dart';
import 'package:appshop/shared/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGridItem extends StatelessWidget {
  final ProductModel product;

  ProductGridItem({required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    void _navegar(BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProductDetailPage(product: product),
        ),
      );
    }

    void _adicionarProdutoAoCarrinho() {
      cart.addItem(product);
      SnackbarHelper.showAddToCartMessage(
        context,
        product.name,
      );
    }

    return GestureDetector(
      onTap: () => _navegar(context),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(
              width: 1,
              color: Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: product.imageUrls.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                            child: Image.network(
                              product.imageUrls.first.value,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return ImageFallbackIcon(size: 48);
                              },
                            ),
                          )
                        : Container(
                            child: ImageFallbackIcon(size: 48),
                          ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: InkWell(
                        onTap: _adicionarProdutoAoCarrinho,
                        child: const Icon(
                          Icons.shopping_cart,
                          size: 20,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.isPromotional)
                      DiscountBadge(
                        percentage: product.discountPercentage!,
                        fontSize: 12,
                      ),
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15),
                    ),
                    if (product.isPromotional)
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          formatPrice(product.price),
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.black45,
                              color: Colors.black45),
                        ),
                      ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        formatPrice(
                          discountPercentageAsDouble(
                            product.discountPercentage.toString(),
                            product.price.toString(),
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
