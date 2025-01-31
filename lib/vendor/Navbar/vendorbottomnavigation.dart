import 'package:flutter/material.dart';
import 'package:spot/Firbase/auth_service.dart';
import 'package:spot/vendor/authentication/login.dart';
import 'package:spot/vendor/screens/vendorAddStore.dart';
import 'package:spot/vendor/screens/vendorCharitypage.dart';
import 'package:spot/vendor/screens/vendorProfilepage.dart';
import 'package:spot/vendor/screens/vendorhomepage.dart';

class vebdorBottomNavbar extends StatefulWidget {
  const vebdorBottomNavbar({super.key});

  @override
  State<vebdorBottomNavbar> createState() => _vebdorBottomNavbarState();
}

class _vebdorBottomNavbarState extends State<vebdorBottomNavbar> {
  int indexnum = 0;
  List tabWidgets = [
    // ShopRegistrationPage(),
    VendorCharityPage(),
    VendorProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            
            BottomNavigationBarItem(
                icon: Icon(Icons.volunteer_activism),
                label: 'Charity',
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
                backgroundColor: Colors.blue)
          ],
          currentIndex: indexnum,
          showUnselectedLabels: true,
          onTap: (int index) {
            setState(() {
              indexnum = index;
            });
          }),
      body: tabWidgets.elementAt(indexnum),
    );
  }

  gotologin(BuildContext context) => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const LoginPage()));
}
