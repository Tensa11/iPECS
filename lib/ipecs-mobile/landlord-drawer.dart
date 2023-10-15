import 'package:flutter/material.dart';
import 'package:iPECS/ipecs-mobile/landlord-dashboard.dart';
import 'package:iPECS/ipecs-mobile/landlord-login.dart';
import 'package:iPECS/ipecs-mobile/landlord-manage-user.dart';
import 'package:iPECS/ipecs-mobile/landlord-payment-management.dart';
import 'package:iPECS/ipecs-mobile/landlord-profile.dart';
import 'package:iPECS/ipecs-mobile/landlord-records.dart';
import 'package:iPECS/ipecs-mobile/tenant-dashboard.dart';
import 'package:iPECS/ipecs-mobile/tenant-login.dart';
import 'package:iPECS/ipecs-mobile/tenant-new-payment.dart';
import 'package:iPECS/ipecs-mobile/tenant-profile.dart';

class LandlordDrawer extends StatefulWidget {
  const LandlordDrawer({Key? key}) : super(key: key);

  @override
  _LandlordDrawerState createState() => _LandlordDrawerState();
}

class _LandlordDrawerState extends State<LandlordDrawer> {
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
            const UserAccountsDrawerHeader(
              accountName: Text(
                'Clover Glove',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff012970),
                ),
              ),
              accountEmail: Text(
                'john.doe@example.com',
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
                );              },
            ),
            ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.white, // Set the icon color to white
              ),
              title: const Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LandlordProfile(),
                  ),
                );
              },
            ),
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
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LandlordLogin(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
