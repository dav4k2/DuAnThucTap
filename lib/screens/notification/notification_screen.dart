import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/notification/widgets/notification_header.dart';
import 'package:fontend/screens/notification/widgets/notification_item.dart';
import 'package:fontend/screens/notification/widgets/notification_section_title.dart';
import 'logic/notification_provider.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayData = ref.watch(notificationProvider);
    final yesterdayData = ref.watch(notificationProviderYesterday);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: NotificationHeader(
          onMarkRead: () {
            ref.read(notificationProvider.notifier).markAllRead();
            ref.read(notificationProviderYesterday.notifier).markAllRead();
          },
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const NotificationSectionTitle(title: "HÔM NAY"),
          ...todayData.map((e) => NotificationItem(data: e)),
          const SizedBox(height: 16),
          const NotificationSectionTitle(title: "HÔM QUA"),
          ...yesterdayData.map((e) => NotificationItem(data: e)),
        ],
      ),
    );
  }
}