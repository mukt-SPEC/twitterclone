import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:twitterclone/core/utils.dart';

class TweetController extends StateNotifier<bool> {
  TweetController() : super(false);

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
  }) {}

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
}
