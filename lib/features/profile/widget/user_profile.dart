import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/Theme/theme.dart';
import 'package:twitterclone/common/loading_page.dart';
import 'package:twitterclone/features/auth/controller/auth_controller.dart';
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
                            : Image.network(userModel.bannerPicture!),
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
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: Pallete.whiteColor),
                            ),
                          ),
                          child: Text(
                            currentUser.uId == userModel.uId
                                ? 'Edit Profile'
                                : 'Follow',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: Column(),
          );
  }
}
