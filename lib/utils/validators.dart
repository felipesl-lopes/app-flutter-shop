String? isValidImageUrl(String url) {
  bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
  bool endsWithFile = url.toLowerCase().endsWith(".png") ||
      url.toLowerCase().endsWith(".jpg") ||
      url.toLowerCase().endsWith(".jpeg");

  if (!(isValidUrl && endsWithFile)) {
    return "Tipo de arquivo inválido.";
  }
  return null;
}

String? isValidName(String name) {
  if (name.trim().isEmpty) {
    return "Nome é obrigatório.";
  }
  if (name.trim().length < 2) {
    return "Nome muito curto.";
  }
  return null;
}

String? isValidPrice(String priceValue) {
  if (priceValue.endsWith('.')) {
    return "Digite um valor válido.";
  }
  if (priceValue.trim().isEmpty) {
    return "Preço é obrigatório.";
  }
  final price = double.tryParse(priceValue);
  if (price == null || price <= 0.0) {
    return "Digite um valor válido.";
  }
  return null;
}

String? isValidDescription(String description) {
  if (description.trim().isEmpty) {
    return "Descrição é obrigatória.";
  }
  return null;
}
