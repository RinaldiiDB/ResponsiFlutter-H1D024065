class LocationModel {
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? admin1;
  final String? countryCode;
  final String? timezone;
  final bool isFavorite;

  const LocationModel({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.admin1,
    this.countryCode,
    this.timezone,
    this.isFavorite = false,
  });

  String get displayName {
    final parts = <String>[name];
    if (admin1 != null && admin1!.isNotEmpty && admin1 != name) {
      parts.add(admin1!);
    }
    if (country != null && country!.isNotEmpty) {
      parts.add(country!);
    }
    return parts.join(', ');
  }

  LocationModel copyWith({
    String? name,
    double? latitude,
    double? longitude,
    String? country,
    String? admin1,
    String? countryCode,
    String? timezone,
    bool? isFavorite,
  }) {
    return LocationModel(
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      country: country ?? this.country,
      admin1: admin1 ?? this.admin1,
      countryCode: countryCode ?? this.countryCode,
      timezone: timezone ?? this.timezone,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] as String? ?? 'Tidak diketahui',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      country: json['country'] as String?,
      admin1: json['admin1'] as String?,
      countryCode: json['country_code'] as String?,
      timezone: json['timezone'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'admin1': admin1,
      'country_code': countryCode,
      'timezone': timezone,
      'isFavorite': isFavorite,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => name.hashCode ^ latitude.hashCode ^ longitude.hashCode;
}
