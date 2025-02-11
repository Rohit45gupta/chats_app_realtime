import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  final String callID;
  final String senderName;

  const CallPage({super.key, required this.callID, required this.senderName});

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 139405675,
      // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign:
          "a14d9220786f82013019a8f39994c41ec4f8f7c3a6358198fa38982dd4c0ea13",
      // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: 'user_id',
      userName: senderName,
      callID: callID,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
