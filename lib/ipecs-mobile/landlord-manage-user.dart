import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iPECS/ipecs-mobile/landlord-add-user.dart';
import 'package:iPECS/ipecs-mobile/landlord-drawer.dart';
import 'package:iPECS/ipecs-mobile/landlord-profile.dart';
import 'package:iPECS/utils.dart';

class ManageUser extends StatefulWidget {
  const ManageUser({Key? key}) : super(key: key);

  @override
  _ManageUserState createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  final user = FirebaseAuth.instance.currentUser!;
  late DatabaseReference _usersRef;
  List<Map<String, dynamic>> userData = [];

  late DatabaseReference _roomsRef;
  List<String> roomNumbers = [];
  String selectedRoomNumber = "";

  @override
  void initState() {
    super.initState();
    _usersRef = FirebaseDatabase.instance.reference().child("Users");
    getUsers();
    _listenForUserChanges(); // Add this line to start listening for changes
    _roomsRef = FirebaseDatabase.instance.reference().child("Rooms");
    fetchAvailableRooms();
  }

  Future<void> getUsers() async {
    DataSnapshot snapshot = await _usersRef.get();
    if (snapshot.value is Map) {
      Map<dynamic, dynamic> userValues = Map<dynamic, dynamic>.from(snapshot.value! as Map);
      List<Map<String, dynamic>> updatedUserData = [];

      userValues.forEach((key, value) {
        updatedUserData.add({
          'id': key,
          'username': value['username'],
          'email': value['email'],
          'contactNum': value['contactNum'],
          'userStatus': value['userStatus'],
          'userRole': value['userRole'],
        });
      });

      setState(() {
        userData.clear(); // Clear the existing data before updating
        userData = List.from(updatedUserData); // Update userData with the new data directly
      });
    }
  }


  Future<void> _toggleUserStatus(String userId, bool newStatus) async {
    try {
      DatabaseReference userRef = _usersRef.child(userId);
      await userRef.update({'userStatus': newStatus});
      // Refresh the user data after updating the status
      await getUsers();
    } catch (error) {
      print('Error toggling user status: $error');
    }
  }

  void _listenForUserChanges() {
    _usersRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> userValues = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
        List<Map<String, dynamic>> updatedUserData = [];

        userValues.forEach((key, value) {
          updatedUserData.add({
            'id': key,
            'username': value['username'],
            'email': value['email'],
            'contactNum': value['contactNum'],
            'userStatus': value['userStatus'],
            'userRole': value['userRole'],
          });
        });

        setState(() {
          userData = List.from(updatedUserData); // Update userData with the new data directly
        });
      }
    });
  }

  void fetchAvailableRooms() {
    final DatabaseReference _roomsReference =
    FirebaseDatabase.instance.reference().child("Rooms");

    _roomsReference.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map) {
        final availableRooms =
        data.keys.toList().cast<String>(); // Convert to List<String>

        // Sort room numbers before updating state
        availableRooms.sort((a, b) => a.compareTo(b));

        setState(() {
          // Add "None" as an option at the beginning of the roomNumbers list
          roomNumbers = ['None', ...availableRooms];

          if (!roomNumbers.contains(selectedRoomNumber) &&
              availableRooms.isNotEmpty) {
            // Update the selected room number only if it is not in the updated room list
            selectedRoomNumber = availableRooms[0];
          }
        });
      }
    }, onError: (error) {
      print("Error fetching available room numbers: $error");
    });
  }

  Future<void> _updateRoomUserID(String roomId, String userId) async {
    try {
      await _roomsRef.child(roomId).update({'UserID': userId});
      print('UserID updated successfully for Room: $roomId');
    } catch (error) {
      print('Error updating UserID for Room: $roomId - $error');
    }
  }

  Future<void> _editUserData(String userId) async {
    double baseWidth = 375;
    double sizeAxis = MediaQuery.of(context).size.width / baseWidth;
    double size = sizeAxis * 0.97;

    TextEditingController usernameController = TextEditingController();
    TextEditingController contactNumController = TextEditingController();

    // Fetch the user's current data to display in the dialog
    Map<String, dynamic> currentUserData =
    userData.firstWhere((user) => user['id'] == userId);

    usernameController.text = currentUserData['username'];
    contactNumController.text = currentUserData['contactNum'];

    Map<String, dynamic>? updatedData = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit User Data',
            style: SafeGoogleFont(
              'Urbanist',
              fontSize: 18 * size,
              fontWeight: FontWeight.w500,
              height: 1.2 * size / sizeAxis,
              color: const Color(0xff5c5473),
              decoration: TextDecoration.none,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                  style: GoogleFonts.urbanist(
                    fontSize: 15 * size,
                    fontWeight: FontWeight.w500,
                    height: 1.25 * size / sizeAxis,
                    color: const Color(0xff5c5473),
                  ),
                ),
                SizedBox(height: 20 * sizeAxis),
                TextFormField(
                  controller: contactNumController,
                  decoration: InputDecoration(labelText: 'Contact Number'),
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.urbanist(
                    fontSize: 15 * size,
                    fontWeight: FontWeight.w500,
                    height: 1.25 * size / sizeAxis,
                    color: const Color(0xff5c5473),
                  ),
                ),
                SizedBox(height: 20 * sizeAxis),
                DropdownButtonFormField<String>(
                  value: selectedRoomNumber.isNotEmpty &&
                      roomNumbers.contains(selectedRoomNumber)
                      ? selectedRoomNumber
                      : roomNumbers.isNotEmpty
                      ? roomNumbers[0]
                      : '',
                  items: roomNumbers.map((String room) {
                    return DropdownMenuItem<String>(
                      value: room,
                      child: Text(room),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRoomNumber = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(
                        18 * sizeAxis, 17 * sizeAxis, 16 * sizeAxis, 17 * sizeAxis),
                    hintText: 'Room Number',
                    hintStyle: const TextStyle(color: Color(0xff8390a1)),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null); // Close the dialog without saving changes
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Update the username and contactNum locally
                currentUserData['username'] = usernameController.text;
                currentUserData['contactNum'] = contactNumController.text;

                // Update the contactNum in Firebase
                try {
                  DatabaseReference userRef = _usersRef.child(userId);
                  await userRef.update({
                    'username': usernameController.text,
                    'contactNum': contactNumController.text,
                  });

                  // Check if a room is selected
                  if (selectedRoomNumber != 'None') {
                    await _updateRoomUserID(selectedRoomNumber, userId);
                  }

                  // Refresh the user data after updating the fields
                  await getUsers();
                } catch (error) {
                  print('Error updating data: $error');
                }

                Navigator.of(context).pop(currentUserData); // Close the dialog and pass the updated values
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    // Dispose controllers to free up resources
    usernameController.dispose();
    contactNumController.dispose();
    // Dispose other controllers as needed
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
                      // Inside the ListView.builder
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: userData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 3,
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundImage: AssetImage('assets/ipecs-mobile/images/userCartoon.png'),
                              ),
                              title: Text(
                                '${userData[index]['username']}',
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
                                    '${userData[index]['email']}',
                                    style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff9ba7b1),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    '${userData[index]['contactNum']}',
                                    style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff9ba7b1),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    '${userData[index]['userRole']}',
                                    style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff9ba7b1),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    '${userData[index]['userStatus']}',
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
                                  // Conditionally show check or close icon based on userStatus
                                  userData[index]['userStatus'] == true
                                      ? IconButton(
                                    icon: Icon(Icons.circle, color: Colors.green),
                                    onPressed: () {
                                      // Function to disable user
                                      _toggleUserStatus(userData[index]['id'], false);
                                    },
                                  )
                                      : IconButton(
                                    icon: Icon(Icons.circle, color: Colors.red),
                                    onPressed: () {
                                      // Function to enable user
                                      _toggleUserStatus(userData[index]['id'], true);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.red),
                                    onPressed: () {
                                      _editUserData(userData[index]['id']);
                                    },
                                  ),
                                ],
                              ),
                            ),
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