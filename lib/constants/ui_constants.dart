import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitterclone/Theme/theme.dart';
import 'package:twitterclone/constants/constants.dart';
import 'package:twitterclone/features/explore/view/explore_view.dart';
import 'package:twitterclone/features/tweets/widget/tweet_list.dart';

class UiConstants {
  static AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        colorFilter: ColorFilter.mode(Pallete.blueColor, BlendMode.clear),
      ),
    );
  }

  static List<Widget> bottomTabBarPages = [
    TweetList(),
    ExploreView()
  ];
}
