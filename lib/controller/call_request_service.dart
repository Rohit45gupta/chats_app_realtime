import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../view/get_device_token.dart';
import 'notification_service.dart';

class RequestCallService {
  final DeviceTokenService deviceTokenService = DeviceTokenService();
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref("callRequest");

  Future<void> sendCallRequest(String receiverID, String callID) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    String? senderName = FirebaseAuth.instance.currentUser?.displayName;

    if (uid == null || senderName == null) return;

    await reference.child(receiverID).set({
      "callerId": uid,
      "call_id": callID,
      "callerName": senderName,
      "dateTIme": DateTime.now().toIso8601String()
    });

    DatabaseReference userRef =
        FirebaseDatabase.instance.ref("callRequest/$receiverID");
    DatabaseEvent event = await userRef.once();
    if (event.snapshot.exists) {
      Map userData = event.snapshot.value as Map;
      String? receiverToken = deviceTokenService.storeDeviceToken().toString();
      await NotificationService().sendCallNotification(
        callId: callID,
        receiverToken: receiverToken,
        senderName: senderName,
      );
    }
  }

  Stream<DatabaseEvent> listenForIncomingcall(String userID) {
    return reference.child(userID).onValue;
  }

  Future<void> removeCallRequest(String userId) async {
    await reference.child(userId).remove();
  }
}
