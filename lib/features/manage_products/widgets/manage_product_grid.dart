import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/core/models/product_model.dart';
import 'package:appshop/core/utils/formatters.dart';
import 'package:appshop/shared/Widgets/image_avatar.dart';
import 'package:flutter/material.dart';

class ManageProductGrid extends StatelessWidget {
  final ProductModel product;

  ManageProductGrid(this.product);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        product.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        formatPrice(product.price),
      ),
      leading: ImageAvatar(
        imageUrl:
            product.imageUrls.isNotEmpty ? product.imageUrls.first.value : null,
      ),
      trailing: IconButton(
        onPressed: null,
        icon: Icon(Icons.chevron_right),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.MANAGE_PRODUCT_FORM,
          arguments: product,
        );
      },
    );
  }
}
