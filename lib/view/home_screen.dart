import 'package:chat_app_realtime/controller/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../controller/user_view_model.dart';
import 'chat_page.dart';
import 'get_device_token.dart';

class HomePage extends StatefulWidget {
  final String uid;

  const HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotificationService notificationService = NotificationService();
  DeviceTokenService deviceTokenService = DeviceTokenService();
  String? name;
  String? email;
  String? profilePic;

  @override
  void initState() {
    super.initState();
    NotificationService notificationService = NotificationService();
    notificationService.requestNotificationPermission();
    DeviceTokenService().storeDeviceToken();
    notificationService.getServerKey();
    Provider.of<UserViewModel>(context, listen: false).getCurrentUser();

    Future.microtask(() {
      Provider.of<UserViewModel>(context, listen: false)
          .fetchUserData(widget.uid);
    });

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    // getUserData();
    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          if (message.data['_id'] != null) {
            // Navigator.of(context).push(
            //   MaterialPageRoute(builder: (context) => Stays()),
            // );
          }
        }
      },
    );

    // 2. This method only call when App in foreground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          notificationService.showNotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    Provider.of<UserViewModel>(context, listen: false).getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "ChatApp",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
            ),
          ),
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                        child: ListTile(
                      leading: Icon(Icons.group_add_outlined),
                      title: Text('New group'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )),
                    PopupMenuItem(
                        child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )),
                    PopupMenuItem(
                        child: ListTile(
                      leading: Icon(Icons.payment_outlined),
                      title: Text('Payments'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )),
                    PopupMenuItem(
                        child: ListTile(
                      leading: Icon(Icons.logout_outlined),
                      title: Text('Logout'),
                      onTap: () {
                        Provider.of<UserViewModel>(context, listen: false)
                            .logoutUser(context);
                        Navigator.pop(context);
                      },
                    )),
                  ])
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            Card(
              elevation: 7,
              color: Colors.blueAccent,
              child: SizedBox(
                height: 120,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        maxRadius: 25,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(profilePic.toString()),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              name ?? "unknown",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              email ?? "unknown",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ListTile(
                leading: Icon(
                  Icons.person_pin,
                  color: Colors.blueAccent,
                ),
                title: Text(
                  "Profile",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                ),
                trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blueAccent,
                    ))),
            SizedBox(
              height: 5,
            ),
            ListTile(
              onTap: () {},
              leading: Icon(
                Icons.wallet_rounded,
                color: Colors.blueAccent,
              ),
              title: Text(
                'Purse',
                style: TextStyle(color: Colors.blueAccent, fontSize: 18),
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ListTile(
              onTap: () {},
              leading: Icon(
                Icons.settings,
                color: Colors.blueAccent,
              ),
              title: Text(
                'Settings',
                style: TextStyle(color: Colors.blueAccent, fontSize: 18),
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ListTile(
              onTap: () {},
              leading: Icon(
                Icons.share,
                color: Colors.blueAccent,
              ),
              title: Text(
                'Share',
                style: TextStyle(color: Colors.blueAccent, fontSize: 18),
              ),
              trailing: IconButton(
                onPressed: () async {
                  var text = await deviceTokenService.generateDynamicLink();
                  Share.share(text.toString());
                },
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          if (userViewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (userViewModel.userData.isEmpty) {
            return Center(child: Text("No users found"));
          } else {
            return ListView.builder(
              itemCount: userViewModel.userData.length,
              itemBuilder: (context, index) {
                var user = userViewModel.userData[index];
                return InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            otherUid: user.id.toString(),
                            name: user.name.toString(),
                            email: user.email.toString(),
                            profilePic: user.profilePic.toString(),
                          ),
                        ));
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(user.profilePic.toString()),
                        ),
                      ),
                      title: Text(
                        "${user.name}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("${user.email}"),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> getCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    try {
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref("user/$currentUser");
      final datasnapShot = await databaseReference.get();
      if (datasnapShot.exists) {
        Map<String, dynamic> user =
            Map<String, dynamic>.from(datasnapShot.value as Map);
        setState(() {
          name = user['name'];
          email = user['email'];
          profilePic = user['profilePic'];
        });
      } else {
        print("No data found");
      }
    } catch (ex) {
      print("Error $ex");
    }
  }
}
