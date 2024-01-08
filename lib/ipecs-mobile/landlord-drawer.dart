import 'package:flutter/material.dart';
import 'package:iPECS/ipecs-mobile/landlord-dashboard.dart';
import 'package:iPECS/ipecs-mobile/landlord-login.dart';
import 'package:iPECS/ipecs-mobile/landlord-manage-user.dart';
import 'package:iPECS/ipecs-mobile/landlord-monthly.dart';
import 'package:iPECS/ipecs-mobile/landlord-payment-management.dart';
import 'package:iPECS/ipecs-mobile/landlord-profile.dart';
import 'package:iPECS/ipecs-mobile/landlord-records.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iPECS/ipecs-mobile/landlord-roomhistory.dart';

class LandlordDrawer extends StatefulWidget {
  const LandlordDrawer({Key? key}) : super(key: key);

  @override
  _LandlordDrawerState createState() => _LandlordDrawerState();
}

class _LandlordDrawerState extends State<LandlordDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference().child('Users');

  Future<Map<String, dynamic>> getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DatabaseEvent event = await _dbRef.child(user.uid).once();
      if (event.snapshot.value != null) {
        if (event.snapshot.value is Map) {
          return Map<String, dynamic>.from(event.snapshot.value as Map);
        }
      }
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffdfb153), Color(0xffdfb153), Color(0xff8E92CD), Color(0xff231b53)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            FutureBuilder(
              future: getUserData(),
              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();  // Show loading indicator while waiting for data
                } else {
                  return UserAccountsDrawerHeader(
                    accountName: Text(
                      snapshot.data?['username'] ?? 'Username',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff012970),
                      ),
                    ),
                    accountEmail: Text(
                      snapshot.data?['email'] ?? 'Email',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xff012970),
                      ),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage('assets/ipecs-mobile/images/user2.png'),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xffE6DAC5), Color(0xffdfb153)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.dashboard,
                color: Colors.white, // Set the icon color to white
              ),
              title: const Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LandlordDashboard(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.receipt, // Change to Records icon
                color: Colors.white, // Set the icon color to white
              ),
              title: const Text(
                'Records', // Change to Records
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LandlordRecords(),
                  ),
                );              },
            ),
            ListTile(
              leading: const Icon(
                Icons.calendar_month, // Change to Records icon
                color: Colors.white, // Set the icon color to white
              ),
              title: const Text(
                'Monthly Consumption', // Change to Records
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LandlordMonthlyRecords(),
                  ),
                );              },
            ),
            ListTile(
              leading: const Icon(
                Icons.family_restroom,
                color: Colors.white, // Set the icon color to white
              ),
              title: const Text(
                'Rooms History', // Change to Payment Management
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LandlordRoomHistory(),
                  ),
                );},
            ),
            ListTile(
              leading: const Icon(
                Icons.people, // Change to Manage Users icon
                color: Colors.white, // Set the icon color to white
              ),
              title: const Text(
                'Manage Users', // Change to Manage Users
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ManageUser(),
                  ),
                );              },
            ),
            ListTile(
              leading: const Icon(
                Icons.payment,
                color: Colors.white, // Set the icon color to white
              ),
              title: const Text(
                'Payment Management', // Change to Payment Management
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PaymentManage(),
                  ),
                );},
            ),
            // ListTile(
            //   leading: const Icon(
            //     Icons.person,
            //     color: Colors.white, // Set the icon color to white
            //   ),
            //   title: const Text(
            //     'Profile',
            //     style: TextStyle(
            //       color: Colors.white,
            //     ),
            //   ),
            //   onTap: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => const PaymentManage(),
            //       ),
            //     );
            //   },
            // ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white, // Set the icon color to white
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () async {
                try {
                  showDialog(
                    context: context,
                    barrierDismissible: false, // Set to false to prevent dialog dismissal on tap outside
                    builder: (context) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Color(0xffdfb153),
                        ),
                      );
                    },
                  );
                  await FirebaseAuth.instance.signOut();
                  await Future.delayed(Duration(seconds: 1));
                  Navigator.of(context).pushReplacement(  // Use pushReplacement to prevent going back to the previous screen
                    MaterialPageRoute(
                      builder: (context) => const LandlordLogin(),
                    ),
                  );
                } catch (e) {
                  print('Error logging out: $e');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
