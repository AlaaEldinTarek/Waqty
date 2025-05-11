import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);
  }

  static Future<void> showNotification(String title) async {
    await _plugin.show(
      title.hashCode,
      '📌 تذكير بمهمة',
      "المهمة '$title' ستبدأ قريبًا",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel_id',
          'Task Reminders',
          channelDescription: 'تذكير بالمهام',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}
