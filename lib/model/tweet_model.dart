// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:twitterclone/core/enums.dart';

@immutable
class Tweet {
  final String content;
  final List<String> hashTags;
  final String link;
  final List<String> images;
  final String uid;
  final TweetType tweetType;
  final DateTime tweetedAt;
  final List<String> likes;
  final List<String> commentId;
  final String id;
  final int reshareCount;
  final String retweetedBy;
  const Tweet({
    required this.content,
    required this.hashTags,
    required this.link,
    required this.images,
    required this.uid,
    required this.tweetType,
    required this.tweetedAt,
    required this.likes,
    required this.commentId,
    required this.id,
    required this.reshareCount,
    required this.retweetedBy,
  });

  Tweet copyWith({
    String? content,
    List<String>? hashTags,
    String? link,
    List<String>? images,
    String? uid,
    TweetType? tweetType,
    DateTime? tweetedAt,
    List<String>? likes,
    List<String>? commentId,
    String? id,
    int? reshareCount,
    String? retweetedBy,
  }) {
    return Tweet(
      content: content ?? this.content,
      hashTags: hashTags ?? this.hashTags,
      link: link ?? this.link,
      images: images ?? this.images,
      uid: uid ?? this.uid,
      tweetType: tweetType ?? this.tweetType,
      tweetedAt: tweetedAt ?? this.tweetedAt,
      likes: likes ?? this.likes,
      commentId: commentId ?? this.commentId,
      id: id ?? this.id,
      reshareCount: reshareCount ?? this.reshareCount,
      retweetedBy: retweetedBy ?? this.retweetedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'hashTags': hashTags,
      'link': link,
      'images': images,
      'uid': uid,
      'tweetType': tweetType.type,
      'tweetedAt': tweetedAt.millisecondsSinceEpoch,
      'likes': likes,
      'commentId': commentId,
      'reshareCount': reshareCount,
      'retweetedBy': retweetedBy,
    };
  }

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      content: map['content'] as String? ?? '',
      hashTags: map['hashTags'] != null
          ? List<String>.from(map['hashTags'] as List)
          : <String>[],
      link: map['link'] as String? ?? '',
      images: map['images'] != null
          ? List<String>.from(map['images'] as List)
          : <String>[],
      uid: map['uid'] as String? ?? '',
      tweetType: map['tweetType'] != null
          ? TweetType.values.firstWhere(
              (e) => e.type == (map['tweetType'] as String),
              orElse: () => TweetType.text,
            )
          : TweetType.text,
      tweetedAt: map['tweetedAt'] is int
          ? DateTime.fromMillisecondsSinceEpoch(map['tweetedAt'] as int)
          : DateTime.tryParse(map['tweetedAt']?.toString() ?? '') ??
                DateTime.now(),
      likes: map['likes'] != null
          ? List<String>.from(map['likes'] as List)
          : <String>[],
      commentId: map['commentId'] != null
          ? List<String>.from(map['commentId'] as List)
          : <String>[],
      id: map['\$id'] as String? ?? '',
      reshareCount: map['reshareCount'] is int
          ? map['reshareCount'] as int
          : int.tryParse((map['reshareCount'] ?? 0).toString()) ?? 0,
      retweetedBy: map['retweetedBy'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Tweet.fromJson(String source) =>
      Tweet.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Tweet(content: $content, hashTags: $hashTags, link: $link, images: $images, uid: $uid, tweetType: $tweetType, tweetedAt: $tweetedAt, likes: $likes, commentId: $commentId, id: $id, reshareCount: $reshareCount, retweetedBy: $retweetedBy)';
  }

  @override
  bool operator ==(covariant Tweet other) {
    if (identical(this, other)) return true;

    return other.content == content &&
        listEquals(other.hashTags, hashTags) &&
        other.link == link &&
        listEquals(other.images, images) &&
        other.uid == uid &&
        other.tweetType == tweetType &&
        other.tweetedAt == tweetedAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentId, commentId) &&
        other.id == id &&
        other.reshareCount == reshareCount &&
        other.retweetedBy == retweetedBy;
  }

  @override
  int get hashCode {
    return content.hashCode ^
        hashTags.hashCode ^
        link.hashCode ^
        images.hashCode ^
        uid.hashCode ^
        tweetType.hashCode ^
        tweetedAt.hashCode ^
        likes.hashCode ^
        commentId.hashCode ^
        id.hashCode ^
        reshareCount.hashCode ^
        retweetedBy.hashCode;
  }
}
