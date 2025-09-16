// lib/models/user_profile.dart
class UserProfile {
  final String id;
  final String name;
  final int age;
  final String location;
  final String occupation;
  final List<String> personalityTraits;
  final List<String> idealTypeTraits;
  final String avatarUrl;
  final String? message;
  final String? gender; // 👈 새로 추가됨

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.location,
    required this.occupation,
    required this.personalityTraits,
    required this.idealTypeTraits,
    required this.avatarUrl,
    this.message,
    this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'location': location,
      'occupation': occupation,
      'personalityTraits': personalityTraits,
      'idealTypeTraits': idealTypeTraits,
      'avatarUrl': avatarUrl,
      'message': message,
      'gender': gender,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      location: map['location'] ?? '',
      occupation: map['occupation'] ?? '',
      personalityTraits: List<String>.from(map['personalityTraits'] ?? []),
      idealTypeTraits: List<String>.from(map['idealTypeTraits'] ?? []),
      avatarUrl: map['avatarUrl'] ?? '',
      message: map['message'],
      gender: map['gender'],
    );
  }
  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? location,
    String? occupation,
    List<String>? personalityTraits,
    List<String>? idealTypeTraits,
    String? avatarUrl,
    String? message,
    String? gender,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      location: location ?? this.location,
      occupation: occupation ?? this.occupation,
      personalityTraits: personalityTraits ?? this.personalityTraits,
      idealTypeTraits: idealTypeTraits ?? this.idealTypeTraits,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      message: message ?? this.message,
      gender: gender ?? this.gender,
    );
  }
}
