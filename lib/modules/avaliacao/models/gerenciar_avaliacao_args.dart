class GerenciarAvaliacaoArgs {
  final String productId;
  final String productName;
  final String? avaliacaoId;
  final String? comentario;
  final double? nota;
  final String? orderId;

  const GerenciarAvaliacaoArgs({
    required this.productId,
    required this.productName,
    this.avaliacaoId,
    this.comentario,
    this.nota,
    this.orderId,
  });
}
