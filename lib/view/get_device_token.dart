import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DeviceTokenService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> storeDeviceToken() async {
    try {
      String? token = await messaging.getToken();
      if (token != null) {
        String uId = FirebaseAuth.instance.currentUser!.uid ?? '';
        if (uId.isNotEmpty) {
          DatabaseReference ref = FirebaseDatabase.instance.ref("user/$uId");
          await ref.update({"token": token});
          print('Device token stored successfully: $token');
        } else {
          print('Error: User ID is empty.');
        }
      } else {
        print('Error: Token is null.');
      }
    } catch (e) {
      print('Error storing device token: $e');
    }
  }

  Future<Uri?> generateDynamicLink() async {
    var shortLink = await FirebaseDynamicLinks.instance.buildShortLink(
      DynamicLinkParameters(
          link: Uri.parse("https://chatapprealtime.page.link"),
          uriPrefix: "https://chatapprealtime.page.link",
          androidParameters:
              AndroidParameters(packageName: "com.chatapp.conversation")),
    );
    return shortLink.shortUrl;
  }
}
