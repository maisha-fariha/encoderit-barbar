/// JSON body for `PUT /profile`.
///
/// The avatar is uploaded separately via `POST /profile/avatar` — see
/// [ProfileRepository.uploadAvatar].
class ProfileUpdateRequest {
  const ProfileUpdateRequest({
    required this.name,
    required this.email,
    required this.phone,
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
        'dob': dob,
        'address': address,
        'zip_code': zipCode,
        'province': province,
        'municipality': municipality,
        'country': country,
      };
}
