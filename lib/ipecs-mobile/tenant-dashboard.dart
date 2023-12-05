import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iPECS/ipecs-mobile/tenant-drawer.dart';
import 'package:iPECS/ipecs-mobile/tenant-profile.dart';
import 'package:iPECS/utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseBackgroundMessageHandler(RemoteMessage message) async {await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");

  // Parse the message data
  String roomName = message.data['roomName'];
  double currentCredit = double.tryParse(message.data['currentCredit'] ?? '') ?? 0;

  // Show a local notification
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'channelDescription',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false);
  var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0,
      'iPECS: Daily Credit Alert',
      'Your Credit ₱${currentCredit.toStringAsFixed(2)} in $roomName is at critical, add new credit to avoid disconnection',
      platformChannelSpecifics,
      payload: 'item x');
}

class TenantDashboard extends StatefulWidget {
  const TenantDashboard({Key? key}) : super(key: key);

  @override
  _TenantDashboardState createState() => _TenantDashboardState();
}

class _TenantDashboardState extends State<TenantDashboard> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child("Rooms");
  final auth = FirebaseAuth.instance;
  User? currentUser;
  List<Map<String, dynamic>> roomData = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    getRooms();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessageHandler);

    // Start the timer
    _timer = Timer.periodic(Duration(minutes: 10), (Timer timer) {
      // Check if the credit is critical
      for (var room in roomData) {
        bool isCreditCritical = room['creditcriticallevel'] > (room['currentcredit'] ?? 0).toDouble();
        if (isCreditCritical) {
          showNotification(room['name'], (room['currentcredit'] ?? 0).toDouble()); // Convert to double here
        }
      }
    });
  }


  Future<void> getRooms() async {
    currentUser = auth.currentUser;
    if (currentUser != null) {
      print("USER ID: ${currentUser?.uid}");
      _databaseReference.onValue.listen((event) {
        final data = event.snapshot.value;
        if (data is Map) {
          roomData = data.entries.where((entry) {
            final room = entry.value;
            return room is Map &&
                room.containsKey('UserID') &&
                room['UserID'] == currentUser?.uid;
          }).map<Map<String, dynamic>>((entry) {
            final room = entry.value;
            return {
              'name': entry.key,
              'currentcredit': room['CurrentCredit'] ?? 0,
              'creditcriticallevel': room['CreditCriticalLevel'] ?? 0,
            };
          }).toList();
          setState(() {});
        } else {
          print("Data is not in the expected format");
        }
      });
    } else {
      print("No User");
    }
  }

  Future<void> showNotification(String roomName, double currentCredit) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channelId',
        'channelName',
        channelDescription: 'channelDescription',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'iPECS: Daily Credit Alert',
        'Your Credit ₱${currentCredit.toStringAsFixed(2)} in $roomName is at critical, add new credit to avoid disconnection',
        platformChannelSpecifics,
        payload: 'item x');
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double sizeAxis = MediaQuery.of(context).size.width / baseWidth;
    double size = sizeAxis * 0.97;

    return Scaffold(
      endDrawer: const Drawer(
        child: TenantDrawer(),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.fromLTRB(24 * sizeAxis, 30 * sizeAxis, 24 * sizeAxis, 0 * sizeAxis),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xffffffff),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(8 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 32 * sizeAxis),
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 200 * sizeAxis, 0 * sizeAxis),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const TenantProfile(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Container(
                            width: 48 * sizeAxis,
                            height: 48 * sizeAxis,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24 * sizeAxis),
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/ipecs-mobile/images/user1.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10 * sizeAxis, 20 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis),
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset(
                              'assets/ipecs-mobile/images/drawer.png',
                              width: 25 * sizeAxis,
                              height: 18 * sizeAxis,
                            ),
                            onPressed: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Current Credits ListView
                Container(
                  margin: EdgeInsets.fromLTRB(0 * sizeAxis, 20 * sizeAxis, 0 * sizeAxis, 13 * sizeAxis),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Credits',
                        style: SafeGoogleFont(
                          'Urbanist',
                          fontSize: 18 * size,
                          fontWeight: FontWeight.w500,
                          height: 1.2 * size / sizeAxis,
                          color: const Color(0xff5c5473),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      // Payment Data ListView
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: roomData.map((rooms) {
                          bool isCreditCritical = rooms['creditcriticallevel'] > rooms['currentcredit'];
                          if (isCreditCritical) {
                            showNotification(rooms['name'], (rooms['currentcredit'] ?? 0).toDouble()); // Convert to double here
                          }
                          return Card(
                            elevation: 3,
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundImage: AssetImage('assets/ipecs-mobile/images/userCartoon.png'),
                              ),
                              title: Text(
                                '${rooms['name']}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Critical Level: ${rooms['creditcriticallevel']}',
                                    style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    'Room Credit: ₱${(rooms['currentcredit'] ?? 0).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: isCreditCritical
                                  ? Icon(
                                Icons.warning,
                                color: Colors.orange, // Set icon color to orange
                              ) : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEditCreditCriticalLevelDialog();
        },
        child: Icon(Icons.settings),
        backgroundColor: Color(0xffdfb153),
      ),
    );
  }

  void _showEditCreditCriticalLevelDialog() {
    double baseWidth = 375;
    double sizeAxis = MediaQuery.of(context).size.width / baseWidth;
    double size = sizeAxis * 0.97;

    TextEditingController credAlertController = TextEditingController();
    bool isSaveButtonEnabled = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Edit The Desired Critical Level',
                style: SafeGoogleFont(
                  'Urbanist',
                  fontSize: 18 * size,
                  fontWeight: FontWeight.w500,
                  height: 1.2 * size / sizeAxis,
                  color: const Color(0xff5c5473),
                  decoration: TextDecoration.none,
                ),
              ),
              content: Container(
                padding: EdgeInsets.all(16.0 * size),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ensure the AlertDialog is vertically centered
                  children: [
                    TextField(
                      controller: credAlertController,
                      decoration: InputDecoration(labelText: 'New Credit Critical Level'),
                      style: GoogleFonts.urbanist(
                        fontSize: 15 * size,
                        fontWeight: FontWeight.w500,
                        height: 1.25 * size / sizeAxis,
                        color: const Color(0xff000000),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          isSaveButtonEnabled = double.tryParse(value) != null;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: SafeGoogleFont(
                      'Urbanist',
                      fontSize: 18 * size,
                      fontWeight: FontWeight.w500,
                      height: 1.2 * size / sizeAxis,
                      color: const Color(0xff5c5473),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: isSaveButtonEnabled
                      ? () {
                    _saveCreditCriticalLevel(credAlertController.text);
                    Navigator.pop(context);
                  }
                      : null,
                  child: Text(
                    'Save',
                    style: SafeGoogleFont(
                      'Urbanist',
                      fontSize: 18 * size,
                      fontWeight: FontWeight.w500,
                      height: 1.2 * size / sizeAxis,
                      color: const Color(0xff5c5473),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
  void _saveCreditCriticalLevel(String newCriticalLevel) {
    currentUser = auth.currentUser;
    if (currentUser != null) {
      _databaseReference.once().then((event) {
        DataSnapshot snapshot = event.snapshot;
        Map<dynamic, dynamic>? rooms = snapshot.value as Map<dynamic, dynamic>?;
        if (rooms != null) {
          bool roomExists = false;
          rooms.forEach((key, room) {
            if (room['UserID'] == currentUser!.uid) {
              roomExists = true;
              _databaseReference.child(key).update({'CreditCriticalLevel': int.parse(newCriticalLevel)});
            }
          });
          if (!roomExists) {
            _databaseReference.push().set({
              'CreditCriticalLevel': int.parse(newCriticalLevel),
              'UserID': currentUser!.uid,
              // Add other properties as needed
            });
          }
        }
      }).catchError((error) {
        print("Error: $error");
      });
    }
  }
}