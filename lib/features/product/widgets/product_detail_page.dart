import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/core/models/product_model.dart';
import 'package:appshop/core/utils/flushbar_helper.dart';
import 'package:appshop/core/utils/formatters.dart';
import 'package:appshop/core/utils/snackbar_helper.dart';
import 'package:appshop/features/cart/Provider/cart_provider.dart';
import 'package:appshop/features/product/Provider/product_provider.dart';
import 'package:appshop/features/product/widgets/carousel_images_product.dart';
import 'package:appshop/shared/Widgets/badgee.dart';
import 'package:appshop/shared/Widgets/image_fallback_icon.dart';
import 'package:appshop/shared/Widgets/send_button.dart';
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
        appBar: AppBar(title: Text('Produto'), backgroundColor: Colors.purple),
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

    final cart = Provider.of<CartProvider>(context);

    void handleBuy() {
      cart.addItem(product);
      Navigator.of(context).pushNamed(AppRoutes.CART);
    }

    Future<void> toggleFavorite() async {
      try {
        await productList.toggleFavorite(product.id);
        showAppFlushbar(context,
            message: product.isFavorite
                ? "Produto favoritado."
                : "Produto desfavoritado.",
            type: FlushType.info);
      } catch (e) {
        showAppFlushbar(context,
            message: "Não foi possível realizar a ação.",
            type: FlushType.error);
        debugPrint("Erro: $e");
      }
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Informações do produto",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        actions: [
          Consumer<CartProvider>(
            child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.CART),
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                )),
            builder: (ctx, cart, child) => Badgee(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
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
              Text(
                product.name,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(formatPrice(product.price),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Descrição:",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(product.description),
                  ],
                ),
              ),
              SizedBox(height: 20),
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
                onPressed: () {
                  cart.addItem(product);
                  SnackbarHelper.showAddToCartMessage(
                    context,
                    product.name,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart, color: Colors.purple),
                    SizedBox(width: 12),
                    Text("Adicionar ao carrinho",
                        style: TextStyle(color: Colors.purple)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
