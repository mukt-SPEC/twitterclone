import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/model/user_model.dart';

class UserProfileView extends ConsumerWidget {
  final UserModel userModel;
  const UserProfileView({super.key, required this.userModel});

  static route(UserModel userModel) => MaterialPageRoute(
    builder: (context) => UserProfileView(userModel: userModel),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(body: );
  }
}
