import 'package:flutter/material.dart';
import 'package:twitterclone/Theme/palette.dart';

class HashtagteText extends StatelessWidget {
  final String text;
  const HashtagteText({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textspans = [];
    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textspans.add(
          TextSpan(
            text: '$element ',
            style: TextStyle(color: Pallete.blueColor),
          ),
        );
      } else if (element.startsWith('www') || element.startsWith('https://')) {
        textspans.add(
          TextSpan(
            text: '$element ',
            style: TextStyle(color: Pallete.blueColor),
          ),
        );
      } else {
        textspans.add(
          TextSpan(
            text: '$element ',
            style: TextStyle(color: Pallete.whiteColor),
          ),
        );
      }
    });
    return RichText(text: TextSpan(children: textspans));
  }
}
