import 'package:appwrite/appwrite.dart';
import 'package:twitterclone/constants/constants.dart';
import 'package:twitterclone/core/core.dart';
import 'package:twitterclone/core/result.dart';
import 'package:twitterclone/model/notifcation_model.dart';

abstract class INotificationAPI {
  FutureEitherVoid createNotifcation(Notification notifcation);
}

class NotificationApi implements INotificationAPI {
  final TablesDB _tablesDB;

  NotificationApi({required TablesDB tablesDB}) : _tablesDB = tablesDB;
  @override
  FutureEitherVoid createNotifcation(Notification notifcation) async {
    try {
      await _tablesDB.updateRow(
        databaseId: AppwriteEnvironment.databaseId,
        tableId: AppwriteEnvironment.tableId,
        rowId: ID.unique(),
        data: notifcation.toMap(),
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
}
