// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:twitterclone/core/enums.dart';

class Notification {
  final String text;
  final String postId;
  final String id;
  final String uId;
  final NotificationType notificationType;

  Notification({
    required this.text,
    required this.postId,
    required this.id,
    required this.uId,
    this.notificationType = NotificationType.like,
  });

  Notification copyWith({
    String? text,
    String? postId,
    String? id,
    String? uId,
    NotificationType? notificationType,
  }) {
    return Notification(
      text: text ?? this.text,
      postId: postId ?? this.postId,
      id: id ?? this.id,
      uId: uId ?? this.uId,
      notificationType: notificationType ?? this.notificationType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'postId': postId,

      'uId': uId,
      'notificationType': notificationType.name,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      text: map['text'] as String,
      postId: map['postId'] as String,
      id: map['\$id'] as String,
      uId: map['uId'] as String,
      // Convert the String back to the Enum
      notificationType: NotificationType.values.byName(
        map['notificationType'] as String,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(String source) =>
      Notification.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Notification(text: $text, postId: $postId, id: $id, uId: $uId, notificationType: $notificationType)';
  }

  @override
  bool operator ==(covariant Notification other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        other.postId == postId &&
        other.id == id &&
        other.uId == uId &&
        other.notificationType == notificationType;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        postId.hashCode ^
        id.hashCode ^
        uId.hashCode ^
        notificationType.hashCode;
  }
}
