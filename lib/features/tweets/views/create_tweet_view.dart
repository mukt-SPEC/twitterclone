import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitterclone/Theme/theme.dart';
import 'package:twitterclone/common/common.dart';
import 'package:twitterclone/constants/assets_constaant.dart';
import 'package:twitterclone/core/utils.dart';
import 'package:twitterclone/features/auth/controller/auth_controller.dart';
import 'package:twitterclone/features/tweets/controller/tweet_controller.dart';

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
  List<File> images = [];

  @override
  void dispose() {
    super.dispose();
    tweetController.clear();
  }

  void shareTweet({required BuildContext context}) {
    ref
        .read(tweetControllerProvider.notifier)
        .shareTweet(
          images: images,
          text: tweetController.text,
          context: context,
          repliedto: ''
        );
    Navigator.pop(context);
  }

  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(tweetControllerProvider);

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
            onTap: () => shareTweet(context: context),
            buttonText: 'Tweet',
            buttonColor: Pallete.blueColor,
            textColor: Pallete.whiteColor,
          ),
        ],
      ),
      body: isLoading || currentUser == null
          ? const Loader()
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
                    if (images.isNotEmpty)
                      CarouselSlider(
                        items: images.map((e) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: Image.file(e),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 400,
                          enableInfiniteScroll: false,
                        ),
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
              child: GestureDetector(
                onTap: onPickImages,
                child: SvgPicture.asset(AssetsConstants.galleryIcon),
              ),
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
