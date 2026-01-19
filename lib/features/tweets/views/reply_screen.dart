import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/features/tweets/controller/tweet_controller.dart';
import 'package:twitterclone/features/tweets/widget/tweet_card.dart';
import 'package:twitterclone/model/tweet_model.dart';

class ReplyScreen extends ConsumerWidget {
  static route(Tweet tweet) =>
      MaterialPageRoute(builder: (context) => ReplyScreen(tweet: tweet));

  final Tweet tweet;
  const ReplyScreen({required this.tweet, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tweet')),
      body: Column(children: [TweetCard(tweet: tweet)]),
      bottomNavigationBar: TextField(
        onSubmitted: (value) {
          ref
              .read(tweetControllerProvider.notifier)
              .shareTweet(
                images: [],
                text: value,
                repliedto: tweet.id,
                context: context,
              );
        },
        decoration: const InputDecoration(hintText: 'tweet your reply'),
      ),
    );
  }
}
