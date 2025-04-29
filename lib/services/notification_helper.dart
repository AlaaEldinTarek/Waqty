import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied ||
        await Permission.notification.isRestricted) {
      await Permission.notification.request();
    }
  }

  static Future<void> showNotificationBeforeTask(
      Map<String, dynamic> task) async {
    final now = DateTime.now();
    final reminderTime =
        DateTime.parse(task['dateTime']).subtract(const Duration(minutes: 5));

    if (reminderTime.isBefore(now.add(const Duration(minutes: 1)))) {
      await _showImmediateNotification(task);
    } else {
      await _scheduleExactNotification(task, reminderTime);
    }
  }

  static Future<void> _showImmediateNotification(
      Map<String, dynamic> task) async {
    await _plugin.show(
      task['title'].hashCode,
      '📌 تذكير بمهمة',
      "المهمة '${task['title']}' ستبدأ بعد قليل",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel_id',
          'Task Reminders',
          channelDescription: 'Immediate task reminder',
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          fullScreenIntent: true,
        ),
      ),
    );
  }

  static Future<void> _scheduleExactNotification(
      Map<String, dynamic> task, DateTime reminderTime) async {
    await _plugin.zonedSchedule(
      task['title'].hashCode,
      '📌 تذكير بمهمة قادمة',
      "${task['title']} ستبدأ بعد 5 دقائق",
      tz.TZDateTime.from(reminderTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel_id',
          'Task Reminders',
          channelDescription: 'Scheduled task reminder',
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelNotification(String title) async {
    await _plugin.cancel(title.hashCode);
  }
}
