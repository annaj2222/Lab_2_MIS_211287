import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel =
  AndroidNotificationChannel(
    'daily_reminder_channel',
    'Daily Reminders',
    description: 'Channel for daily random recipe reminder',
    importance: Importance.high,
  );

  static Future<void> initialize({String? timeZone}) async {
    tz.initializeTimeZones();
    try {
      tz.setLocalLocation(
          tz.getLocation(timeZone ?? DateTime.now().timeZoneName));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings =
    InitializationSettings(android: androidInit, iOS: iosInit);

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await FirebaseMessaging.instance.requestPermission();
  }

  static Future<void> scheduleDailyReminder({
    required int id,
    required int hour,
    required int minute,
    String title = "Random Recipe Reminder",
    String body = "Open the app to see today's random recipe!",
  }) async {
    final androidSpecific = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final bool? allowedExact =
    await androidSpecific?.canScheduleExactNotifications();

    if (allowedExact == true) {
      print("EXACT ALARMS PERMITTED → using zonedSchedule");
      final tz.TZDateTime scheduled = _nextInstanceOfTime(hour, minute);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduled,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.high,
          ),
        ),
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
      return;
    }

    print("EXACT ALARMS NOT PERMITTED → using Timer fallback");

    Timer(const Duration(seconds: 10), () {
      flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.high,
          ),
        ),
      );
    });
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
