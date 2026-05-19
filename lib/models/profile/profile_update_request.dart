import 'dart:io';

/// Request for `PUT /profile`.
///
/// Text fields are always sent. When [avatarFile] is set, the request uses
/// `multipart/form-data` with form field `avatar` (File, per Postman). The API
/// responds with `avatar` as a URL string. When [avatarFile] is null, only
/// text fields are sent (JSON or multipart without file).
class ProfileUpdateRequest {
  const ProfileUpdateRequest({
    required this.name,
    required this.email,
    required this.phone,
    this.avatarFile,
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
  final File? avatarFile;
  final String dob;
  final String address;
  final String zipCode;
  final String province;
  final String municipality;
  final String country;

  /// JSON body when no new avatar file is selected.
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

  /// Text form fields for multipart `PUT /profile` (file part is `avatar`).
  Map<String, dynamic> toFormFields() => toJson();
}
