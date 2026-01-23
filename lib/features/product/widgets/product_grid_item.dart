import 'package:appshop/core/utils/formatters.dart';
import 'package:appshop/core/utils/snackbar_helper.dart';
import 'package:appshop/features/cart/Provider/cart_provider.dart';
import 'package:appshop/features/product/Provider/product_provider.dart';
import 'package:appshop/features/product/widgets/product_detail_page.dart';
import 'package:appshop/shared/Widgets/image_fallback_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context);
    final cart = Provider.of<CartProvider>(context);

    void _selectPage(BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: product,
            child: ProductDetailPage(),
          ),
        ),
      );
    }

    void _addProduct() {
      cart.addItem(product.product);
      SnackbarHelper.showAddToCartMessage(
        context,
        product.name,
      );
    }

    return GestureDetector(
      onTap: () => _selectPage(context),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(width: 1, color: Colors.grey.shade300),
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
                              product.imageUrls.first,
                              fit: BoxFit.cover,
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
                        onTap: _addProduct,
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
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        formatPrice(product.price),
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
