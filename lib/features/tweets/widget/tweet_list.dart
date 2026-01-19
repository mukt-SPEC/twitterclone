import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/common/common.dart';
import 'package:twitterclone/constants/appwrite_constant.dart';
import 'package:twitterclone/features/tweets/controller/tweet_controller.dart';
import 'package:twitterclone/features/tweets/widget/tweet_card.dart';
import 'package:twitterclone/model/tweet_model.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(getTweetProvider)
        .when(
          data: (tweets) {
            return ref
                .watch(getLatestTweetProvider)
                .when(
                  data: (data) {
                    if (data.events.contains(
                      'databases.*.collections.${AppwriteEnvironment.tweetCollection}.documents.*.create',
                    )) {
                      tweets.insert(0, Tweet.fromMap(data.payload));
                    } else if (data.events.contains(
                      'databases.*.collections.${AppwriteEnvironment.tweetCollection}.documents.*.uodate',
                    )) {
                      final startingPoint = data.events[0].lastIndexOf(
                        'documents.',
                      );
                      final endingPoint = data.events[0].lastIndexOf('.update');

                      final tweetId = data.events[0].substring(
                        startingPoint + 10,
                        endingPoint,
                      );

                      var tweet = tweets.where((e) => e.id == tweetId).first;

                      final tweetIndex = tweets.indexOf(tweet);
                      tweets.removeWhere((e) => e.id == tweetId);

                      tweet = Tweet.fromMap(data.payload);

                      tweets.insert(tweetIndex, tweet);
                    }
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      },
                    );
                  },
                  error: (error, stackTrace) =>
                      ErrorText(errorText: error.toString()),
                  loading: () => const Loader(),
                );
          },
          error: (error, stackTrace) => ErrorText(errorText: error.toString()),
          loading: () => const Loader(),
        );
  }
}
