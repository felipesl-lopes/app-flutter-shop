import 'package:appshop/core/services/i_http_client.dart';
import 'package:appshop/modules/home/models/banner_model.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class BannersProvider with ChangeNotifier {
  final IHttpClient _client;

  late final Command0<List<BannerModel>> loadBannersCommand;

  BannersProvider(this._client) {
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
      final response = await _client.get('banners');

      if (response.statusCode > 400) {
        return Failure(Exception());
      }

      final data = response.data as List;

      final loadedItems = data.map((e) {
        return BannerModel.fromJson(Map<String, dynamic>.from(e));
      }).toList();

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
