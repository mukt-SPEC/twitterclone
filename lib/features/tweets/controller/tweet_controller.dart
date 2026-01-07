import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:twitterclone/core/enums.dart';
import 'package:twitterclone/core/utils.dart';
import 'package:twitterclone/model/tweet_model.dart';

import '../../auth/controller/auth_controller.dart';

class TweetController extends StateNotifier<bool> {
  final Ref _ref;
  TweetController({required Ref ref}) : _ref = ref, super(false);

  void shareTweet({
    required List<File>? images,
    required String text,
    required BuildContext context,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter text');
      return;
    }
    if (images!.isNotEmpty) {
      _shareImageTweet(images: images, text: text, context: context);
    } else {
      _shareTextOnlyTweet(text: text, context: context);
    }
  }

  void _shareImageTweet({
    required List<File>? images,
    required String text,
    required BuildContext context,
  }) {}
  void _shareTextOnlyTweet({
    required String text,
    required BuildContext context,
  }) {
    final user = _ref.read(currentUserDetailsProvider).value;
    state = true;
    final link = _getLinkFromText(text);
    final hashTags = _getHashTagFromText(text);
    Tweet tweet = Tweet(
      text: text,
      hashTags: hashTags,
      link: link,
      images: [],
      uid: user!.uId,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: [],
      commentId: [],
      id: '',
      reshareCount: 0,
    );
  }

  String _getLinkFromText(String text) {
    List<String> wordsInSentence = text.split(' ');
    String link = '';
    for (var word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashTagFromText(String text) {
    List<String> wordsInSentence = text.split(' ');
    List<String> hashTags = [];
    for (var word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashTags.add(word);
      }
    }
    return hashTags;
  }
}
