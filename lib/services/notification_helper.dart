import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

class NotificationHelper {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied ||
        await Permission.notification.isRestricted) {
      final result = await Permission.notification.request();
      debugPrint(
          "🔐 نتيجة طلب الإذن: ${result.isGranted ? 'مسموح ✅' : 'مرفوض ❌'}");
    } else {
      debugPrint("🔔 الإذن موجود مسبقًا ✅");
    }
  }

  static Future<void> showNotificationBeforeTask(
      Map<String, dynamic> task) async {
    final now = DateTime.now();
    final reminderTime =
        DateTime.parse(task['dateTime']).subtract(const Duration(minutes: 5));
    final difference = reminderTime.difference(now);

    print("📅 الوقت الحالي: $now");
    print(
        "🕒 وقت التذكير المحسوب: $reminderTime (${difference.inSeconds} ثانية من الآن)");

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

  static Future<void> showTestNotificationNow() async {
    await _plugin.show(
      999,
      '🚨 إشعار مباشر',
      'ده إشعار فوري من موني علشان نعرف هل فيه مشكلة بالنظام',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel_id',
          'Task Reminders',
          channelDescription: 'Testing direct notifications',
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          fullScreenIntent: true,
        ),
      ),
    );
  }

  static Future<void> debugPrintPendingNotifications() async {
    final pending = await _plugin.pendingNotificationRequests();
    print("📋 عدد الإشعارات المجدولة: ${pending.length}");
    for (var n in pending) {
      print("📝 إشعار مجدول: id=${n.id}, title=${n.title}, body=${n.body}");
    }
  }

  static void showBatteryOptimizationWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("⚠️ تنبيه بشأن الإشعارات"),
        content: const Text(
          "قد يمنع وضع توفير البطارية أو إعدادات النظام ظهور الإشعارات في موعدها.\n\nرجاء التأكد من:\n\n- السماح للتطبيق بالعمل في الخلفية\n- تعطيل تحسين البطارية\n- السماح بالإشعارات حتى في وضع عدم الإزعاج",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("تم الفهم ✅"),
          ),
        ],
      ),
    );
  }
}
