import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:twitterclone/Theme/theme.dart';
import 'package:twitterclone/common/common.dart';
import 'package:twitterclone/constants/constants.dart';
import 'package:twitterclone/core/enums.dart';
import 'package:twitterclone/features/auth/controller/auth_controller.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:twitterclone/features/tweets/controller/tweet_controller.dart';
import 'package:twitterclone/features/tweets/widget/carousel_image.dart';
import 'package:twitterclone/features/tweets/widget/hashtags.dart';
import 'package:twitterclone/features/tweets/widget/tweet_icon_button.dart';
import 'package:twitterclone/model/tweet_model.dart';

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  const TweetCard({required this.tweet, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? SizedBox()
        : ref
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
                              backgroundImage: NetworkImage(
                                user.profilePicture!,
                              ),
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
                        AnyLinkPreview(
                          displayDirection: UIDirection.uiDirectionHorizontal,
                          link: 'https//${tweet.link}',
                        ),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TweetIconButton(
                            pathName: AssetsConstants.viewsIcon,
                            text:
                                (tweet.commentId.length +
                                        tweet.reshareCount +
                                        tweet.likes.length)
                                    .toString(),
                            onTap: () {},
                          ),
                          TweetIconButton(
                            pathName: AssetsConstants.commentIcon,
                            text: (tweet.commentId.length).toString(),
                            onTap: () {},
                          ),
                          TweetIconButton(
                            pathName: AssetsConstants.retweetIcon,
                            text: (tweet.reshareCount).toString(),
                            onTap: () {
                              ref.read(tweetControllerProvider.notifier).reshareTweet(context: context, tweet: tweet, user: currentUser);
                            },
                          ),
                          LikeButton(
                            size: 25,
                            onTap: (isLiked) async {
                              ref
                                  .read(tweetControllerProvider.notifier)
                                  .likeTweet(tweet: tweet, user: currentUser);
                              return !isLiked;
                            },
                            isLiked: tweet.likes.contains(currentUser.uId),
                            likeBuilder: (isLiked) {
                              return isLiked
                                  ? SvgPicture.asset(
                                      AssetsConstants.likeFilledIcon,
                                      colorFilter: ColorFilter.mode(
                                        Pallete.redColor,
                                        BlendMode.srcIn,
                                      ),
                                    )
                                  : SvgPicture.asset(
                                      AssetsConstants.likeOutlinedIcon,
                                      colorFilter: ColorFilter.mode(
                                        Pallete.greyColor,
                                        BlendMode.srcIn,
                                      ),
                                    );
                            },
                            likeCount: tweet.likes.length,
                            countBuilder: (likeCount, isLiked, text) {
                              return Text(
                                text,
                                style: TextStyle(
                                  color: isLiked
                                      ? Pallete.redColor
                                      : Pallete.greyColor,
                                ),
                              );
                            },
                          ),

                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.share_outlined),
                          ),
                        ],
                      ),
                      const Divider(color: Pallete.greyColor),
                    ],
                  );
                },
                error: (error, stackTrace) =>
                    ErrorText(errorText: error.toString()),
                loading: () => const Loader(),
              );
  }
}
