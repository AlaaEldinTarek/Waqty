// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class AlarmService {
//   static final _notifications = FlutterLocalNotificationsPlugin();
//
//   static Future<void> init() async {
//     // تهيئة الإشعارات
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     await _notifications.initialize(
//       const InitializationSettings(android: android),
//     );
//
//     // تهيئة Alarm Manager
//     await AndroidAlarmManager.initialize();
//   }
//
//   static Future<void> scheduleDailyNotification(TimeOfDay time) async {
//     await AndroidAlarmManager.periodic(
//       const Duration(days: 1),
//       1, // Unique ID
//       _showNotification,
//       exact: true,
//       startAt: _nextTime(time),
//       rescheduleOnReboot: true,
//     );
//   }
//
//   static DateTime _nextTime(TimeOfDay time) {
//     final now = DateTime.now();
//     var scheduled =
//         DateTime(now.year, now.month, now.day, time.hour, time.minute);
//     if (scheduled.isBefore(now)) {
//       scheduled = scheduled.add(const Duration(days: 1));
//     }
//     return scheduled;
//   }
//
//   static Future<void> _showNotification() async {
//     await _notifications.show(
//       0,
//       'تذكير يومي',
//       'حان وقت مراجعة مهامك!',
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'daily_channel',
//           'التذكيرات اليومية',
//           importance: Importance.max,
//         ),
//       ),
//     );
//   }
// }
