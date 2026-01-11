import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitterclone/Theme/theme.dart';

class TweetIconButton extends StatelessWidget {
  final String pathName;
  final String text;
  final VoidCallback onTap;
  const TweetIconButton({
    super.key,
    required this.pathName,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            pathName,
            colorFilter: ColorFilter.mode(Pallete.greyColor, BlendMode.clear),
          ),
          Container(
            margin: const EdgeInsets.all(4),
            child: Text(text, style: TextStyle(),),
          )
        ],
      ),
    );
  }
}
