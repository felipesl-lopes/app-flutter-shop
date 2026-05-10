class EnderecoModel {
  final String id;
  final String cep;
  final String rua;
  final String numero;
  final String complemento;
  final String bairro;
  final String cidade;
  final String uf;

  EnderecoModel({
    required this.id,
    required this.cep,
    required this.rua,
    required this.numero,
    required this.complemento,
    required this.bairro,
    required this.cidade,
    required this.uf,
  });

  factory EnderecoModel.fromJson(String id, Map<String, dynamic> json) {
    return EnderecoModel(
      id: id,
      cep: json['cep'],
      rua: json['rua'],
      numero: json['numero'],
      complemento: json['complemento'] ?? '',
      bairro: json['bairro'],
      cidade: json['cidade'],
      uf: json['uf'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'rua': rua,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'uf': uf,
    };
  }

  EnderecoModel copyWith({
    String? id,
    String? cep,
    String? rua,
    String? numero,
    String? complemento,
    String? bairro,
    String? cidade,
    String? uf,
  }) {
    return EnderecoModel(
      id: id ?? this.id,
      cep: cep ?? this.cep,
      rua: rua ?? this.rua,
      numero: numero ?? this.numero,
      complemento: complemento ?? this.complemento,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      uf: uf ?? this.uf,
    );
  }

  factory EnderecoModel.fromMap(String id, Map<String, dynamic> map) {
    return EnderecoModel(
      id: id,
      cep: map['cep'],
      rua: map['rua'],
      numero: map['numero'],
      complemento: map['complemento'] ?? '',
      bairro: map['bairro'],
      cidade: map['cidade'],
      uf: map['uf'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cep': cep,
      'rua': rua,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'uf': uf,
    };
  }
}
