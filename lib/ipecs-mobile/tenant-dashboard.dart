import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iPECS/ipecs-mobile/tenant-drawer.dart';
import 'package:iPECS/ipecs-mobile/tenant-new-payment.dart';
import 'package:iPECS/ipecs-mobile/tenant-profile.dart';
import 'package:iPECS/utils.dart';

class TenantDashboard extends StatefulWidget {
  const TenantDashboard({Key? key}) : super(key: key);

  @override
  _TenantDashboardState createState() => _TenantDashboardState();
}

class _TenantDashboardState extends State<TenantDashboard> {
  final user = FirebaseAuth.instance.currentUser!;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference().child("Rooms").child("Room-1");
  String currentCredit = "Processing"; // Set an initial value while data is being fetched

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double sizeAxis = MediaQuery.of(context).size.width / baseWidth;
    double size = sizeAxis * 0.97;

    _databaseReference.child("CurrentCredit").onValue.listen((event) {
      print("Data from Firebase: ${event.snapshot.value}");
      setState(() {
        // Parse the value as a double and format it with 2 decimal places
        double credit = double.parse(event.snapshot.value.toString());
        currentCredit = credit.toStringAsFixed(2);
      });
    }, onError: (error) {
      print("Error fetching data: $error");
    });


    return Scaffold(
      endDrawer: const Drawer(
        child: TenantDrawer(), // Call your custom drawer widget here
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
                Container(
                  margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis),
                  child: Text(
                    'Current Credit',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'Urbanist',
                      fontSize: 14 * size,
                      fontWeight: FontWeight.w700,
                      height: 1.4285714286 * size / sizeAxis,
                      color: const Color(0xff23426f),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 13 * sizeAxis),
                  child: Text(
                    '₱ $currentCredit', // Use the fetched currentCredit value here
                    style: SafeGoogleFont(
                      'Inter',
                      fontSize: 48 * size,
                      fontWeight: FontWeight.w400,
                      height: 1.2 * size / sizeAxis,
                      color: const Color(0xff1f375b),
                      decoration: TextDecoration.none,
                    ),
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
                        'Recent Payment',
                        style: SafeGoogleFont(
                          'Urbanist',
                          fontSize: 18 * size,
                          fontWeight: FontWeight.w500,
                          height: 1.2 * size / sizeAxis,
                          color: const Color(0xff5c5473),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      // ListView for Recent Payments
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          // Add your ListTile widgets here
                          Card(
                            elevation: 3, // Add elevation for drop shadow
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage('assets/ipecs-mobile/images/user1.png'),
                              ),
                              title: Text(
                                '+ ₱300',
                                style: TextStyle( // Replace SafeGoogleFont with TextStyle
                                  fontFamily: 'Inter', // Specify the font family
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff1f375b),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              subtitle: Text(
                                'June 9, 2023',
                                style: TextStyle( // Replace SafeGoogleFont with TextStyle
                                  fontFamily: 'Urbanist', // Specify the font family
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff9ba7b1),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              trailing: Text(
                                'Paid',
                                style: TextStyle(
                                  fontFamily: 'Inter', // Specify the font family
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff47e83d),
                                  decoration: TextDecoration.none, // Remove underline here
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 15),
                          // Add more ListTiles as needed
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(32 * sizeAxis, 200 * sizeAxis, 38 * sizeAxis, 0 * sizeAxis),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const NewPayment(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 56 * sizeAxis,
                      decoration: BoxDecoration(
                        color: const Color(0xff231b53),
                        borderRadius: BorderRadius.circular(30 * sizeAxis),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x14000000),
                            offset: Offset(0 * sizeAxis, 20 * sizeAxis),
                            blurRadius: 30 * sizeAxis,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Center(
                          child: Text(
                            'New Payment',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Urbanist',
                              fontSize: 16 * size,
                              fontWeight: FontWeight.w600,
                              height: 1.5 * size / sizeAxis,
                              color: const Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
