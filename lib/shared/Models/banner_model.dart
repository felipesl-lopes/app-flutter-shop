class BannerModel {
  final String imageUrl;
  final String linkTo;

  BannerModel({required this.imageUrl, required this.linkTo});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      imageUrl: json['imageUrl'] ?? '',
      linkTo: json['linkTo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'linkTo': linkTo,
    };
  }
}
