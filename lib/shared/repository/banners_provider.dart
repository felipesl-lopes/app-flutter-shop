import 'dart:convert';

import 'package:appshop/core/utils/constants.dart';
import 'package:appshop/shared/Models/banner_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BannersProvider with ChangeNotifier {
  final String _token;
  List<BannerModel> _items = [];

  BannersProvider([this._token = "", this._items = const []]);

  List<BannerModel> get items => [..._items];

  Future<void> loadBanners() async {
    final url = "${Constants.BANNERS_URL}.json?auth=$_token";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.body == "null" || response.statusCode != 200) {
        return;
      }

      final Map<String, dynamic> data = jsonDecode(response.body);
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
