import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/Theme/theme.dart';
import 'package:twitterclone/common/common.dart';
import 'package:twitterclone/features/explore/controller/explore_controller.dart';
import 'package:twitterclone/features/explore/widget/search_tile.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            onSubmitted: (value) {
              setState(() {
                isShowUsers = true;
              });
            },
            controller: searchController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12).copyWith(left: 16),
              fillColor: Pallete.searchBarColor,
              filled: true,

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(color: Pallete.searchBarColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(color: Pallete.searchBarColor),
              ),
              hintText: 'Search twitter',
            ),
          ),
        ),
      ),
      body: isShowUsers
          ? ref
                .watch(searchUserProvider(searchController.text))
                .when(
                  data: (users) {
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (BuildContext context, int index) {
                        final user = users[index];
                        return SearchTile(usermodel: user);
                      },
                    );
                  },
                  error: (error, st) {
                    return ErrorText(errorText: error.toString());
                  },
                  loading: () => const Loader(),
                )
          : const SizedBox(),
    );
  }
}
