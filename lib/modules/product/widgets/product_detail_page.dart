import 'package:appshop/modules/cart/Provider/cart_provider.dart';
import 'package:appshop/modules/categorias/Provider/categorias_provider.dart';
import 'package:appshop/modules/product/Provider/product_provider.dart';
import 'package:appshop/modules/product/functions/adicionarproduto.dart';
import 'package:appshop/modules/product/widgets/carousel_images_product.dart';
import 'package:appshop/modules/product/widgets/discount_badge.dart';
import 'package:appshop/modules/product/widgets/product_grid.dart';
import 'package:appshop/modules/product/widgets/promotion_countdown_text.dart';
import 'package:appshop/shared/Models/product_model.dart';
import 'package:appshop/shared/Widgets/back_app_bar.dart';
import 'package:appshop/shared/Widgets/badgee.dart';
import 'package:appshop/shared/Widgets/image_fallback_icon.dart';
import 'package:appshop/shared/Widgets/send_button.dart';
import 'package:appshop/shared/constants/app_colors.dart';
import 'package:appshop/shared/constants/app_routes.dart';
import 'package:appshop/shared/utils/flushbar_helper.dart';
import 'package:appshop/shared/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel? product;

  ProductDetailPage({this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  ProductModel? _productFromRouteOrProvider(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is ProductModel) return args;
    if (args is String) {
      final list =
          Provider.of<ProductProvider>(context, listen: false).produtos;
      try {
        return list.firstWhere((p) => p.id == args);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final initialProduct =
        widget.product ?? _productFromRouteOrProvider(context);
    if (initialProduct == null) {
      return Scaffold(
        appBar:
            AppBar(title: Text('Produto'), backgroundColor: AppColors.primary),
        body: Center(child: Text('Produto não encontrado.')),
      );
    }

    final productList = Provider.of<ProductProvider>(context);
    ProductModel product;
    try {
      product =
          productList.produtos.firstWhere((p) => p.id == initialProduct.id);
    } catch (_) {
      product = initialProduct;
    }

    late int unidadesArredondadas;

    if (product.quantity >= 100) {
      unidadesArredondadas = (product.quantity / 100).floor() * 100;
    } else if (product.quantity >= 10) {
      unidadesArredondadas = (product.quantity / 10).floor() * 10;
    } else {
      unidadesArredondadas = product.quantity;
    }

    final cart = Provider.of<CartProvider>(context);

    final _categories = Provider.of<CategoriasProvider>(context, listen: false);
    final List<String> _nomesCategorias =
        _categories.getNomesCategorias(product.categories);

    final List<ProductModel> _produtosDaCategoria =
        Provider.of<ProductProvider>(context)
            .produtos
            .where((produto) =>
                produto.id != product.id &&
                produto.categories
                    .any((categoria) => product.categories.contains(categoria)))
            .toList();

    void handleBuy() {
      cart.adcItemAoCarrinho(product);
      Navigator.of(context).pushNamed(AppRoutes.CART);
    }

    Future<void> toggleFavorite() async {
      try {
        await productList.adicionarOuRemoverFavorito(product.id);
      } catch (e) {
        showAppFlushbar(context,
            message: e.toString().replaceAll('Exception:', ''),
            type: FlushType.error);
      }
    }

    return Scaffold(
      appBar: BackAppBar(
        title: "Informações do produto",
        actions: [
          Consumer<CartProvider>(
            child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.CART),
                icon: Icon(
                  Icons.shopping_cart,
                  color: AppColors.white,
                )),
            builder: (ctx, cart, child) => Badgee(
              value: cart.totalDeItens.toString(),
              child: child!,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 22),
                  Stack(
                    children: [
                      product.imageUrls.isNotEmpty
                          ? CarouselImagesProduct(product.imageUrls)
                          : AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                child: ImageFallbackIcon(size: 120),
                              ),
                            ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: Color.fromRGBO(220, 220, 220, 0.4),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(60),
                              onTap: () async => toggleFavorite(),
                              splashColor: Colors.redAccent.withOpacity(0.2),
                              child: Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(
                                    product.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: product.isFavorite
                                        ? Colors.redAccent
                                        : null),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  if (product.isPromotional)
                    DiscountBadge(
                      percentage: product.discountPercentage!,
                      fontSize: 15,
                    ),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  if (product.isPromotional)
                    Text(
                      formatPrice(
                        product.price,
                      ),
                      style: TextStyle(
                          fontSize: 15,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.black.withOpacity(0.5),
                          color: AppColors.black.withOpacity(0.5)),
                    ),
                  Text(
                    formatPrice(
                      product.valorFinalDoProduto(),
                    ),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  PromotionCountdownText(
                    isPromotional: product.isPromotional,
                    promotionEndDate: product.promotionEndDate,
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                              _nomesCategorias.length > 1
                                  ? "Categorias: "
                                  : "Categoria: ",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(_nomesCategorias.join((', '))),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text("Descrição:",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(product.description),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              unidadesArredondadas < product.quantity
                                  ? 'Unidades disponíveis: + de $unidadesArredondadas'
                                  : 'Unidades disponíveis: ${product.quantity}',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    child: SendButton("Comprar agora", handleBuy),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => ProductMethod.adicionarProdutoAoCarrinho(
                      cart: cart,
                      context: context,
                      product: product,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart, color: AppColors.primary),
                        SizedBox(width: 12),
                        Text("Adicionar ao carrinho",
                            style: TextStyle(color: AppColors.primary)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            if (_produtosDaCategoria.isNotEmpty)
              ProductGrid(
                list_products: _produtosDaCategoria,
                quantityGrid: 4,
                gridHorizontal: true,
                title: "Produtos da mesma categoria",
              ),
          ],
        ),
      ),
    );
  }
}
