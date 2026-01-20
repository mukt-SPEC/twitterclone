import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twitterclone/constants/appwrite_constant.dart';
import 'package:twitterclone/core/core.dart';
import 'package:twitterclone/core/provider.dart';
import 'package:twitterclone/core/result.dart';
import 'package:twitterclone/model/tweet_model.dart';

final tweetAPIProvider = Provider((ref) {
  return TweetApi(
    db: ref.watch(Dependency.tablesDb),
    realTime: ref.watch(Dependency.realtime),
  );
});

abstract class InterfaceTweetApi {
  Future<List<Row>> getTweet();
  Stream<RealtimeMessage> getLatestTweet();
  FutureResult<Row> shareTweet({Tweet tweet});
  FutureResult<Row> likeTweet({Tweet tweet});
  FutureResult<Row> updaateResharecount({Tweet tweet});
  Future<List<Row>> getTweetReplies({Tweet tweet});
  Future<Row> getTweetById({String id});
}

class TweetApi implements InterfaceTweetApi {
  final Realtime _realtime;
  final TablesDB _db;
  TweetApi({required TablesDB db, required Realtime realTime})
    : _db = db,
      _realtime = realTime;
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

  @override
  Future<List<Row>> getTweet() async {
    final doc = await _db.listRows(
      databaseId: AppwriteEnvironment.databaseId,
      tableId: AppwriteEnvironment.tweetCollection,
      queries: [Query.orderDesc('tweetedAt')],
    );
    return doc.rows;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      'databases.${AppwriteEnvironment.databaseId}.collections.${AppwriteEnvironment.tweetCollection}.documents',
    ]).stream;
  }

  @override
  FutureResult<Row> likeTweet({Tweet? tweet}) async {
    try {
      final document = await _db.updateRow(
        databaseId: AppwriteEnvironment.databaseId,
        tableId: AppwriteEnvironment.tweetCollection,
        rowId: tweet!.id,
        data: {'likes': tweet.likes},
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

  @override
  FutureResult<Row> updaateResharecount({Tweet? tweet}) async {
    try {
      final document = await _db.updateRow(
        databaseId: AppwriteEnvironment.databaseId,
        tableId: AppwriteEnvironment.tweetCollection,
        rowId: tweet!.id,
        data: {'reshareCount': tweet.reshareCount},
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

  @override
  Future<List<Row>> getTweetReplies({Tweet? tweet}) async {
    final doc = await _db.listRows(
      databaseId: AppwriteEnvironment.databaseId,
      tableId: AppwriteEnvironment.tweetCollection,
      queries: [Query.equal('repliedTo', tweet!.id)],
    );
    return doc.rows;
  }

  @override
  Future<Row> getTweetById({String? id}) async {
    return _db.getRow(
      databaseId: AppwriteEnvironment.databaseId,
      tableId: AppwriteEnvironment.tweetCollection,
      rowId: id!,
    );
  }
}
