import 'package:appshop/modules/categorias/Models/categorias_model.dart';
import 'package:appshop/shared/services/i_http_client.dart';

class CategoriasRepository {
  final IHttpClient client;

  CategoriasRepository(this.client);

  Future<List<CategoriasModel>> carregarCategorias({
    required String userId,
  }) async {
    final response = await client.get('categories');

    if (response.data == null) {
      return [];
    }

    final Map<String, dynamic> data = response.data;

    final List<CategoriasModel> categorias = [];

    data.forEach((id, value) {
      categorias.add(
        CategoriasModel(
          id: id,
          nome: value['name'],
        ),
      );
    });

    return categorias;
  }
}
