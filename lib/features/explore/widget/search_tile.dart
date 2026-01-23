import 'package:flutter/material.dart';
import 'package:twitterclone/model/user_model.dart';

class SearchTile extends StatelessWidget {
  final UserModel usermodel;
  const SearchTile({super.key, required this.usermodel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(usermodel.profilePicture!),
      ),
      title: Text(usermodel.name),
      subtitle: Column(),
    );
  }
}
