import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitterclone/Theme/theme.dart';
import 'package:twitterclone/constants/constants.dart';
import 'package:twitterclone/features/tweets/views/create_tweet_view.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});
  static route() => MaterialPageRoute(builder: (context) => const HomeView());

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _page = 0;

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  onCreateTweet() {
    Navigator.push(context, CreateTweetView.route());
  }

  @override
  Widget build(BuildContext context) {
    final appBar = UiConstants.appBar();
    return Scaffold(
      appBar: _page == 0 ? appBar : null,
      body: IndexedStack(index: _page, children: UiConstants.bottomTabBarPages),
      floatingActionButton: FloatingActionButton(
        onPressed: onCreateTweet,
        child: const Icon(Icons.add, color: Pallete.whiteColor),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: onPageChange,
        backgroundColor: Pallete.backgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 0
                  ? AssetsConstants.homeFilledIcon
                  : AssetsConstants.homeOutlinedIcon,
              colorFilter: ColorFilter.mode(
                Pallete.whiteColor,
                BlendMode.clear,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 1
                  ? AssetsConstants.searchIcon
                  : AssetsConstants.searchIcon,
              colorFilter: ColorFilter.mode(
                Pallete.whiteColor,
                BlendMode.clear,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 2
                  ? AssetsConstants.notifFilledIcon
                  : AssetsConstants.notifOutlinedIcon,
              colorFilter: ColorFilter.mode(
                Pallete.whiteColor,
                BlendMode.clear,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
