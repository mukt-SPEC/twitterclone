import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/Theme/theme.dart';
import 'package:twitterclone/common/common.dart';
import 'package:twitterclone/common/loading_page.dart';
import 'package:twitterclone/constants/constants.dart';
import 'package:twitterclone/features/auth/controller/auth_controller.dart';
import 'package:twitterclone/features/profile/controller/user_profile_controller.dart';
import 'package:twitterclone/features/profile/view/edit_profile_view.dart';
import 'package:twitterclone/features/profile/widget/follow_count.dart';
import 'package:twitterclone/features/tweets/controller/tweet_controller.dart';
import 'package:twitterclone/features/tweets/widget/tweet_card.dart';
import 'package:twitterclone/model/tweet_model.dart';
import 'package:twitterclone/model/user_model.dart';

class UserProfile extends ConsumerWidget {
  final UserModel userModel;
  const UserProfile({required this.userModel, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: userModel.bannerPicture!.isEmpty
                            ? Container(color: Pallete.blueColor)
                            : Image.network(
                                userModel.bannerPicture!,
                                fit: BoxFit.fitWidth,
                              ),
                      ),
                      Positioned(
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            userModel.profilePicture!,
                          ),
                          radius: 40,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: EdgeInsets.all(12),
                        child: OutlinedButton(
                          onPressed: () {
                            if (currentUser.uId == userModel.uId) {
                              Navigator.push(context, EditProfileView.route());
                            } else {
                              ref
                                  .read(userProfileControllerProvider.notifier)
                                  .followUser(
                                    user: userModel,
                                    context: context,
                                    currentUser: currentUser,
                                  );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: Pallete.whiteColor),
                            ),
                          ),
                          child: Text(
                            currentUser.uId == userModel.uId
                                ? 'Edit Profile'
                                : currentUser.following.contains(userModel.uId)
                                ? 'Unfollow'
                                : 'Follow',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Text(userModel.name),
                      Text(userModel.bioDescription),
                      const SizedBox(height: 8),
                      Row(
                        spacing: 16,
                        children: [
                          FollowCount(
                            count: userModel.followers.length - 1,
                            text: 'Followers',
                          ),
                          FollowCount(
                            count: userModel.following.length - 1,
                            text: 'Following',
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),
                      const Divider(color: Pallete.whiteColor),
                    ]),
                  ),
                ),
              ];
            },
            body: ref
                .watch(getUserTweetProvider(userModel.uId))
                .when(
                  data: (tweets) {
                    return ref
                        .watch(getLatestTweetProvider)
                        .when(
                          data: (data) {
                            final latestTweet = Tweet.fromMap(data.payload);

                            bool isTweetAlreadyPresent = false;
                            for (final tweetModel in tweets) {
                              if (tweetModel.id == latestTweet.id) {
                                isTweetAlreadyPresent = true;
                                break;
                              }
                            }
                            if (!isTweetAlreadyPresent) {
                              if (data.events.contains(
                                'databases.*.collections.${AppwriteEnvironment.tweetCollection}.documents.*.create',
                              )) {
                                tweets.insert(0, Tweet.fromMap(data.payload));
                              } else if (data.events.contains(
                                'databases.*.collections.${AppwriteEnvironment.tweetCollection}.documents.*.uodate',
                              )) {
                                final startingPoint = data.events[0]
                                    .lastIndexOf('documents.');
                                final endingPoint = data.events[0].lastIndexOf(
                                  '.update',
                                );

                                final tweetId = data.events[0].substring(
                                  startingPoint + 10,
                                  endingPoint,
                                );

                                var tweet = tweets
                                    .where((e) => e.id == tweetId)
                                    .first;

                                final tweetIndex = tweets.indexOf(tweet);
                                tweets.removeWhere((e) => e.id == tweetId);

                                tweet = Tweet.fromMap(data.payload);

                                tweets.insert(tweetIndex, tweet);
                              }
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
                  error: (error, st) {
                    return ErrorText(errorText: error.toString());
                  },
                  loading: () => Loader(),
                ),
          );
  }
}
