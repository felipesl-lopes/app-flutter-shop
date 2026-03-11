import 'package:appshop/modules/product/widgets/product_grid_item.dart';
import 'package:appshop/shared/Models/product_model.dart';
import 'package:appshop/shared/constants/app_routes.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  final title;
  final int? quantityGrid;
  final List<ProductModel> list_products;
  final bool? gridHorizontal;

  ProductGrid({
    required this.title,
    this.quantityGrid,
    required this.list_products,
    this.gridHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final _itensCount = quantityGrid == null
        ? list_products.length
        : (list_products.length >= quantityGrid!
            ? quantityGrid!
            : list_products.length);

    return Container(
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          if (gridHorizontal == true) ...[
            // GRID HORIZONTAL
            SizedBox(
              height: 306,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),
                itemCount: _itensCount,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (ctx, index) => SizedBox(
                  width: 180,
                  child: ProductGridItem(
                    product: list_products[index],
                  ),
                ),
              ),
            ),
          ] else ...[
            // GRID VERTICAL
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(8),
              itemCount: _itensCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (ctx, index) =>
                  ProductGridItem(product: list_products[index]),
            ),
          ],
          if (quantityGrid != null && quantityGrid! < list_products.length)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.SEARCH_PRODUCT),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Ver mais",
                      style: TextStyle(fontSize: 16, color: Colors.purple),
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: Colors.purple,
                      size: 30,
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
