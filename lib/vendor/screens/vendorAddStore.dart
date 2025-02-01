
// import 'dart:convert';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:spot/vendor/Navbar/vendorbottomnavigation.dart';

// class ShopRegistrationPage extends StatefulWidget {
//   const ShopRegistrationPage({super.key});

//   @override
//   State<ShopRegistrationPage> createState() => _ShopRegistrationPageState();
// }

// class _ShopRegistrationPageState extends State<ShopRegistrationPage> {
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _numberController = TextEditingController();
//   final _categoryController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _locationContorller = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   File? _image;

//   String? _imageUrl;
//   bool _isLoading = false;

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
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error uploading image: $e')),
//       );
//       return null;
//     }
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

//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please log in to save your profile")),
//         );
//         return;
//       }

//       setState(() {
//         _isLoading = true;
//       });

//       String? _imageUrl = await _uploadToCloudinary();

//       if (_imageUrl == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to upload image")),
//         );
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//       }

//       try {
//         await FirebaseFirestore.instance.collection('Store_reg').add({
//           'user_id': user.uid, // Keep track of which user added it
//           'name': _nameController.text.trim(),
//           'number': _numberController.text.trim(),
//           'email': _emailController.text.trim(),
//           'category': _categoryController.text.trim(),
//           'Description': _descriptionController.text.trim(),
//           'location': _locationContorller.text.trim(),
//           'image': _imageUrl ?? '',
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Profile saved successfully!")),
//         );

//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => vebdorBottomNavbar()),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Failed to save profile: $e")),
//         );
//       }

//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Shop Registration'),
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//       ),
//       backgroundColor: Colors.white,
//       body: Center(
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 GestureDetector(
//                   onTap: _pickImage,
//                   child: CircleAvatar(
//                     radius: 70,
//                     backgroundColor: Colors.grey.shade300,
//                     backgroundImage: _image != null ? FileImage(_image!) : null,
//                     child: _image == null
//                         ? Icon(Icons.person,
//                             size: 50, color: Colors.grey.shade600)
//                         : null,
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 _buildTextField(
//                     _nameController, 'Shop Name', 'Please enter shop name'),
//                 _buildEmailField(),
//                 _buildPhoneNumberField(),
//                 _buildTextField(
//                     _categoryController, 'Category', 'Please enter category'),
//                 _buildTextField(_descriptionController, 'Description',
//                     'Please enter description'),
//                 _buildTextField(
//                     _locationContorller, 'Location', 'Please enter location'),
//                 _isLoading
//                     ? const CircularProgressIndicator()
//                     : ElevatedButton(
//                         onPressed: _submitForm,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blueAccent,
//                           foregroundColor: Colors.white,
//                           elevation: 5,
//                         ),
//                         child: const Text('Create shop'),
//                       ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//       TextEditingController controller, String hintText, String validationMsg) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           hintText: hintText,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return validationMsg;
//           }
//           return null;
//         },
//       ),
//     );
//   }

//   Widget _buildEmailField() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: TextFormField(
//         controller: _emailController,
//         decoration: InputDecoration(
//           hintText: 'Email',
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter your email';
//           } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//             return 'Please enter a valid email';
//           }
//           return null;
//         },
//       ),
//     );
//   }

//   Widget _buildPhoneNumberField() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: TextFormField(
//         controller: _numberController,
//         keyboardType: TextInputType.phone,
//         decoration: InputDecoration(
//           hintText: 'Phone Number',
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter your phone number';
//           } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//             return 'Please enter a valid 10-digit phone number';
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }
