// lib/models/user.dart
class User {
  final int? id;
  final bool isAndroid;
  final bool intro;
  final String deviceName;

  User({
    this.id,
    required this.isAndroid,
    required this.intro,
    required this.deviceName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'is_android': isAndroid ? 1 : 0,
      'intro': intro ? 1 : 0,
      'device_name': deviceName,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      isAndroid: map['is_android'] == 1,
      intro: map['intro'] == 1,
      deviceName: map['device_name'],
    );
  }
}
