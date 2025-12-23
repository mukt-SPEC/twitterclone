import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:twitterclone/apis/auth_api.dart';
import 'package:twitterclone/apis/user_api.dart';

import 'package:twitterclone/core/result.dart';
import 'package:twitterclone/core/utils.dart';
import 'package:twitterclone/features/auth/view/login_view.dart';
import 'package:twitterclone/features/home/view/home_view.dart';

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, bool>((ref) {
      final authProvider = ref.watch(authAPIProvider);
      final userDbprovider = ref.watch(userAPIProvider);
      return AuthController(authApi: authProvider, userApi: userDbprovider);
    });

final currentUserProvider = FutureProvider<User?>((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;
  final UserAPI _userAPI;
  AuthController({required AuthApi authApi, required UserAPI userApi})
    : _authApi = authApi,
      _userAPI = userApi,
      super(false);

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final response = await _authApi.signUp(email: email, password: password);
    state = false;

    switch (response) {
      case Success(data: final user):
        Navigator.push(context, LoginView.route());
        showSnackBar(context, 'Account Created!, Please login');
      case Error(failure: final failure):
        showSnackBar(context, failure.message!);
    }
  }

  Future<User?> currentUser() async {
    final response = await _authApi.currentUser();
    return response;
  }

  void signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final response = await _authApi.signIn(email: email, password: password);
    state = false;

    switch (response) {
      case Success(data: final user):
        Navigator.push(context, HomeView.route());
      case Error(failure: final failure):
        showSnackBar(context, failure.message!);
    }
  }
}
