import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iPECS/ipecs-mobile/tenant-drawer.dart';
import 'package:iPECS/ipecs-mobile/tenant-profile.dart';
import 'package:iPECS/utils.dart';

class TenantRooms extends StatefulWidget {
  const TenantRooms({Key? key}) : super(key: key);

  @override
  _TenantRooms createState() => _TenantRooms();
}

class _TenantRooms extends State<TenantRooms> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.ref().child("Rooms");
  final auth = FirebaseAuth.instance;
  User? currentUser;
  List<Map<String, dynamic>> roomData = [];

  @override
  void initState() {
    super.initState();
    getRooms();
  }

  Future<void> getRooms() async {
    currentUser = auth.currentUser;
    if (currentUser != null) {
      print("USER ID: ${currentUser?.uid}");
      // Add a listener to the database reference to get room data
      _databaseReference.onValue.listen((event) {
        final data = event.snapshot.value;
        if (data is Map) {
          // Filter rooms based on the authenticated user's UID
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

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double sizeAxis = MediaQuery.of(context).size.width / baseWidth;
    double size = sizeAxis * 0.97;

    return Scaffold(
      endDrawer: const Drawer(
        child: TenantDrawer(), // Call your custom drawer widget here
      ),
      body: Stack(
        children: [
          Container(
            color: const Color(0xffffffff),
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 120,
                  width: 100,
                  margin:
                  EdgeInsets.fromLTRB(0 * sizeAxis, 20 * sizeAxis, 200 * sizeAxis, 0 * sizeAxis),
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
                          image: AssetImage(
                              'assets/ipecs-mobile/images/user1.png'),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin:
                  EdgeInsets.fromLTRB(10 * sizeAxis, 20 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis),
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
          Align(
            alignment: const AlignmentDirectional(-0.80, -0.50),
            child: SizedBox(
              width: 100,
              child: Text(
                'Rooms',
                style: SafeGoogleFont(
                  'Urbanist',
                  fontSize: 18 * size,
                  color: const Color(0xff5c5473),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0, .3),
            child: SingleChildScrollView(
              child: SizedBox(
                height: 450,
                width: 330,
                child: roomData.isNotEmpty
                    ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: roomData.length,
                      itemBuilder: (context, index) {
                        final room = roomData[index];
                        return Card(
                          elevation: 3,
                          child: ListTile(
                            title: Text(
                              'RoomID: ${room['name']}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            subtitle: Text(
                              'Current Room Credit: ₱${(room['currentcredit'] ?? 0).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff9ba7b1),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                    : const Text("No rooms found", style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}