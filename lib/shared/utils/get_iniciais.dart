String getIniciais(String nome) {
  if (nome.trim().isEmpty) return '';

  final partes = nome.trim().split(RegExp(r'\s+'));

  if (partes.length == 1) {
    return partes.first[0].toUpperCase();
  }

  return (partes.first[0] + partes.last[0].toUpperCase());
}
