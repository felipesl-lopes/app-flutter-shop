class CategoriasModel {
  final String id;
  final String nome;

  CategoriasModel({
    required this.id,
    required this.nome,
  });

  factory CategoriasModel.fromJson(String id, Map<String, dynamic> json) {
    return CategoriasModel(
      id: id,
      nome: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': nome,
    };
  }
}
