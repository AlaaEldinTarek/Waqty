import '../services/notification_helper.dart';

void alarmCallback(String title) {
  NotificationHelper.showNotification(title);
}
