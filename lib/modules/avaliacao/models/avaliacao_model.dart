import 'dart:convert';

class AvaliacaoModel {
  final String id;
  final double nota;
  final String comentario;
  final DateTime dataCriacao;
  final String nomeUsuario;
  final bool? minhaAvaliacao;

  AvaliacaoModel({
    required this.id,
    required this.nota,
    required this.comentario,
    required this.dataCriacao,
    required this.nomeUsuario,
    this.minhaAvaliacao,
  });

  AvaliacaoModel copyWith({
    String? id,
    double? nota,
    String? comentario,
    DateTime? dataCriacao,
    String? nomeUsuario,
    bool? minhaAvaliacao,
  }) {
    return AvaliacaoModel(
      id: id ?? this.id,
      nota: nota ?? this.nota,
      comentario: comentario ?? this.comentario,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      nomeUsuario: nomeUsuario ?? this.nomeUsuario,
      minhaAvaliacao: minhaAvaliacao ?? this.minhaAvaliacao,
    );
  }

  factory AvaliacaoModel.fromMap(Map<String, dynamic> map) {
    return AvaliacaoModel(
      id: map['id'] as String,
      nota: (map['nota'] as num).toDouble(),
      comentario: map['comentario'] as String,
      dataCriacao: DateTime.parse(map['dataCriacao']).toLocal(),
      nomeUsuario: map['nomeUsuario'],
      minhaAvaliacao: map['minhaAvaliacao'],
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
        other.nomeUsuario == nomeUsuario &&
        other.minhaAvaliacao == minhaAvaliacao;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nota.hashCode ^
        comentario.hashCode ^
        dataCriacao.hashCode ^
        nomeUsuario.hashCode ^
        minhaAvaliacao.hashCode;
  }
}
