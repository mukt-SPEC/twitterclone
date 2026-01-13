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
