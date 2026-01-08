import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twitterclone/constants/appwrite_constant.dart';
import 'package:twitterclone/core/core.dart';
import 'package:twitterclone/core/enums.dart';
import 'package:twitterclone/core/provider.dart';
import 'package:twitterclone/core/result.dart';
import 'package:twitterclone/model/tweet_model.dart';

final tweetAPIProvider = Provider((ref) {
  return TweetApi(db: ref.watch(Dependency.tablesDb));
});

abstract class InterfaceTweetApi {
  // Future<void> uploadTweet({
  //   required String text,
  //   required String uid,
  //   required List<String> images,
  //   required TweetType tweetType,
  //   String? link,
  //   List<String>? hashTags,
  // });

  FutureResult<Row> shareTweet({Tweet tweet});
}

class TweetApi implements InterfaceTweetApi {
  final TablesDB _db;
  TweetApi({required TablesDB db}) : _db = db;
  @override
  FutureResult<Row> shareTweet({Tweet? tweet}) async {
    try {
      final document = await _db.createRow(
        databaseId: AppwriteEnvironment.databaseId,
        tableId: AppwriteEnvironment.tweetCollection,
        rowId: ID.unique(),
        data: tweet!.toMap(),
      );
      return Success(document);
    } on AppwriteException catch (e, stackTrace) {
      return Error(
        Failure(e.message ?? 'Some unexpected error occured', stackTrace),
      );
    } catch (e, stackTrace) {
      return Error(Failure(e.toString(), stackTrace));
    }
  }
}
