// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String email;
  final List<String> followers;
  final List<String> following;
  final String profilePicture;
  final String bannerPicture;
  final String uId;
  final String bioDescription;
  final bool isVerified;

  UserModel({
    required this.name,
    required this.email,
    required this.followers,
    required this.following,
    required this.profilePicture,
    required this.bannerPicture,
    required this.uId,
    required this.bioDescription,
    required this.isVerified,
  });

  UserModel copyWith({
    String? name,
    String? email,
    List<String>? followers,
    List<String>? following,
    String? profilePicture,
    String? bannerPicture,
    String? uId,
    String? bioDescription,
    bool? isVerified,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      profilePicture: profilePicture ?? this.profilePicture,
      bannerPicture: bannerPicture ?? this.bannerPicture,
      uId: uId ?? this.uId,
      bioDescription: bioDescription ?? this.bioDescription,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, followers: $followers, following: $following, profilePicture: $profilePicture, bannerPicture: $bannerPicture, uId: $uId, bioDescription: $bioDescription, isVerified: $isVerified)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        listEquals(other.followers, followers) &&
        listEquals(other.following, following) &&
        other.profilePicture == profilePicture &&
        other.bannerPicture == bannerPicture &&
        other.uId == uId &&
        other.bioDescription == bioDescription &&
        other.isVerified == isVerified;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        followers.hashCode ^
        following.hashCode ^
        profilePicture.hashCode ^
        bannerPicture.hashCode ^
        uId.hashCode ^
        bioDescription.hashCode ^
        isVerified.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'followers': followers,
      'following': following,
      'profilePicture': profilePicture,
      'bannerPicture': bannerPicture,
      'uId': uId,
      'bioDescription': bioDescription,
      'isVerified': isVerified,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',

      followers: List<String>.from((map['followers'] as List<dynamic>? ?? [])),
      following: List<String>.from((map['following'] as List<dynamic>? ?? [])),

      profilePicture: map['profilePicture'] as String? ?? '',
      bannerPicture: map['bannerPicture'] as String? ?? '',
      uId: map['\$id'] as String? ?? '',
      bioDescription: map['bioDescription'] as String? ?? '',
      isVerified: map['isVerified'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
