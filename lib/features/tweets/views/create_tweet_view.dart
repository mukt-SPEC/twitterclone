import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitterclone/Theme/theme.dart';
import 'package:twitterclone/apis/user_api.dart';
import 'package:twitterclone/common/rounded_small_button.dart';
import 'package:twitterclone/constants/assets_constaant.dart';
import 'package:twitterclone/features/auth/controller/auth_controller.dart';

class CreateTweetView extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const CreateTweetView());
  const CreateTweetView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTweetViewState();
}

class _CreateTweetViewState extends ConsumerState<CreateTweetView> {
  final tweetController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    tweetController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close, size: 32),
        ),
        actions: [
          RoundedSmallButton(
            onTap: () {},
            buttonText: 'Tweet',
            buttonColor: Pallete.blueColor,
            textColor: Pallete.whiteColor,
          ),
        ],
      ),
      body: currentUser == null
          ? CircleAvatar()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: currentUser.profilePicture == null
                              ? null
                              : NetworkImage(currentUser.profilePicture!),
                          radius: 32,
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: TextField(
                            controller: tweetController,
                            style: const TextStyle(fontSize: 22),
                            decoration: InputDecoration(
                              hintText: "What's happening",
                              hintStyle: TextStyle(
                                color: Pallete.whiteColor,
                                fontSize: 22,
                              ),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Pallete.greyColor, width: 0.5)),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SvgPicture.asset(AssetsConstants.galleryIcon),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SvgPicture.asset(AssetsConstants.gifIcon),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SvgPicture.asset(AssetsConstants.emojiIcon),
            ),
          ],
        ),
      ),
    );
  }
}
