import 'package:appshop/shared/Models/banner_model.dart';
import 'package:appshop/shared/services/i_http_client.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class BannersProvider with ChangeNotifier {
  final IHttpClient client;

  late final Command0<List<BannerModel>> loadBannersCommand;

  BannersProvider(this.client) {
    loadBannersCommand = Command0(_loadBanners);
  }

  List<BannerModel> _items = [];
  List<BannerModel> get items => [..._items];

  void setBanners(List<BannerModel> value) {
    _items = value;
    notifyListeners();
  }

  Future<Result<List<BannerModel>>> _loadBanners() async {
    try {
      final response = await client.get('banners');

      if (response.data == null || response.statusCode != 200) {
        return Failure(Exception());
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

      setBanners(loadedItems);
      return Success(loadedItems);
    } catch (e) {
      debugPrint("Erro ao carregar banners: $e");
      return Failure(
        Exception(e.toString()),
      );
    }
  }
}
