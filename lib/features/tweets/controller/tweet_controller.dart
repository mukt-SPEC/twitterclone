import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:twitterclone/apis/notification_api.dart';
import 'package:twitterclone/apis/storage_api.dart';
import 'package:twitterclone/apis/tweet_api.dart';
import 'package:twitterclone/core/enums.dart';
import 'package:twitterclone/core/result.dart';
import 'package:twitterclone/core/utils.dart';
import 'package:twitterclone/features/notifications/controller/notification_controller.dart';
import 'package:twitterclone/model/tweet_model.dart';
import 'package:twitterclone/model/user_model.dart';

import '../../auth/controller/auth_controller.dart';

final tweetControllerProvider =
    StateNotifierProvider.autoDispose<TweetController, bool>((ref) {
      return TweetController(
        ref: ref,
        tweetApi: ref.watch(tweetAPIProvider),
        storageApi: ref.watch(storageAPIProvider),
        notificationController: ref.watch(
          notificationControllerProvider.notifier,
        ),
      );
    });

final getTweetProvider = FutureProvider.autoDispose((ref) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweet();
});

final getTweetRepliesProvider = FutureProvider.family((ref, Tweet tweet) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetReplies(tweet);
});

final getLatestTweetProvider = StreamProvider.autoDispose((ref) {
  final tweetApi = ref.watch(tweetAPIProvider);
  return tweetApi.getLatestTweet();
});

final getTweetByIdProvider = FutureProvider.family((ref, String id) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetById(id);
});

class TweetController extends StateNotifier<bool> {
  final TweetApi _tweetApi;
  final StorageApi _storageApi;
  final NotificationController _notificationController;
  final Ref _ref;
  TweetController({
    required Ref ref,
    required TweetApi tweetApi,
    required StorageApi storageApi,
    required NotificationController notificationController,
  }) : _ref = ref,
       _storageApi = storageApi,
       _tweetApi = tweetApi,
       _notificationController = notificationController,
       super(false);

  Future<List<Tweet>> getTweet() async {
    final tweetList = await _tweetApi.getTweet();
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<Tweet> getTweetById(String id) async {
    final tweet = await _tweetApi.getTweetById(id: id);
    return Tweet.fromMap(tweet.data);
  }

  void shareTweet({
    required List<File>? images,
    required String text,
    required BuildContext context,
    required String? repliedto,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter text');
      return;
    }
    if (images!.isNotEmpty) {
      _shareImageTweet(
        images: images,
        text: text,
        repliedto: repliedto,
        context: context,
      );
    } else {
      _shareTextOnlyTweet(text: text, repliedto: repliedto, context: context);
    }
  }

  void likeTweet({Tweet? tweet, UserModel? user}) async {
    List<String> likes = tweet!.likes;

    if (tweet.likes.contains(user!.uId)) {
      likes.remove(user.uId);
    } else {
      likes.add(user.uId);
    }

    tweet = tweet.copyWith(likes: likes);

    final res = await _tweetApi.likeTweet(tweet: tweet);
    switch (res) {
      case Success():
        // _notificationApi.createNotifcation(notifcation);
        _notificationController.createNotifcation(
          text: '${user.name} liked your tweet',
          postId: tweet.id,
          notificationType: NotificationType.like,
          uId: tweet.uid,
        );
      case Error(failure: final failure):
        null;
    }
  }

  void reshareTweet({
    Tweet? tweet,
    UserModel? user,
    required BuildContext context,
  }) async {
    tweet = tweet!.copyWith(
      retweetedBy: user!.name,
      likes: [],
      commentId: [],
      reshareCount: tweet.reshareCount + 1,
    );
    final res = await _tweetApi.updaateResharecount(tweet: tweet);
    switch (res) {
      case Success():
        tweet.copyWith(
          id: ID.unique(),
          reshareCount: 0,
          tweetedAt: DateTime.now(),
        );
        final secondResponse = await _tweetApi.shareTweet(tweet: tweet);

      case Error(failure: final failure):
        showSnackBar(context, failure.message!);
    }
  }

  void _shareImageTweet({
    required List<File>? images,
    required String text,
    required BuildContext context,
    required String? repliedto,
  }) async {
    state = true;
    final user = _ref.read(currentUserDetailsProvider).value;

    final link = _getLinkFromText(text);
    final imageLinks = await _storageApi.uploadImages(images!);
    final hashTags = _getHashTagFromText(text);
    Tweet tweet = Tweet(
      content: text,
      hashTags: hashTags,
      link: link,
      images: imageLinks,
      uid: user!.uId,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      likes: [],
      commentId: [],
      id: '',
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedto!,
    );
    final response = await _tweetApi.shareTweet(tweet: tweet);
    state = false;
    switch (response) {
      case Success():
        null;
      case Error(failure: final failure):
        showSnackBar(context, failure.message!);
    }
  }

  void _shareTextOnlyTweet({
    required String text,
    required BuildContext context,
    required String? repliedto,
  }) async {
    state = true;
    final user = _ref.read(currentUserDetailsProvider).value;

    final link = _getLinkFromText(text);
    final hashTags = _getHashTagFromText(text);
    Tweet tweet = Tweet(
      content: text,
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
      retweetedBy: '',
      repliedTo: repliedto!,
    );
    final response = await _tweetApi.shareTweet(tweet: tweet);
    state = false;
    switch (response) {
      case Success():
        null;
      case Error(failure: final failure):
        showSnackBar(context, failure.message!);
    }
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

  Future<List<Tweet>> getTweetReplies(Tweet? tweet) async {
    final doc = await _tweetApi.getTweetReplies(tweet: tweet);
    return doc.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }
}
