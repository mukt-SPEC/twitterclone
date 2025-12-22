import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/Theme/theme.dart';
import 'package:twitterclone/common/common.dart';
import 'package:twitterclone/features/auth/controller/auth_controller.dart';

import 'package:twitterclone/features/auth/view/sign_up_view.dart';

import 'features/home/view/home_view.dart';

void main() {
  runApp(const ProviderScope(child: XClone()));
}

class XClone extends ConsumerWidget {
  const XClone({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: ref
          .watch(currentUserProvider)
          .when(
            data: (user) {
              if (user != null) {
                return const HomeView();
              }
              return const SignUpView();
            },
            error: (error, stackTrace) =>
                Errorpage(errorText: error.toString()),
            loading: () => const LoadingPage(),
          ),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
    );
  }
}
