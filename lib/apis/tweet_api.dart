import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:twitterclone/constants/appwrite_constant.dart';
import 'package:twitterclone/core/core.dart';
import 'package:twitterclone/core/enums.dart';
import 'package:twitterclone/core/result.dart';
import 'package:twitterclone/model/tweet_model.dart';

abstract class InterfaceTweetApi {
  // Future<void> uploadTweet({
  //   required String text,
  //   required String uid,
  //   required List<String> images,
  //   required TweetType tweetType,
  //   String? link,
  //   List<String>? hashTags,
  // });

  FutureResult<TablesDB> shareTweet({Tweet tweet});
}

class TweetApi implements InterfaceTweetApi {
  final Databases _db;
  TweetApi({required Databases db}) : _db = db;
  @override
  FutureResult<Document> shareTweet({Tweet? tweet}) async {
    try {
   
      return Success(_db);
    } on AppwriteException catch (e, stackTrace) {
      return Error(
        Failure(e.message ?? 'Some unexpected error occured', stackTrace),
      );
    } catch (e, stackTrace) {
      return Error(Failure(e.toString(), stackTrace));
    }
  }
}
