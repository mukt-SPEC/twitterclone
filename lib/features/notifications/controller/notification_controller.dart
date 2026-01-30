import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:twitterclone/apis/notification_api.dart';
import 'package:twitterclone/core/enums.dart';
import 'package:twitterclone/model/notifcation_model.dart';

final notificationControllerProvider =
    StateNotifierProvider.autoDispose<NotificationController, bool>((ref) {
      final notificationApi = ref.watch(notificationApiProvider);
      return NotificationController(notificationApi: notificationApi);
    });

final getLatestNotificationProvider = StreamProvider.autoDispose((ref) {
  final notificationApi = ref.watch(notificationApiProvider);
  return notificationApi.getLatestNotification();
});

final getNotificationsProvider = FutureProvider.family((ref, String uId) async {
  final notificationController = ref.watch(
    notificationControllerProvider.notifier,
  );
  return notificationController.getNotifications(uId);
});

class NotificationController extends StateNotifier<bool> {
  final NotificationApi _notificationApi;
  NotificationController({required NotificationApi notificationApi})
    : _notificationApi = notificationApi,
      super(false);

  void createNotifcation({
    required String text,
    required String postId,
    required NotificationType notificationType,
    required String uId,
  }) async {
    final notification = Notification(
      text: text,
      postId: postId,
      id: '',
      uId: uId,
      notificationType: notificationType,
    );

    final res = await _notificationApi.createNotifcation(notification);
  }

  Future<List<Notification>> getNotifications(String uId) async {
    final notifications = await _notificationApi.getNotifications(uId);
    return notifications.map((e) => Notification.fromMap(e.data)).toList();
  }
}
