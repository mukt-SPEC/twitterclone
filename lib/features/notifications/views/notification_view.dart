import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/common/common.dart';
import 'package:twitterclone/constants/constants.dart';
import 'package:twitterclone/features/auth/controller/auth_controller.dart';
import 'package:twitterclone/features/notifications/controller/notification_controller.dart';
import 'package:twitterclone/features/tweets/controller/tweet_controller.dart';
import 'package:twitterclone/features/tweets/widget/tweet_card.dart';
import 'package:twitterclone/model/tweet_model.dart';
import 'package:twitterclone/model/notifcation_model.dart' as notif;

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: currentUser == null
          ? const Loader()
          : ref
                .watch(getNotificationsProvider(currentUser.uId))
                .when(
                  data: (notifications) {
                    return ref
                        .watch(getLatestNotificationProvider)
                        .when(
                          data: (notification) {
                            if (notification.events.contains(
                              'databases.*.collections.${AppwriteEnvironment.notificationCollection}.documents.*.create',
                            )) {
                              notifications.insert(
                                0,
                                notif.Notification.fromMap(
                                  notification.payload,
                                ),
                              );
                            }

                            return ListView.builder(
                              itemCount: notifications.length,
                              itemBuilder: (BuildContext context, int index) {
                                final notification = notifications[index];
                                return null;
                              },
                            );
                          },
                          error: (error, stackTrace) =>
                              ErrorText(errorText: error.toString()),
                          loading: () {
                             return Expanded(
                               child: ListView.builder(
                                itemCount: notifications.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final notification = notifications[index];
                                  return null;
                                },
                                                           ),
                             );
                          },
                        );
                  },
                  error: (error, stackTrace) =>
                      ErrorText(errorText: error.toString()),
                  loading: () => const Loader(),
                ),
    );
  }
}
