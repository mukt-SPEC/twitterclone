import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/constants/constants.dart';
import 'package:twitterclone/core/core.dart';
import 'package:twitterclone/core/provider.dart';
import 'package:twitterclone/core/result.dart';
import 'package:twitterclone/model/notifcation_model.dart';

final notificationApiProvider = Provider.autoDispose<NotificationApi>((ref) {
  final tablesDB = ref.watch(Dependency.tablesDb);
  final realtime = ref.watch(Dependency.realtime);

  return NotificationApi(tablesDB: tablesDB, realTime: realtime);
});



abstract class INotificationAPI {
  FutureEitherVoid createNotifcation(Notification notifcation);
  Future<List<Row>> getNotifications(String uId);
  Stream<RealtimeMessage> getLatestNotification();
}

class NotificationApi implements INotificationAPI {
  final TablesDB _tablesDB;
  final Realtime _realtime;
  NotificationApi({required TablesDB tablesDB, required Realtime realTime})
    : _realtime = realTime,
      _tablesDB = tablesDB;
  @override
  FutureEitherVoid createNotifcation(Notification notification) async {
    try {
      await _tablesDB.updateRow(
        databaseId: AppwriteEnvironment.databaseId,
        tableId: AppwriteEnvironment.notificationCollection,
        rowId: ID.unique(),
        data: notification.toMap(),
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
  Future<List<Row>> getNotifications(String uId) async {
    final doc = await _tablesDB.listRows(
      databaseId: AppwriteEnvironment.databaseId,
      tableId: AppwriteEnvironment.notificationCollection,
      queries: [Query.equal('uId', uId)],
    );
    return doc.rows;
  }

  @override
  Stream<RealtimeMessage> getLatestNotification() {
    return _realtime.subscribe([
      'databases.${AppwriteEnvironment.databaseId}.collections.${AppwriteEnvironment.notificationCollection}.documents',
    ]).stream;
  }
}
