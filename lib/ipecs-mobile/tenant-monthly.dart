import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iPECS/ipecs-mobile/landlord-drawer.dart';
import 'package:iPECS/ipecs-mobile/landlord-profile.dart';
import 'package:iPECS/ipecs-mobile/tenant-drawer.dart';
import 'package:iPECS/utils.dart';
import 'package:intl/intl.dart';

class TenantMonthlyRecords extends StatefulWidget {
  const TenantMonthlyRecords({Key? key}) : super(key: key);

  @override
  _TenantMonthlyRecordsState createState() => _TenantMonthlyRecordsState();
}

class _TenantMonthlyRecordsState extends State<TenantMonthlyRecords> {
  final auth = FirebaseAuth.instance;
  User? currentUser;
  List<Map<String, dynamic>> roomData = [];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    getMonthlyReport();
  }

  @override
  void dispose() {
    // Dispose of the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  Future<void> getMonthlyReport() async {
    DatabaseReference roomsRef = FirebaseDatabase.instance.reference().child('Rooms');
    DatabaseReference usersRef = FirebaseDatabase.instance.reference().child('Users');
    DatabaseReference paymentRecordsRef = FirebaseDatabase.instance.reference().child('PaymentRecord');

    try {
      // Get the current user
      currentUser = auth.currentUser;

      if (currentUser == null) {
        // Handle the case when the user is not logged in
        return;
      }

      DatabaseEvent roomsEvent = await roomsRef.once();
      DatabaseEvent usersEvent = await usersRef.once();
      DatabaseEvent paymentRecordsEvent = await paymentRecordsRef.once();

      DataSnapshot roomsSnapshot = roomsEvent.snapshot;
      DataSnapshot usersSnapshot = usersEvent.snapshot;
      DataSnapshot paymentRecordsSnapshot = paymentRecordsEvent.snapshot;

      if (roomsSnapshot.value != null) {
        Map<dynamic, dynamic> rooms = roomsSnapshot.value as Map<dynamic, dynamic>;
        Map<dynamic, dynamic> users = usersSnapshot.value as Map<dynamic, dynamic>;
        Map<dynamic, dynamic> paymentRecords = paymentRecordsSnapshot.value as Map<dynamic, dynamic>;

        // Prepare a map to hold monthly payments per room
        Map<String, Map<String, double>> monthlyPaymentsPerRoom = {};

        // Process payment records to calculate monthly payments per room
        paymentRecords.forEach((id, record) {
          String roomNum = record['RoomNum'];
          String timestamp = record['Timestamp'];
          double paymentAmount = (record['PaymentAmount'] is int)
              ? (record['PaymentAmount'] as int).toDouble()
              : record['PaymentAmount'] as double;
          DateFormat format = DateFormat('MM-dd-yyyy HH:mm:ss');
          DateTime dateTime = format.parse(timestamp, true).toLocal();
          String monthYear = DateFormat('MM-yyyy').format(dateTime);

          if (!monthlyPaymentsPerRoom.containsKey(roomNum)) {
            monthlyPaymentsPerRoom[roomNum] = {};
          }

          monthlyPaymentsPerRoom[roomNum]!.update(
            monthYear,
                (currentTotal) => currentTotal + paymentAmount,
            ifAbsent: () => paymentAmount,
          );
        });

        // Process room data and include monthly payments
        rooms.forEach((key, value) {
          String roomName = key.toString();
          String userID = value['UserID'];
          String tenantName = users[userID]['username'];

          // Check if the room belongs to the current tenant
          if (userID == currentUser!.uid) {
            Map<dynamic, dynamic> powerConsumptions = value['PowerConsumption'] ?? {};
            // Group the power consumption by month
            Map<String, double> monthlyConsumption = {};

            powerConsumptions.forEach((timestamp, consumption) {
              DateFormat format = DateFormat('MM-dd-yyyy HH:mm:ss');
              DateTime? dateTime = format.parse(timestamp.toString(), true).toLocal();
              if (dateTime == null) {
                print("Failed to parse timestamp: $timestamp");
                return;
              }
              String monthYear = DateFormat('MM-yyyy').format(dateTime);

              monthlyConsumption.update(
                monthYear,
                    (currentTotal) => currentTotal + (consumption as double),
                ifAbsent: () => consumption as double,
              );
            });

            // Add each month's total consumption to roomData
            monthlyConsumption.forEach((monthYear, totalConsumption) {
              DateTime monthYearDateTime = DateFormat('MM-yyyy').parse(monthYear);
              String formattedMonthYear = DateFormat.yMMMM().format(monthYearDateTime);
              double totalPayment = monthlyPaymentsPerRoom[roomName]?[monthYear] ?? 0.0;

              roomData.add({
                'name': roomName,
                'Month': formattedMonthYear,
                'totalMonthConsumption': totalConsumption,
                'tenantName': tenantName,
                'totalMonthPayment': totalPayment,
              });
            });
          }
        });

        // Get the current month and year
        DateTime now = DateTime.now();
        String currentMonthYear = DateFormat('MM-yyyy').format(now);

        // Sort the roomData list by month and year, and then by room name
        roomData.sort((a, b) {
          DateTime dateA = DateFormat('MMMM yyyy').parse(a['Month']);
          DateTime dateB = DateFormat('MMMM yyyy').parse(b['Month']);
          int comp = dateA.compareTo(dateB);

          // If both dates are not equal to the current month, sort by date
          if (comp != 0 && DateFormat('MM-yyyy').format(dateA) != currentMonthYear && DateFormat('MM-yyyy').format(dateB) != currentMonthYear) {
            return comp;
          }
          // If only one date is equal to the current month, that date comes first
          else if (DateFormat('MM-yyyy').format(dateA) == currentMonthYear && DateFormat('MM-yyyy').format(dateB) != currentMonthYear) {
            return -1;
          } else if (DateFormat('MM-yyyy').format(dateA) != currentMonthYear && DateFormat('MM-yyyy').format(dateB) == currentMonthYear) {
            return 1;
          }
          // If both dates are equal to the current month, sort by room name
          else {
            return a['name'].compareTo(b['name']);
          }
        });

        setState(() {
          // This will trigger the UI to update with the new roomData
        });
      }
    } catch (error) {
      print('Error: $error');
    }
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
                                image: AssetImage('assets/ipecs-mobile/images/userCartoon.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0 * sizeAxis, 20 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis),
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
                  margin: EdgeInsets.fromLTRB(0 * sizeAxis, 20 * sizeAxis, 0 * sizeAxis, 13 * sizeAxis),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Report',
                        style: SafeGoogleFont(
                          'Urbanist',
                          fontSize: 18 * size,
                          fontWeight: FontWeight.w500,
                          height: 1.2 * size / sizeAxis,
                          color: const Color(0xff5c5473),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: roomData.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> room = roomData[index];
                          return Card(
                            elevation: 3,
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundImage: AssetImage('assets/ipecs-mobile/images/userCartoon.png'),
                              ),
                              title: Text(
                                '${room['name']} '
                                // '- ${room['tenantName']}'
                                ,
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
                                  SizedBox(height: 5),
                                  Text(
                                    'Month: ${room['Month']}',
                                    style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    'Total Month Payment: ₱ ${room['totalMonthPayment'].toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    'Monthly ⚡: ${room['totalMonthConsumption'].toStringAsFixed(7)} KWh',
                                    style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none,
                                      color: Color(0xffdfb153),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    ],
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

