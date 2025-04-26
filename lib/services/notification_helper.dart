
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationHelper {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> showNotificationBeforeTask(String title, DateTime dateTime) async {
    tz.initializeTimeZones();
    final scheduledDate = tz.TZDateTime.from(dateTime.subtract(const Duration(minutes: 5)), tz.local);

    await _plugin.zonedSchedule(
      dateTime.hashCode,
      'تذكير بالمهمة',
      title,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel_id',
          'Task Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}
