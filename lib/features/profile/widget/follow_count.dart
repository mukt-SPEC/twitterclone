import 'package:flutter/material.dart';
import 'package:twitterclone/Theme/theme.dart';

class FollowCount extends StatelessWidget {
  final int count;
  final String text;
  const FollowCount({super.key, required this.count, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        Text('$count', style: const TextStyle(color: Pallete.whiteColor)),
        Text(text, style: const TextStyle(color: Pallete.greyColor)),
      ],
    );
  }
}
