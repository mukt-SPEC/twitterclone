import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitterclone/Theme/theme.dart';
import 'package:twitterclone/common/common.dart';
import 'package:twitterclone/constants/constants.dart';
import 'package:twitterclone/features/auth/controller/auth_controller.dart';
import 'package:twitterclone/features/auth/view/login_view.dart';
import 'package:twitterclone/features/auth/widget/auth_field.dart';

class SignUpView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpView());
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
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

  void onSignUp() {
    ref
        .read(authControllerProvider.notifier)
        .signUp(
          email: _emailController.text,
          password: _passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          AssetsConstants.twitterLogo,
          colorFilter: ColorFilter.mode(Pallete.blueColor, BlendMode.clear),
        ),
      ),
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  spacing: 16,
                  children: [
                    AuthField(
                      //key: _formKey,
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
                        onTap: onSignUp,
                        buttonText: 'Done',
                        buttonColor: Pallete.whiteColor,
                        textColor: Pallete.backgroundColor,
                      ),
                    ),

                    RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        children: [
                          TextSpan(
                            text: 'Log in',
                            style: TextStyle(color: Pallete.blueColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context, LoginView.route());
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
