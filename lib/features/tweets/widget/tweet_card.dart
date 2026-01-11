import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/common/common.dart';
import 'package:twitterclone/core/enums.dart';
import 'package:twitterclone/features/auth/controller/auth_controller.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:twitterclone/features/tweets/widget/carousel_image.dart';
import 'package:twitterclone/features/tweets/widget/hashtags.dart';
import 'package:twitterclone/model/tweet_model.dart';

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  const TweetCard({required this.tweet, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(userDetailsProvider(tweet.uid))
        .when(
          data: (user) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePicture!),
                      ),
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(user.name),
                              Text(
                                '@${user.name} . ${timeago.format(tweet.tweetedAt, locale: 'em_short')}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                HashtagteText(text: tweet.content),
                if (tweet.tweetType == TweetType.image)
                  CarouselImage(imageLinks: tweet.images),
                if (tweet.link.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  AnyLinkPreview(link: 'https//${tweet.link}'),
                ],
              ],
            );
          },
          error: (error, stackTrace) => ErrorText(errorText: error.toString()),
          loading: () => const Loader(),
        );
  }
}
