class UserModel {
  final String name;
  final int phoneNumber;
  final String city;
  final String country;
  final String address;
  final DateTime? birthDate;
  final String avatarUrl;

  UserModel({
    required this.name,
    required this.phoneNumber,
    required this.city,
    required this.country,
    required this.address,
    required this.birthDate,
    required this.avatarUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] is int
          ? map['phoneNumber']
          : int.tryParse(map['phoneNumber'] ?? '0') ?? 0,
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      address: map['address'] ?? '',
      birthDate: map['birthDate'] != null && map['birthDate'] != ''
          ? DateTime.parse(map['birthDate'])
          : null,
      avatarUrl: map['avatarUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'city': city,
      'country': country,
      'address': address,
      'birthDate': birthDate,
      'avatarUrl': avatarUrl,
    };
  }
}
