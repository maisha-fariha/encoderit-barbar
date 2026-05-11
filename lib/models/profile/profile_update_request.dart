/// Request body for `PUT /profile`.
class ProfileUpdateRequest {
  const ProfileUpdateRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    this.dob = '',
    this.address = '',
    this.zipCode = '',
    this.province = '',
    this.municipality = '',
    this.country = '',
  });

  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final String dob;
  final String address;
  final String zipCode;
  final String province;
  final String municipality;
  final String country;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'email': email,
        'phone': phone,
        'avatar_url': avatarUrl,
        'dob': dob,
        'address': address,
        'zip_code': zipCode,
        'province': province,
        'municipality': municipality,
        'country': country,
      };
}
