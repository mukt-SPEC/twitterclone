import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitterclone/constants/constants.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});
  static route() => MaterialPageRoute(builder: (context) => const HomeView());

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    final appBar = UiConstants.appBar();
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AssetsConstants.homeFilledIcon),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AssetsConstants.searchIcon),
          ),
        ],
      ),
    );
  }
}
