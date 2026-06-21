class BannerModel {
  final String id;
  final String imageUrl;
  final String linkTo;

  BannerModel({required this.id, required this.imageUrl, required this.linkTo});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      linkTo: json['linkTo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'linkTo': linkTo,
    };
  }
}
