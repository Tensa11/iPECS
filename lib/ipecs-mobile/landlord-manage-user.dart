import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iPECS/ipecs-mobile/landlord-add-user.dart';
import 'package:iPECS/ipecs-mobile/landlord-drawer.dart';
import 'package:iPECS/ipecs-mobile/landlord-profile.dart';
import 'dart:ui';
import 'package:iPECS/utils.dart';

class ManageUser extends StatefulWidget {
  const ManageUser({Key? key}) : super(key: key);

  @override
  _ManageUserState createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  final user = FirebaseAuth.instance.currentUser!;
  List<Map<String, dynamic>> userData = [];

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  Future<void> getUsers() async {
    final DatabaseReference _usersRef = FirebaseDatabase.instance.reference().child("Users");
    DataSnapshot snapshot = await _usersRef.get();
    if (snapshot.value is Map) {
      Map<dynamic, dynamic> userValues = Map<dynamic, dynamic>.from(snapshot.value! as Map);
      userValues.forEach((key, value) {
        userData.add({
          'id': key,
          'roomNum': value['RoomNum'],
          'username': value['username'],
          'email': value['email'],
          'contactNum': value['contactNum'],
          'userStatus': value['userStatus'],
        });
      });
      userData.sort((a, b) => a['roomNum'].compareTo(b['roomNum']));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double sizeAxis = MediaQuery.of(context).size.width / baseWidth;
    double size = sizeAxis * 0.97;

    return Scaffold(
      endDrawer: const Drawer(
        child: LandlordDrawer(),
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
                                builder: (context) => const LandlordProfile(),
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
                                image: AssetImage('assets/ipecs-mobile/images/user2.png'),
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
                // Recent Payments ListView
                Container(
                  margin: EdgeInsets.fromLTRB(0 * sizeAxis, 20 * sizeAxis, 0 * sizeAxis, 13 * sizeAxis),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Management',
                        style: SafeGoogleFont(
                          'Urbanist',
                          fontSize: 18 * size,
                          fontWeight: FontWeight.w500,
                          height: 1.2 * size / sizeAxis,
                          color: const Color(0xff5c5473),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      // ListView for Users
                      StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          print('Building ListView. User Data Count: ${userData.length}');
                          return ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: userData.map((user) {

                              return Card(
                                elevation: 3,
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundImage: AssetImage('assets/ipecs-mobile/images/userCartoon.png'),
                                  ),
                                  title: Text(
                                    '${user['username']}',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xff1f375b),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5),
                                      Text(
                                        '${user['roomNum']}',
                                        style: TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff9ba7b1),
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Text(
                                        '${user['email']}',
                                        style: TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff9ba7b1),
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      Text(
                                        '${user['contactNum']}',
                                        style: TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff9ba7b1),
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // userStatus icon
                                      IconButton(
                                        icon: Icon(Icons.check, color: Colors.green),
                                        onPressed: null,
                                      ),
                                      SizedBox(width: 10),
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.red),
                                        onPressed: null,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddUser(),
            ),
          );
        },
        backgroundColor: const Color(0xff1f375b),
        child: const Icon(
          Icons.person,
          color: Color(0xffdfb153),
        ),
      ),
    );
  }
}
