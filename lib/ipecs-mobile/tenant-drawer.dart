import 'package:flutter/material.dart';
import 'package:iPECS/ipecs-mobile/tenant-dashboard.dart';
import 'package:iPECS/ipecs-mobile/tenant-login.dart';
import 'package:iPECS/ipecs-mobile/tenant-new-payment.dart';
import 'package:iPECS/ipecs-mobile/tenant-payments-history.dart';
import 'package:iPECS/ipecs-mobile/tenant-profile.dart';
import 'package:iPECS/ipecs-mobile/tenant-rooms.dart';

class TenantDrawer extends StatefulWidget {
  const TenantDrawer({Key? key}) : super(key: key);

  @override
  _TenantDrawerState createState() => _TenantDrawerState();
}

class _TenantDrawerState extends State<TenantDrawer> {
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
                'Ana Croft',
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
                backgroundImage: AssetImage('assets/ipecs-mobile/images/user1.png'),
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
                    builder: (context) => const TenantDashboard(),
                  ),
                );              },
            ),
            ListTile(
              leading: const Icon(
                Icons.house,
                color: Colors.white, // Set the icon color to white
              ),
              title: const Text(
                'Rooms',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TenantRooms(),
                  ),
                );              },
            ),
            ListTile(
              leading: const Icon(
                Icons.payment,
                color: Colors.white, // Set the icon color to white
              ),
              title: const Text(
                'Payment',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NewPayment(),
                  ),
                );              },
            ),
            ListTile(
              leading: const Icon(
                Icons.payment,
                color: Colors.white, // Set the icon color to white
              ),
              title: const Text(
                'History',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PaymentHistory(),
                  ),
                );              },
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
                    builder: (context) => const TenantLogin(),
                  ),
                );              },
            ),

          ],
        ),
      ),
    );
  }
}
