import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:twitterclone/apis/tweet_api.dart';
import 'package:twitterclone/model/tweet_model.dart';

final userProfileControllerProvider = StateNotifierProvider((ref) {
  return UserProfileController(tweetApi: ref.watch(tweetAPIProvider));
});

final getUserTweetProvider = FutureProvider.family((ref, String uId) async {
  final userProfileController = ref.watch(
    userProfileControllerProvider.notifier,
  );
  return userProfileController.getUserTweets(uId);
});

class UserProfileController extends StateNotifier<bool> {
  final TweetApi _tweetAPI;
  UserProfileController({required TweetApi tweetApi})
    : _tweetAPI = tweetApi,
      super(false);

  Future<List<Tweet>> getUserTweets(String uId) async {
    final tweets = await _tweetAPI.getUserTweets(uId);
    return tweets.map((e) => Tweet.fromMap(e.data)).toList();
  }
}
