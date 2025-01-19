import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis_auth/auth_io.dart';

class NotificationService{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission() async{
    NotificationSettings settings = await  messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      criticalAlert: true,
      sound: true
    ) ;
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("User granted permission");
    }
    else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print("User  granted provisional permission");
    }
    else{
      AppSettings.openAppSettings();
      print("User denied permission");
    }
  }



  Future<String>getServerKey()async{
    var scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client= await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "fir-emailauthflutter-dfdf7",
          "private_key_id": "e68171a445a2fd0cab88991b36048e0fa609bd47",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC/2nxDzwIT+rZw\n7Z3E9Ah2udz9O3qPe0iurDqvMt0WlMz4ssXCOiokiRAyNiPT5ZMMFiOa3g71/fL1\nNlXc57If5BkzpcNtLOPmXsNdPeq0XdvcNXzC7OYx8LEblB3m47GR71JKSDmJsLqW\n1Z+b9NcPWznazyp65eCjFRDY/eHU86ddR8ik/97OwQ7l+shAmjFaFI/RxV357uHz\nAznPSxNPMRMwfO+veFWVS8b94GF/ZD39FoCQ9XSkhSd6mtdu77jgVMiTGaEWFJfU\no6DN4oJqGx7aVmE2GdUE+azx2REb7qxyUDfjwjvdPXcpuZBorPiYY195PEQen47k\nzxYwg63NAgMBAAECggEADcTg+T7gn811DYrIMWvwNZEmTphXtfd7ommi9pL4chfw\n1AKElel1v9SEcI4ZKSqHUK1AFevM+BOnPbkOFYIdcxN8SYwih/HaU1zGuajpcNNx\npY7DKvw0ky36kAej07/QrTAXYFRpqLuh0JR5VYiPbL832j/XBSX9ZsbqxCAIdq98\nC4Igsgy14+LXEkCY9NwzUbp7hILf0qBep0wzr+6g5UwoyCAswMq+U1qfAmfPfwD9\n0LtCvEdn3IWiKyLxoXrXTRYid2rtIf2XNLQQHE20k4e7EMjnd1K/ehMYgz+95njz\nFVlI8WxKgefLaSjZP/3F73xsx7+e8sGL+beyB7FdEQKBgQDxyULfAdjfPGN6qgaD\nsTRScmxknQGgf0/oHCjIlvV/qfApoib96dEp7ks+tJqL/fLf/1Fc8NMeOzQn9xZQ\nCBc5++ViWaaaNvcdMApVxU9tPp6Lqy1HfwBeumEzgoCdOOJu24bYq97t8pSuuhgv\n6AAzG+o4GQ90r8z4Mem8TxLrmQKBgQDLIcQv67yRiorrZRebbcfGsEKs2lbP+/wd\nC3cj2A/dSj9pSC5T6CIPwL/MWK+CrU/nb5nl9PqgAFpnWMkzskGwV/0EVWdZcVKW\n9N1kYHU1YM8U90PdepB6ktgfZJwEMJ2BMvJJHAIdOHJycWmRAZzNCZyLYHrSTAsu\nQ+Gw45+UVQKBgCHKVc0izfNM1j5DWsu2zTAki594Dc0nXbx7ivuVlVO1JTo8TiS4\nM6IfimaGCP89i17gqLdLdMXJ0l0ve+/NYamZ2ZHoI49z1Q9AMoGQJKyIztGIJ7jR\nN/UFKSZwu5a9Z2/EwFCxnGM2vq64lT7Etppt8UrLvcw58XRSTW8iwespAoGAbiAO\nRpSdFKJxkhCqbb9kkVk5rJBqhDNuiSiQHMSkRSpdmmxhgWfWH4g180kZTdU7/pLI\ncp0PyvKmEGVYH0jCyCHLsC/E6f6/8csqw6JvqNKlMg6jok0ySuGVfd+Dndnlagf+\nxpgCpWjW0yidPNoM8jQFxKI3tA85+IkgsE+XUkkCgYBd9/56tnp3zW0N8+e+kSeA\nHu6EzWSUTmnA0xLB1IOujbf1DiOd8Hqss+j28iX0UsqZKnjH4DJcZFuziCk8d93B\nMI7GOsoS6WggTEeLDGGizryWufNWz3w8k6W3v5j4O56SjaaiM+7BXklN4oXMgQyg\ncaBzeTXrpAXjhanQFlkzmg==\n-----END PRIVATE KEY-----\n",
          "client_email": "firebase-adminsdk-ckwyj@fir-emailauthflutter-dfdf7.iam.gserviceaccount.com",
          "client_id": "100111761804282742848",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-ckwyj%40fir-emailauthflutter-dfdf7.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }
        ),scopes
    );
    final serverKey=client.credentials.accessToken.data;
    print("serverKey=$serverKey");
    return serverKey;
}
  Future< void> initialized()async{
    AndroidInitializationSettings initializationSettingAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void>showNotification(RemoteMessage message)async{
    AndroidNotificationDetails androidNotificationDetails=const AndroidNotificationDetails(
        'channelId',
        'channelName',
        channelDescription: 'Channel description',
        importance: Importance.max,
        priority: Priority.high
    );
    int notificationId=1;
    NotificationDetails notificationDetails=NotificationDetails(android:androidNotificationDetails );
    await flutterLocalNotificationsPlugin.show(
        notificationId,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: 'Not Present'
        );
    }

  void sendOrderNotification({required String message,required String token,required String senderName })async{
    print('token id :$token');
    final serverKey=await getServerKey();
    try{
      final response=await http.post(Uri.parse('https://fcm.googleapis.com/v1/projects/flutterfirebaseauth-439e4/messages:send'),
          headers: <String,String>{
            'Content-Type':'application/json',
            'Authorization':'Bearer $serverKey  '
          },
          body: jsonEncode(<String, dynamic>{
            "message":{
              "token":token,
              "data":{},
              "notification":{
                "title":senderName,
                "body":message
              }
            }
          })
      );
      if(response.statusCode==200){
      }else{
        print('failed to send notification,Status code:${response.statusCode}');
        Fluttertoast.showToast(msg: 'Failed to send notification');
      }
    }catch(ex){
      print('error sending notification: $ex');
      Fluttertoast.showToast(msg: 'error sending notification');
    }
    }
}
