import 'package:chat_app_realtime/firebase_options.dart';
import 'package:chat_app_realtime/view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/chat_view_model.dart';
import 'controller/notification_service.dart';
import 'controller/user_view_model.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  NotificationService notificationService = NotificationService();
  notificationService.initialized();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserViewModel(),),
    ChangeNotifierProvider(create: (context) => ChatViewModel(),),
  ],child: MyApp(),));

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}

