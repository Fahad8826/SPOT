// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:spot/vendor/Navbar/vendorbottomnavigation.dart';

// class VendorHomePage extends StatefulWidget {
//   const VendorHomePage({super.key});

//   @override
//   State<VendorHomePage> createState() => _VendorHomePageState();
// }

// class _VendorHomePageState extends State<VendorHomePage> {
//   late Stream<QuerySnapshot> _shopsStream;

//   @override
//   void initState() {
//     super.initState();
//     _shopsStream = FirebaseFirestore.instance
//         .collection('Store_reg')
//         .snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Registered Shops'),
//         centerTitle: true,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _shopsStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No shops registered.'));
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               final shopData = snapshot.data!.docs[index].data()
//                   as Map<String, dynamic>;

//               return Card(
//                 margin: const EdgeInsets.symmetric(
//                   vertical: 8,
//                   horizontal: 16
//                 ),
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     backgroundImage: shopData['image'] != null
//                         ? NetworkImage(shopData['image'])
//                         : null,
//                     child: shopData['image'] == null
//                         ? const Icon(Icons.store)
//                         : null,
//                   ),
//                   title: Text(
//                     shopData['name'] ?? 'Unnamed Shop',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Category: ${shopData['category']}'),
//                       Text('Location: ${shopData['location']}'),
//                     ],
//                   ),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.info_outline),
//                     onPressed: () => _showShopDetailsDialog(shopData),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   void _showShopDetailsDialog(Map<String, dynamic> shopData) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(shopData['name'] ?? 'Shop Details'),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (shopData['image'] != null)
//                 Center(
//                   child: Image.network(
//                     shopData['image'],
//                     height: 150,
//                     width: 150,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               const SizedBox(height: 10),
//               _buildDetailRow('Email', shopData['email']),
//               _buildDetailRow('Phone', shopData['number']),
//               _buildDetailRow('Category', shopData['category']),
//               _buildDetailRow('Description', shopData['Description']),
//               _buildDetailRow('Location', shopData['location']),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: RichText(
//         text: TextSpan(
//           style: const TextStyle(color: Colors.black),
//           children: [
//             TextSpan(
//               text: '$label: ',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             TextSpan(text: value),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class VendorHomePage extends StatefulWidget {
//   const VendorHomePage({super.key});

//   @override
//   State<VendorHomePage> createState() => _VendorHomePageState();
// }

// class _VendorHomePageState extends State<VendorHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     final CollectionReference docSnapshot =
//         FirebaseFirestore.instance.collection('vendor_reg');
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Home'),
//       ),
//       body: StreamBuilder(
//           stream: docSnapshot.snapshots(),
//           builder: (context, AsyncSnapshot snapshot){
//             if (snapshot.hasData) {
//               return ListView.builder(
//                 itemCount: snapshot.data!.docs.length,
//                 itemBuilder: (context, index) {
//                   final DocumentSnapshot vendorsnap =
//                       snapshot.data!.docs[index];
//                   return Text(vendorsnap.phone);
//                 },
//               );
//             }
//           }),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:spot/Firbase/auth_service.dart';
// import 'package:http/http.dart' as http;
// import 'package:spot/vendor/authentication/login.dart';

// class VendorHomePage extends StatefulWidget {
//   const VendorHomePage({super.key});

//   @override
//   State<VendorHomePage> createState() => _VendorHomePageState();
// }

// class _VendorHomePageState extends State<VendorHomePage> {
//   final _auth = AuthService();
//   final _firebaseAuth = FirebaseAuth.instance;

//   late TextEditingController _nameController;
//   late TextEditingController _numberController;
//   late TextEditingController _emailController;
//   late TextEditingController _categoryController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _locationController;

//   File? _image;
//   String? _imageUrl;

//   bool _isEditing = false;
//   bool _isSaving = false;
//   String _errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//   }

//   void _initializeControllers() {
//     _nameController = TextEditingController();
//     _numberController = TextEditingController();
//     _emailController = TextEditingController();
//     _categoryController = TextEditingController();
//     _descriptionController = TextEditingController();
//     _locationController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _disposeControllers();
//     super.dispose();
//   }

//   void _disposeControllers() {
//     _nameController.dispose();
//     _numberController.dispose();
//     _emailController.dispose();
//     _categoryController.dispose();
//     _descriptionController.dispose();
//     _locationController.dispose();
//   }

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   Future<String?> _uploadToCloudinary() async {
//     if (_image == null) return null;

//     try {
//       final url = Uri.parse('https://api.cloudinary.com/v1_1/datygsam7/upload');
//       final request = http.MultipartRequest('POST', url);

//       request.fields['upload_preset'] = 'SpotApplication';
//       request.files
//           .add(await http.MultipartFile.fromPath('file', _image!.path));

//       final response = await request.send();
//       if (response.statusCode == 200) {
//         final responseData = await response.stream.toBytes();
//         final responseString = String.fromCharCodes(responseData);
//         final jsonMap = jsonDecode(responseString);
//         return jsonMap['secure_url'] as String;
//       } else {
//         throw HttpException('Upload failed with status ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error uploading image: $e';
//       });
//       return null;
//     }
//   }

//   Future<void> _updateUserData() async {
//     try {
//       final currentUser = _firebaseAuth.currentUser;
//       if (currentUser == null) {
//         throw Exception('No user is currently signed in');
//       }

//       if (_image != null) {
//         _imageUrl = await _uploadToCloudinary();
//         if (_imageUrl == null) {
//           throw Exception('Failed to upload image');
//         }
//       }

//       final data = {
//         'name': _nameController.text.trim(),
//         'phone': _numberController.text.trim(),
//         'email': _emailController.text.trim(),
//         'category': _categoryController.text.trim(),
//         'description': _descriptionController.text.trim(),
//         'location': _locationController.text.trim(),
//         'image': _imageUrl ?? '',
//       };

//       await FirebaseFirestore.instance
//           .collection('vendor_reg')
//           .doc(currentUser.uid)
//           .set(data, SetOptions(merge: true));

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Profile updated successfully'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Update failed: ${e.toString()}';
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(_errorMessage)),
//       );
//     }
//   }

//   Future<Map<String, dynamic>> _getUserData() async {
//     try {
//       final currentUser = _firebaseAuth.currentUser;
//       if (currentUser == null) {
//         throw Exception('No user is currently signed in');
//       }

//       final docSnapshot = await FirebaseFirestore.instance
//           .collection('vendor_reg')
//           .doc(currentUser.uid)
//           .get();

//       if (!docSnapshot.exists) {
//         throw Exception('User document does not exist');
//       }

//       final userData = docSnapshot.data() ?? {};
//       return userData;
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error fetching user data: ${e.toString()}';
//       });
//       return {};
//     }
//   }

//   void _showLogoutDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Log Out'),
//           content: const Text('Do you want to log out?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('No'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 await _auth.signOut();
//                 gotologin(context);
//               },
//               child: const Text(
//                 'Yes',
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Shop Profile Page'),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: _showLogoutDialog,
//             icon: const Icon(Icons.logout_rounded),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.white,
//       body: _isSaving
//           ? const Center(child: CircularProgressIndicator())
//           : FutureBuilder<Map<String, dynamic>>(
//               future: _getUserData(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError ||
//                     snapshot.data == null ||
//                     snapshot.data!.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(_errorMessage.isNotEmpty
//                             ? _errorMessage
//                             : 'Unable to load user data'),
//                         ElevatedButton(
//                           onPressed: () => setState(() {}),
//                           child: const Text('Retry'),
//                         )
//                       ],
//                     ),
//                   );
//                 }

//                 final user = snapshot.data!;

//                 // Initialize controllers only if not in editing mode
//                 if (!_isEditing) {
//                   _nameController.text = user['name'] ?? '';
//                   _numberController.text = user['phone'] ?? '';
//                   _emailController.text = user['email'] ?? '';
//                   _categoryController.text = user['category'] ?? '';
//                   _descriptionController.text = user['description'] ?? '';
//                   _locationController.text = user['location'] ?? '';
//                   _imageUrl = user['image'] ?? '';
//                 }

//                 return _buildProfileContent(user);
//               },
//             ),
//     );
//   }

//   Widget _buildProfileContent(Map<String, dynamic> user) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Profile Image Section
//             Stack(
//               children: [
//                 Container(
//                   width: 260, // Width of the square/rectangle
//                   height: 160, // Height of the square/rectangle
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100], // Background color for the border
//                     image: _image != null
//                         ? DecorationImage(
//                             image: FileImage(_image!),
//                             fit: BoxFit.cover,
//                           )
//                         : (_imageUrl != null && _imageUrl!.isNotEmpty
//                             ? DecorationImage(
//                                 image: NetworkImage(_imageUrl!),
//                                 fit: BoxFit.cover,
//                               )
//                             : null),
//                     borderRadius: BorderRadius.circular(
//                         10), // Adjust the border radius for rounded corners
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: Offset(0, 3), // Changes position of shadow
//                       ),
//                     ],
//                   ),
//                   child: _imageUrl == null && _image == null
//                       ? const Icon(Icons.person, size: 80)
//                       : null,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 15),

//             // Text Fields
//             _buildTextField(_nameController, 'Username', Icons.person),
//             _buildTextField(_emailController, 'Email', Icons.email),
//             _buildTextField(_numberController, 'Phone', Icons.phone),
//             _buildTextField(_categoryController, 'Category', Icons.category),
//             _buildTextField(
//                 _descriptionController, 'Description', Icons.description),
//             _buildTextField(_locationController, 'Location', Icons.location_on),

//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//       TextEditingController controller, String hint, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       child: TextField(
//         controller: controller,
//         readOnly: true, // Makes the field read-only
//         decoration: InputDecoration(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: BorderSide(color: Colors.blueAccent, width: 2),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: BorderSide(color: Colors.grey, width: 1),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: BorderSide(color: Colors.blueAccent, width: 2),
//           ),
//           hintText: hint,
//           hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
//           prefixIcon:
//               Icon(icon, color: Colors.blueAccent), // Profile-related icon
//           filled: true,
//           fillColor: Colors.grey[200], // Subtle background for read-only fields
//           contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//         ),
//         style: TextStyle(
//             color: Colors.black, fontSize: 16), // Text style for visibility
//       ),
//     );
//   }

//   void gotologin(BuildContext context) {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginPage()),
//       (Route<dynamic> route) => false,
//     );
//   }
// }
