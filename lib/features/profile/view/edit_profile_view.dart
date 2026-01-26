import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/Theme/theme.dart';
import 'package:twitterclone/common/common.dart';
import 'package:twitterclone/core/utils.dart';
import 'package:twitterclone/features/auth/controller/auth_controller.dart';
import 'package:twitterclone/features/profile/controller/user_profile_controller.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => EditProfileView());
  const EditProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  File? bannerFile;
  File? profileFile;

  @override
  void initState() {
    nameController = TextEditingController(
      text: ref.read(currentUserDetailsProvider).value?.name ?? '',
    );
    bioController = TextEditingController(
      text: ref.read(currentUserDetailsProvider).value?.bioDescription ?? '',
    );
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void selectBannerImage() async {
    final banner = await pickImage();
    if (banner != null) {
      setState(() {
        bannerFile = banner;
      });
    }
  }

  void selectProfileImage() async {
    final profile = await pickImage();
    if (profile != null) {
      setState(() {
        profileFile = profile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDetailsProvider).value;
    final isloading = ref.watch(userProfileControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              ref
                  .read(userProfileControllerProvider.notifier)
                  .updateUserProfile(
                    user: user!.copyWith(
                      bioDescription: bioController.text,
                      name: nameController.text,
                    ),
                    context: context,
                    bannerFile: bannerFile,
                    profileFile: profileFile,
                  );
            },
            child: const Text('save'),
          ),
        ],
      ),
      body: isloading || user == null
          ? Loader()
          : Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: selectBannerImage,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: bannerFile != null
                              ? Image.file(bannerFile!, fit: BoxFit.fitWidth)
                              : user.bannerPicture!.isEmpty
                              ? Container(color: Pallete.blueColor)
                              : Image.network(
                                  user.bannerPicture!,
                                  fit: BoxFit.fitWidth,
                                ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 12,
                        child: GestureDetector(
                          onTap: selectProfileImage,
                          child: profileFile != null
                              ? CircleAvatar(
                                  backgroundImage: FileImage(profileFile!),
                                  radius: 40,
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    user.profilePicture!,
                                  ),
                                  radius: 40,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Enter Bio',

                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
    );
  }
}
