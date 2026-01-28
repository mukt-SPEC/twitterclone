import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:twitterclone/apis/storage_api.dart';
import 'package:twitterclone/apis/tweet_api.dart';
import 'package:twitterclone/apis/user_api.dart';
import 'package:twitterclone/core/result.dart';
import 'package:twitterclone/core/utils.dart';
import 'package:twitterclone/model/tweet_model.dart';
import 'package:twitterclone/model/user_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
      return UserProfileController(
        tweetApi: ref.watch(tweetAPIProvider),
        storageApi: ref.watch(storageAPIProvider),
        userApi: ref.watch(userAPIProvider),
      );
    });

final getUserTweetProvider = FutureProvider.family((ref, String uId) async {
  final userProfileController = ref.watch(
    userProfileControllerProvider.notifier,
  );
  return userProfileController.getUserTweets(uId);
});

final getLatestUserProfileDataProvider = StreamProvider.autoDispose((ref) {
  final userAPI = ref.watch(userAPIProvider);
  return userAPI.getLatestUserProfileData();
});

class UserProfileController extends StateNotifier<bool> {
  final TweetApi _tweetAPI;
  final StorageApi _storageApi;
  final UserAPI _userAPI;
  UserProfileController({
    required TweetApi tweetApi,
    required StorageApi storageApi,
    required UserAPI userApi,
  }) : _tweetAPI = tweetApi,
       _storageApi = storageApi,
       _userAPI = userApi,
       super(false);

  Future<List<Tweet>> getUserTweets(String uId) async {
    final tweets = await _tweetAPI.getUserTweets(uId);
    return tweets.map((e) => Tweet.fromMap(e.data)).toList();
  }

  void updateUserProfile({
    required UserModel user,
    required BuildContext context,
    required File? bannerFile,
    required File? profileFile,
  }) async {
    state = true;
    if (bannerFile != null) {
      final bannerUrl = await _storageApi.uploadImages([bannerFile]);
      user = user.copyWith(bannerPicture: bannerUrl[0]);
    }
    if (profileFile != null) {
      final profileUrl = await _storageApi.uploadImages([profileFile]);
      user = user.copyWith(profilePicture: profileUrl[0]);
    }

    final result = await _userAPI.updateUserData(user);
    state = false;

    switch (result) {
      case Success(data: final user):
        Navigator.pop(context);
      case Error(failure: final failure):
        showSnackBar(context, failure.message!);
    }
  }

  void followUser({
    required UserModel user,
    required BuildContext buildcontext,
    required UserModel currentUser,
  }) async {
    if (currentUser.following.contains(user.uId)) {
      user.followers.remove(currentUser.uId);
      currentUser.following.remove(user.uId);
    }else{
       user.followers.add(currentUser.uId);
      currentUser.following.add(user.uId);
    }

    user = user.copyWith(followers: user.followers);
    currentUser = currentUser.copyWith(following: currentUser.following,);

    final result = await _userAPI.followUser(user);
  }
}
