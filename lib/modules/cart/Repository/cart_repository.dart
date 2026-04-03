import 'package:appshop/shared/Models/cart_item_model.dart';
import 'package:appshop/shared/services/i_http_client.dart';

class CartRepository {
  final IHttpClient client;

  CartRepository(this.client);

  Future<List<CartItemModel>> getCart({required String userId}) async {
    final response = await client.get('cartProducts/$userId');
    final data = response.data;

    if (data == null) return [];

    final List<CartItemModel> items = [];

    data.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        items.add(CartItemModel.fromJson(value));
      }
    });
    return items;
  }

  Future<void> updateItemQuantity({
    required String productId,
    required int quantity,
    required String userId,
    required CartItemModel item,
  }) async {
    final response = await client.get('cartProducts/$userId/$productId');

    if (response.data == null) {
      await client.put('cartProducts/$userId/$productId', body: item.toJson());
      return;
    }

    if (quantity <= 0) {
      await client.delete('cartProducts/$userId/$productId');
    } else {
      await client.patch(
        'cartProducts/$userId/$productId',
        body: {'quantity': quantity},
      );
    }
  }

  Future<void> limparCarrinho({required String userId}) async {
    await client.delete('cartProducts/$userId');
  }
}
