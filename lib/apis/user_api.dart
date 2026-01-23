import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/constants/constants.dart';
import 'package:twitterclone/core/core.dart';
import 'package:twitterclone/core/provider.dart';
import 'package:twitterclone/core/result.dart';
import 'package:twitterclone/model/user_model.dart';

abstract class InterfaceUserAPI {
  FutureEitherVoid saveUserData(UserModel user);
  Future<Row> getUserData(String uId);
  Future<List<Row>> searchUserByName(String name);
}

final userAPIProvider = Provider<UserAPI>((ref) {
  final tableDB = ref.watch(Dependency.tablesDb);
  return UserAPI(db: tableDB);
});

class UserAPI extends InterfaceUserAPI {
  final TablesDB _db;
  UserAPI({required TablesDB db}) : _db = db;

  @override
  FutureEitherVoid saveUserData(UserModel user) async {
    try {
      await _db.createRow(
        databaseId: AppwriteEnvironment.databaseId,
        tableId: AppwriteEnvironment.tableId,
        rowId: user.uId,
        data: user.toMap(),
      );

      return const Success(null);
    } on AppwriteException catch (e, stackTrace) {
      return Error(
        Failure(e.message ?? 'Some unexpected error occured', stackTrace),
      );
    } catch (e, stackTrace) {
      return Error(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<Row> getUserData(String uId) {
    return _db.getRow(
      databaseId: AppwriteEnvironment.databaseId,
      tableId: AppwriteEnvironment.tableId,
      rowId: uId,
    );
  }

  @override
  Future<List<Row>> searchUserByName(String name) async {
    final doc = await _db.listRows(
      databaseId: AppwriteEnvironment.databaseId,
      tableId: AppwriteEnvironment.tableId,
      queries: [Query.search('name', name)],
    );
    return doc.rows;
  }
}
