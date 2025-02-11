import 'dart:io';

import 'package:chat_app_realtime/controller/notification_service.dart';
import 'package:chat_app_realtime/view/user_status_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controller/chat_view_model.dart';
import 'home_screen.dart';

class ChatPage extends StatefulWidget {
  final String otherUid;
  final String name;
  final String email;
  final String profilePic;

  const ChatPage({super.key,
    required this.otherUid,
    required this.name,
    required this.email,
    required this.profilePic});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final uId = FirebaseAuth.instance.currentUser?.uid;
  ScrollController controller = ScrollController();
  UserStatusManager userStatusManager = UserStatusManager();
  NotificationService notificationService = NotificationService();
  var firebaseInstance = FirebaseAuth.instance.currentUser!.displayName;
  File? imageFile;


  @override
  void initState() {
    super.initState();
    var uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    Future.delayed(const Duration(seconds: 2), () async {
        var viewModel = Provider.of<ChatViewModel>(context, listen: false);
        var chatRoomId = await viewModel.getChatList(
            cid: uid, otherId: widget.otherUid);
      },
    );
    userStatusManager.setStatus(true);
    userStatusManager.monitorConnection();
  }

  void dispose() {
    super.dispose();
    userStatusManager.setStatus(true);
  }

  void deactivate() {
    super.deactivate();
    userStatusManager.setStatus(false);
  }

  void activate() {
    super.activate();
    userStatusManager.setStatus(true);
  }
  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<ChatViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        leadingWidth: 20,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomePage(uid: ''),));
            },
            icon: const Icon(Icons.arrow_back)),
        title: Expanded(
          child: Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(widget.profilePic),),
              SizedBox(width: 5,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: TextStyle(fontSize: 16),),
                  userStatusWidget(widget.otherUid)
                ],
              )
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () => (),
              icon: Icon(Icons.add_call, color: Colors.white)),
          IconButton(
              onPressed: () => (),
              icon: Icon(Icons.video_call, color: Colors.white, size: 26,)
          ),
          PopupMenuButton(
              itemBuilder: (context) =>
              [
                PopupMenuItem(
                    child: ListTile(
                      title: Text('View contact'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )),
                PopupMenuItem(
                    child: ListTile(
                      title: Text('Group info'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )),
                PopupMenuItem(
                    child: ListTile(
                      title: Text('Media,links'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )),
                PopupMenuItem(child: ListTile(title: Text('Wallpaper'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ))
              ])
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height - 210 -
                MediaQuery.of(context).viewInsets.bottom,
            child: Consumer<ChatViewModel>(
              builder: (context, value, child) {
                if (value.chatList.isEmpty) {
                  return const Text("no chat available");
                }
                return ListView.builder(
                  controller: controller,
                  itemCount: value.chatList.length,
                  itemBuilder: (context, index) {
                    var user = value.chatList[index];

                    // DateTime timeSpent = DateTime.parse(user.dateTime ??'');
                    // String timeFormat = DateFormat('hh:mm').format(timeSpent);
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: user.senderId == uId
                            ? Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                    margin: EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.all(10),
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.sizeOf(context).width /
                                                1.2),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        )),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${user.message}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                        Text(user.dateTime != null
                                            ? DateFormat.jm().format(
                                                user.dateTime!.toLocal())
                                            : "No Time Available")
                                      ],
                                    )),
                              )
                            : Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    margin: EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.all(10),
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.sizeOf(context).width /
                                                1.2),
                                    decoration: const BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        )),
                                    child: Column(
                                      children: [
                                        Text('${user.message}'),
                                        Text(user.dateTime != null
                                            ? DateFormat.jm().format(
                                                user.dateTime!.toLocal())
                                            : "No Time Available")
                                      ],
                                    )),
                              ));
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 100,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: IconButton(
                    onPressed: () {
                      takeImage();
                    },
                    icon: Icon(
                      Icons.image_rounded,
                      size: 30,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: TextField(
                    controller: viewModel.chatController,
                    decoration: InputDecoration(
                        hintText: " type massage...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: IconButton(
                      onPressed: () {
                        // sendNotificationToUser(senderName: firebaseInstance.toString(), message: viewModel.chatController.text, otherUid: viewModel.otherUId);
                        viewModel.sendChat(otherUid: widget.otherUid);
                        Future.delayed(
                          Duration(milliseconds: 300),
                          () {
                            controller
                                .jumpTo(controller.position.maxScrollExtent);
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.send,
                        size: 26,
                        color: Colors.blueAccent,
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void takeImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? img = await imagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        imageFile = File(img.path);
      });
    }
  }

  Widget userStatusWidget(String userId) {
    return StreamBuilder(
        stream: FirebaseDatabase.instance.ref('user/$userId/status').onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            Map<String, dynamic> status =
                Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
            bool isOnline = status['Online'] ?? false;
            String lastSeen = status['lastSeen'] ?? '';

            if (isOnline) {
              return Text(
                'Online',
                style: TextStyle(color: Colors.white, fontSize: 16),
              );
            } else {
              DateTime lastSeenTime = DateTime.parse(lastSeen);
              DateTime now = DateTime.now();
              String formattedTime = DateFormat('hh:mm a').format(lastSeenTime);
              String lastSeenText;
              if (lastSeenTime.year == now.year &&
                  lastSeenTime.month == now.month &&
                  lastSeenTime.day == now.day) {
                lastSeenText = "last seen today at $formattedTime";
              } else if (lastSeenTime.year == now.year &&
                  lastSeenTime.month == now.month &&
                  lastSeenTime.day == now.day - 1) {
                lastSeenText = "last seen yesterday at $formattedTime";
              } else {
                lastSeenText =
                    "last seen on ${DateFormat('dd/MM/yyyy,hh:mm a').format(lastSeenTime)}";
              }
              return Text(
                lastSeenText,
                style: TextStyle(fontSize: 10, color: Colors.white),
              );
            }
          }
          return Text('');
        });
  }

// Future<void> sendNotificationToUser({required String senderName, required String message,required String otherUid}) async {
//   var deviceTokenGetData = DeviceTokenService();
//   String? deviceToken =
//   await deviceTokenGetData.getDeviceTokenFromFirebase(otherUid);
//   if (deviceToken != null && message.isNotEmpty) {
//     await notificationService.sendOrderNotification(
//         message: message,
//         token: deviceToken,
//         senderName: firebaseInstance.toString());
//   }else{
//
//     Fluttertoast.showToast(msg: 'erro');
//    }
//   }
}
