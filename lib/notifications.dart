import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:plant_app/main.dart';

Future<void> scheduleWateringNotification(String plantName) async {
  final now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime.local(now.year, now.month, now.day, 12, 25);

  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(Duration(days: 1));
  }

  const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'Reminder to water your plant');

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Water Your Plant!',
    '$plantName is waiting to be watered!',
    scheduledDate,
    const NotificationDetails(
        android: AndroidNotificationDetails(
            'your channel id', 'your channel name',
            channelDescription: 'your channel description')),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time,
    payload: scheduledDate.toString());
}
