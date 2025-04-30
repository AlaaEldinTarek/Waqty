// خدمة Workmanager للإشعارات المجدولة

import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final FlutterLocalNotificationsPlugin notificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);
    await notificationsPlugin.initialize(initSettings);

    final message = inputData?["message"] ?? '📌 تذكير بمهمة';

    await notificationsPlugin.show(
      0,
      '⏰ تذكير من وقتي',
      message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'work_channel_id',
          'WorkManager Channel',
          channelDescription: 'تذكيرات مجدولة من WorkManager',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );

    log('🔔 إشعار Workmanager تم إظهاره: $message');
    return Future.value(true);
  });
}

void scheduleTaskReminder(String title, DateTime taskTime) {
  final now = DateTime.now();
  final difference = taskTime.difference(now);
  final minutes = difference.inMinutes;

  if (minutes > 0) {
    log('📆 تم جدولة إشعار بعد $minutes دقيقة للمهمة: $title');
    Workmanager().registerOneOffTask(
      'reminder_${DateTime.now().millisecondsSinceEpoch}',
      'show_reminder_notification',
      inputData: {"message": "📌 المهمة '$title' هتبدأ بعد $minutes دقيقة"},
      initialDelay: Duration(minutes: minutes),
    );
  } else {
    log('⚠️ لم يتم جدولة الإشعار لأن وقت المهمة أقل من الوقت الحالي');
  }
}
