import 'dart:convert';

class AvaliacaoModel {
  final String id;
  final String usuarioId;
  final String produtoId;
  final String pedidoId;
  final double nota;
  final String comentario;
  final DateTime dataCriacao;

  AvaliacaoModel({
    required this.id,
    required this.usuarioId,
    required this.produtoId,
    required this.pedidoId,
    required this.nota,
    required this.comentario,
    required this.dataCriacao,
  });

  AvaliacaoModel copyWith({
    String? id,
    String? usuarioId,
    String? produtoId,
    String? pedidoId,
    double? nota,
    String? comentario,
    DateTime? dataCriacao,
  }) {
    return AvaliacaoModel(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      produtoId: produtoId ?? this.produtoId,
      pedidoId: pedidoId ?? this.pedidoId,
      nota: nota ?? this.nota,
      comentario: comentario ?? this.comentario,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'usuarioId': usuarioId,
      'produtoId': produtoId,
      'pedidoId': pedidoId,
      'nota': nota,
      'comentario': comentario,
      'dataCriacao': dataCriacao.millisecondsSinceEpoch,
    };
  }

  factory AvaliacaoModel.fromMap(Map<String, dynamic> map) {
    return AvaliacaoModel(
      id: map['id'] as String,
      usuarioId: map['usuarioId'] as String,
      produtoId: map['produtoId'] as String,
      pedidoId: map['pedidoId'] as String,
      nota: map['nota'] as double,
      comentario: map['comentario'] as String,
      dataCriacao:
          DateTime.fromMillisecondsSinceEpoch(map['dataCriacao'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory AvaliacaoModel.fromJson(String source) =>
      AvaliacaoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AvaliacaoModel(id: $id, usuarioId: $usuarioId, produtoId: $produtoId, pedidoId: $pedidoId, nota: $nota, comentario: $comentario, dataCriacao: $dataCriacao)';
  }

  @override
  bool operator ==(covariant AvaliacaoModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.usuarioId == usuarioId &&
        other.produtoId == produtoId &&
        other.pedidoId == pedidoId &&
        other.nota == nota &&
        other.comentario == comentario &&
        other.dataCriacao == dataCriacao;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        usuarioId.hashCode ^
        produtoId.hashCode ^
        pedidoId.hashCode ^
        nota.hashCode ^
        comentario.hashCode ^
        dataCriacao.hashCode;
  }
}
