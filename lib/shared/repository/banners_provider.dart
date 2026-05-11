import 'package:appshop/shared/Models/banner_model.dart';
import 'package:appshop/shared/services/i_http_client.dart';
import 'package:flutter/material.dart';

class BannersProvider with ChangeNotifier {
  final IHttpClient client;

  BannersProvider(this.client);

  List<BannerModel> _items = [];
  List<BannerModel> get items => [..._items];

  Future<void> loadBanners() async {
    try {
      final response = await client.get('banners');

      if (response.data == null || response.statusCode != 200) {
        return;
      }

      final Map<String, dynamic> data = response.data;
      final List<BannerModel> loadedItems = [];

      data.forEach((bannerId, bannerData) {
        final model =
            BannerModel.fromJson(Map<String, dynamic>.from(bannerData));

        if (model.imageUrl.isNotEmpty && model.imageUrl.contains('http')) {
          loadedItems.add(model);
        }
      });

      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      debugPrint("Erro ao carregar banners: $error");
      rethrow;
    }
  }
}
