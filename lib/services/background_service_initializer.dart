import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: false,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'وقتي شغّال',
      initialNotificationContent: 'الخدمة تعمل في الخلفية',
    ),
    iosConfiguration: IosConfiguration(),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground',
    'وقتي تذكير',
    description: 'قناة التذكير بالتنبيهات',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();

  await localNotification
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  localNotification.show(
    888,
    'تذكير مهم',
    'لا تنسَ مهمتك الآن!',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'my_foreground',
        'وقتي تذكير',
        icon: 'ic_launcher',
      ),
    ),
  );
}
