import 'package:flutter/material.dart';
import 'package:twitterclone/Theme/theme.dart';
import 'package:twitterclone/features/auth/view/login_view.dart';

void main() {
  runApp(const XClone());
}

class XClone extends StatelessWidget {
  const XClone({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginView(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
    );
  }
}
