/// User Model - Data structure for user profile and authentication data
class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final bool isBiometricEnabled;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.isBiometricEnabled = false,
    required this.createdAt,
    this.lastUpdated,
  });

  /// Create a copy of UserModel with updated fields
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? isBiometricEnabled,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'isBiometricEnabled': isBiometricEnabled,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDateTime(dynamic value, DateTime fallback) {
      if (value == null) return fallback;
      try {
        return DateTime.parse(value.toString());
      } catch (_) {
        return fallback;
      }
    }

    DateTime? parseDateTimeOrNull(dynamic value) {
      if (value == null) return null;
      try {
        return DateTime.parse(value.toString());
      } catch (_) {
        return null;
      }
    }

    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? '',
      photoUrl: json['photoUrl'],
      isBiometricEnabled: json['isBiometricEnabled'] ?? false,
      createdAt: parseDateTime(json['createdAt'], DateTime.now()),
      lastUpdated: parseDateTimeOrNull(json['lastUpdated']),
    );
  }
}
