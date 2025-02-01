// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:spot/Firbase/auth_service.dart';
// import 'package:spot/vendor/authentication/login.dart';

// import 'package:spot/vendor/screens/vendorCharitypage.dart';
// import 'package:spot/vendor/screens/vendorProfilepage.dart';
// import 'package:spot/vendor/screens/vendorfeedback.dart';

// class vebdorBottomNavbar extends StatefulWidget {
//   const vebdorBottomNavbar({super.key});

//   @override
//   State<vebdorBottomNavbar> createState() => _vebdorBottomNavbarState();
// }

// class _vebdorBottomNavbarState extends State<vebdorBottomNavbar> {
//   int indexnum = 0;
//   List tabWidgets = [
//     // ShopRegistrationPage(),
//     VendorCharityPage(),
//     VendorProfilePage(),
//     FeedbackPage(vendorEmail: widget.vendorEmail),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final _auth = AuthService();
//     return Scaffold(
//       bottomNavigationBar: BottomNavigationBar(
//           items: const [
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.volunteer_activism),
//                 label: 'Charity',
//                 backgroundColor: Colors.blue),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.person),
//                 label: "Profile",
//                 backgroundColor: Colors.blue),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.feed),
//               label: 'FeedBack',
//               backgroundColor: Colors.blue,
//             )
//           ],
//           currentIndex: indexnum,
//           showUnselectedLabels: true,
//           onTap: (int index) {
//             setState(() {
//               indexnum = index;
//             });
//           }),
//       body: tabWidgets.elementAt(indexnum),
//     );
//   }

//   gotologin(BuildContext context) => Navigator.pushReplacement(
//       context, MaterialPageRoute(builder: (context) => const LoginPage()));
// }

// class FeedbackList extends StatelessWidget {
//   final String vendorId;

//   const FeedbackList({
//     Key? key,
//     required this.vendorId,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('vendors')
//           .doc(vendorId)
//           .collection('feedback')
//           .orderBy('timestamp', descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final feedbacks = snapshot.data?.docs ?? [];

//         if (feedbacks.isEmpty) {
//           return const Center(child: Text('No feedback available yet'));
//         }

//         return ListView.builder(
//           itemCount: feedbacks.length,
//           itemBuilder: (context, index) {
//             final feedback = feedbacks[index].data() as Map<String, dynamic>;
//             return ListTile(
//               title: Text(feedback['userEmail'] ?? 'Anonymous'),
//               subtitle: Text(feedback['comment'] ?? ''),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.star, color: Colors.amber),
//                   Text(feedback['rating'].toString()),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spot/Firbase/auth_service.dart';
import 'package:spot/vendor/authentication/login.dart';
import 'package:spot/vendor/screens/vendorCharitypage.dart';
import 'package:spot/vendor/screens/vendorProfilepage.dart';
import 'package:spot/vendor/screens/vendorcharityRead.dart';
import 'package:spot/vendor/screens/vendorfeedback.dart';

class VendorBottomNavbar extends StatefulWidget {
  const VendorBottomNavbar({super.key});

  @override
  State<VendorBottomNavbar> createState() => _VendorBottomNavbarState();
}

class _VendorBottomNavbarState extends State<VendorBottomNavbar> {
  int indexnum = 0;

  @override
  Widget build(BuildContext context) {
    final _auth = AuthService();

    // Assuming vendorEmail is fetched from the AuthService
    final String vendorEmail =
        _auth.getCurrentUserEmail(); // Implement this method in AuthService

    List tabWidgets = [
      CharityRead(),
      VendorProfilePage(),
      FeedbackPage(vendorEmail: vendorEmail),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            label: 'Charity',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Feedback',
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: indexnum,
        showUnselectedLabels: true,
        onTap: (int index) {
          setState(() {
            indexnum = index;
          });
        },
      ),
      body: tabWidgets.elementAt(indexnum),
    );
  }

  void gotologin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
