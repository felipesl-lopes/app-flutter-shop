import 'dart:convert';

class AvaliacaoModel {
  final String id;
  final double nota;
  final String comentario;
  final DateTime dataCriacao;
  final String nomeUsuario;

  AvaliacaoModel({
    required this.id,
    required this.nota,
    required this.comentario,
    required this.dataCriacao,
    required this.nomeUsuario,
  });

  AvaliacaoModel copyWith({
    String? id,
    double? nota,
    String? comentario,
    DateTime? dataCriacao,
    String? nomeUsuario,
  }) {
    return AvaliacaoModel(
      id: id ?? this.id,
      nota: nota ?? this.nota,
      comentario: comentario ?? this.comentario,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      nomeUsuario: nomeUsuario ?? this.nomeUsuario,
    );
  }

  factory AvaliacaoModel.fromMap(Map<String, dynamic> map) {
    return AvaliacaoModel(
      id: map['id'] as String,
      nota: (map['nota'] as num).toDouble(),
      comentario: map['comentario'] as String,
      dataCriacao: DateTime.parse(map['dataCriacao']).toLocal(),
      nomeUsuario: map['nomeUsuario'],
    );
  }

  factory AvaliacaoModel.fromJson(String source) =>
      AvaliacaoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant AvaliacaoModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nota == nota &&
        other.comentario == comentario &&
        other.dataCriacao == dataCriacao &&
        other.nomeUsuario == nomeUsuario;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nota.hashCode ^
        comentario.hashCode ^
        dataCriacao.hashCode ^
        nomeUsuario.hashCode;
  }
}
