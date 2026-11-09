class CustomerAddress {
  const CustomerAddress({
    required this.id,
    required this.department,
    required this.province,
    required this.district,
    required this.street,
  });
  final String id;
  final String department;
  final String province;
  final String district;
  final String street;
  String get region => '$district, $province, $department';
  Map<String, dynamic> toJson() => {
    'id': id,
    'department': department,
    'province': province,
    'district': district,
    'street': street,
  };
  factory CustomerAddress.fromJson(Map<String, dynamic> json) =>
      CustomerAddress(
        id: json['id'] as String,
        department: json['department'] as String,
        province: json['province'] as String,
        district: json['district'] as String,
        street: json['street'] as String,
      );
}
