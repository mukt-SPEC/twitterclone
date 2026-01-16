import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/Theme/theme.dart';
import 'package:twitterclone/common/common.dart';
import 'package:twitterclone/constants/ui_constants.dart';
import 'package:twitterclone/features/auth/controller/auth_controller.dart';
import 'package:twitterclone/features/auth/view/sign_up_view.dart';

import '../widget/auth_field.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginView());
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final appBar = UiConstants.appBar();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void onLogIn() {
    ref
        .read(authControllerProvider.notifier)
        .signIn(
          email: _emailController.text,
          password: _passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appBar,
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  spacing: 16,
                  children: [
                    AuthField(
                      // key: _formKey,
                      controller: _emailController,
                      hintText: 'Email Address',
                      obscureText: false,
                    ),
                    AuthField(
                      //key: _formKey,
                      controller: _passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                    Align(
                      alignment: AlignmentGeometry.centerRight,
                      child: RoundedSmallButton(
                        onTap: onLogIn,
                        buttonText: 'Done',
                        buttonColor: Pallete.whiteColor,
                        textColor: Pallete.backgroundColor,
                      ),
                    ),

                    RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        children: [
                          TextSpan(
                            text: 'Join now',
                            style: TextStyle(color: Pallete.blueColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context, SignUpView.route());
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
