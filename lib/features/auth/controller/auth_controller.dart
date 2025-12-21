import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:twitterclone/apis/auth_api.dart';
import 'package:twitterclone/core/result.dart';

class AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;
  AuthController({required AuthApi authApi}) : _authApi = authApi, super(false);

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final response = await _authApi.signUp(email: email, password: password);

    switch (response) {
      
      case Success(data: final user):
        print('hh') ; 
      case Error(failure: final failure):
        print(failure.message);

    }
  }
}
