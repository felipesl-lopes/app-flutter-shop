import 'package:appshop/core/utils/formatters.dart';
import 'package:appshop/core/widgets/image_fallback_icon.dart';
import 'package:appshop/modules/avaliacao/enum/scale_size.dart';
import 'package:appshop/modules/avaliacao/widgets/rating_bar_widget.dart';
import 'package:appshop/modules/cart/providers/cart_provider.dart';
import 'package:appshop/modules/product/functions/adicionarproduto.dart';
import 'package:appshop/modules/product/models/product_model.dart';
import 'package:appshop/modules/product/pages/product_detail_page.dart';
import 'package:appshop/modules/product/widgets/discount_badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGridItem extends StatelessWidget {
  final ProductModel product;

  ProductGridItem({required this.product});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final cart = Provider.of<CartProvider>(context);

    void _navegar(BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProductDetailPage(product: product),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _navegar(context),
      child: Container(
        decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            border: Border.all(
              width: 2,
              color: colorScheme.outlineVariant.withOpacity(0.2),
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
                  if (product.quantity > 0)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest
                              .withOpacity(0.7),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: InkWell(
                          onTap: () => ProductMethod.adicionarProdutoAoCarrinho(
                            cart: cart,
                            context: context,
                            product: product,
                          ),
                          child: Icon(
                            Icons.shopping_cart,
                            size: 20,
                            color: colorScheme.primary,
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
                    if (product.quantity <= 0)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Indisponível'),
                      ),
                    if (product.isPromotional)
                      DiscountBadge(
                        percentage: product.discountPercentage!,
                        fontSize: 12,
                      ),
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 15, color: colorScheme.onSurface),
                    ),
                    if (product.isPromotional)
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          formatPrice(product.price),
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              decorationColor:
                                  colorScheme.onSurface.withOpacity(0.5),
                              color: colorScheme.onSurface.withOpacity(0.5)),
                        ),
                      ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        formatPrice(product.valorFinalDoProduto()),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface),
                      ),
                    ),
                    RatingBarWidget(
                      scaleSize: ScaleSize.small,
                      notaMedia: product.notaMedia,
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
