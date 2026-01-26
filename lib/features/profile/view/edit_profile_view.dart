import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/Theme/theme.dart';
import 'package:twitterclone/common/common.dart';
import 'package:twitterclone/features/auth/controller/auth_controller.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => EditProfileView());
  const EditProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      body: user == null
          ? Loader()
          : Column(
              children: [
                Stack(
                  children: [
                    Positioned.fill(
                      child: user.bannerPicture!.isEmpty
                          ? Container(color: Pallete.blueColor)
                          : Image.network(user.bannerPicture!),
                    ),
                    Positioned(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePicture!),
                        radius: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
