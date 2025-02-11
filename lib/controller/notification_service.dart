import 'dart:convert';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        provisional: true,
        criticalAlert: true,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User  granted provisional permission");
    } else {
      AppSettings.openAppSettings();
      print("User denied permission");
    }
  }

  Future<String> getServerKey() async {
    var scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "storage-app-a4864",
          "private_key_id": "6469266098227af07a700da2d8eb490315b4cdb7",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC1T/bOLRbnUkmA\ntODjvUaQXJR4CtaPOoUvJxI1MPPLNomcEQAcwO3NY8sROKvKkj59CQnB9KstZzrP\nBiU215YM/2ldaK8xWjCH4sehr+ounzm34obAQgHVJwlUl9i8z3FMke5ieK6bb+9U\njlPstdfU86rv14WKSopDIYhXRaGlSj8x/zO7oQKD1dEk2ZVW+e+yAakCYwQ2zUy1\nJs09iJayDtgmxxmMRv/jldTKvW6TdlIGMK7onZ/LxWTntIViHj7EOcE7b2qfww/0\n9D7N0yFgaC0Tf6xu0gscvRG5fIVHdJnFy5+2QPmYtY8OKr74dirYPnGyHwnOB5H0\nn8wEHSwjAgMBAAECggEAQ53BHG2rS3QgDjwmXDgTjzW/dq8QChUYYxfOjgCmAoRh\nuE6MvKxkYsLTEaaRRnfYjvemaGsuxT1orJkNmtC2WD2OFTQ7lYudaqezrEQ28NEX\njNCRUTSsi0nGDIKeZPd1uMj5XkbEUxpg5ic3/CBqj7OZbV1yIzseKd/hAS7qFAIk\nuOjJrTNmf9BtThDiwX3RYqm8SvnscynglWgD3oEE4qyYb9wRDoy1fuG2+fEnpIF1\na9yHDOxxVMq90J73UHX+3W9mXcSOscQWAZB3sUznRDr7+Smw+ssGpeLkFGSiKIji\nZgVX+OcKW2ATPd2zN/yDu4Jjl8sBH3/KASzAXs/OmQKBgQD2s+AGu9N55ECW/V2D\nLCKuupQ9fRoBlH2Z4fNwkdPcwJHpeAxm0ZF6Q3ZDZWB2/OwUQmTX8jYOZWX+aQJo\ni2lGkqP7WN77uLsFemrSULVYdG7hXlBvE8F+6x98e+58hXfEFawqdEWkCAYTUxHM\njDPa8uKn68GFrF2kXR2Xni7X+QKBgQC8JThVnSjDhiWFgIU7kvH/Cm0/ZRsDPZoD\nDlqXTmqvEEhy+ZL+6e4hZ8Id3zidYsuaNsOU3+vaGbGk9eWcXZEox65A99gBW40W\n4Pi+QnwbNRfU7npVorWoD9nSWw8cI4/Gmb86yXaGwQEywZZDEu5GB14iJUc443Ov\nsDsVOcOD+wKBgQCspK5nJ/RTfddxkrdpP266BloNOcoERw0qrkP1iCfSeXTjBJ7x\nKUF8ZU+S1JQQUOlJODloIdmQc4dP5d7ImJ9Awwg8sjHByMIgkE3HBrIRx9F8p8r0\nIMgtcI9lRzlbLO/maiBEyX+ezfqqdVykX40+cPELAGI6kKgriPpXi1xOyQKBgBQG\nJhO+kTsWCOJHhmaLwiOxuWTY3uIeaUjP+0ZFO0d8hSlvdHya6xQ1FczWGBFwFVlJ\nYNF0b4ab23NCFHjq4GslrV8OwbeLRd3cfbzKGKlQokOwSebZVVoYrcccl+QXyNKL\nRHX+QRYgbn83aUWkOyXK3PLnYsgkNQjKyc79gdiHAoGBAK0P4zUajY3EP8P45KnW\nF7t0cNoZ9o3w1J2lA+D9oh+dRk0n+NTTrcHY2SGZNvqtKG61FaZLpYMpZfnjIYes\nu6nmNYjogZFCpf3ISiZ6x2M9qGYeSOBgLWznPnex5ZeXart+rG1mBAWn1ATEXMY8\ndgK3+enHBFGD3ET+UsiinPe0\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-jtx8l@storage-app-a4864.iam.gserviceaccount.com",
          "client_id": "117981088789208489519",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-jtx8l%40storage-app-a4864.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        scopes);
    final serverKey = client.credentials.accessToken.data;
    print("serverKey=$serverKey");
    return serverKey;
  }

  Future<void> initialized() async {
    AndroidInitializationSettings initializationSettingAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('channelId', 'channelName',
            channelDescription: 'Channel description',
            importance: Importance.max,
            priority: Priority.high);
    int notificationId = 1;
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        notificationId,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: 'Not Present');
  }

  Future<void> sendOrderNotification(
      {required String message,
      required String token,
      required String senderName}) async {
    print('token id :$token');
    final serverKey = await getServerKey();
    try {
      final response = await http.post(
          Uri.parse(
              'https://fcm.googleapis.com/v1/projects/storage-app-a4864/messages:send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $serverKey'
          },
          body: jsonEncode(<String, dynamic>{
            "message": {
              "token": token,
              "notification": {"title": senderName, "body": message}
            }
          }));
      if (response.statusCode == 200) {
        print('Notification send success');
        Fluttertoast.showToast(msg: ' send notification successfully');
      } else {
        print('failed to send notification,Status code:${response.body}');
        Fluttertoast.showToast(
            msg: 'Failed to send notification ${response.body}');
        Fluttertoast.showToast(msg: token);
      }
    } catch (ex) {
      print('error sending notification: $ex');
      Fluttertoast.showToast(msg: 'error sending notification');
    }
  }
}
