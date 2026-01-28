import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/common/errror_page.dart';
import 'package:twitterclone/common/loading_page.dart';
import 'package:twitterclone/constants/constants.dart';
import 'package:twitterclone/features/profile/controller/user_profile_controller.dart';
import 'package:twitterclone/features/profile/widget/user_profile.dart';
import 'package:twitterclone/model/user_model.dart';

class UserProfileView extends ConsumerWidget {
  final UserModel userModel;
  const UserProfileView({super.key, required this.userModel});

  static route(UserModel userModel) => MaterialPageRoute(
    builder: (context) => UserProfileView(userModel: userModel),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel copyOfUser = userModel;
    return Scaffold(
      body: ref
          .watch(getLatestUserProfileDataProvider)
          .when(
            data: (data) {
              if (data.events.contains(
                'databases.*.collections.${AppwriteEnvironment.tableId}.documents.${copyOfUser.uId}.update',
              )) {
                copyOfUser = UserModel.fromMap(data.payload);
              }
              return UserProfile(userModel: copyOfUser);
            },
            error: (error, stackTrace) =>
                ErrorText(errorText: error.toString()),

            loading: () {
               return UserProfile(userModel: copyOfUser);
            },
          ),
    );
  }
}
