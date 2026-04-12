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

String? isValidCategory(String category) {
  if (category.isEmpty) {
    return "Selecione uma categoria";
  }
  return null;
}

String? isValidPrice(String priceValue) {
  final price = double.tryParse(priceValue);
  if (priceValue.trim().isEmpty) {
    return "Preço é obrigatório.";
  }
  if (price == null || price <= 0.0 || priceValue.endsWith('.')) {
    return "Digite um valor válido.";
  }
  return null;
}

String? isValidQuantity(String quantity) {
  final quant = int.tryParse(quantity);
  if (quantity.trim().isEmpty) {
    "Quantidade é obrigatória.";
  }
  if (quant == null || quant <= 0 || quantity.endsWith('.')) {
    return "Digite uma quantidade válida.";
  }
  return null;
}

String? isValidDescription(String description) {
  if (description.trim().isEmpty) {
    return "Descrição é obrigatória.";
  }
  return null;
}
