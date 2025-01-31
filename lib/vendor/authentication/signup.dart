// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:spot/Firbase/auth_service.dart';
// import 'package:spot/vendor/authentication/login.dart';
// import 'package:spot/validation/form_validation.dart';
// import 'package:spot/vendor/screens/vendorRegistrationpage.dart';

// class Signup extends StatefulWidget {
//   const Signup({super.key});

//   @override
//   State<Signup> createState() => _SignupState();
// }

// class _SignupState extends State<Signup> {
//   final _email = TextEditingController();
//   final _password = TextEditingController();
//   final _confirmPassword = TextEditingController();
//   final _name = TextEditingController();

//   bool _isLoading = false;
//   final formKey = GlobalKey<FormState>();
//   final FormValidation validation = FormValidation();

//   bool _isObscured = true;
//   bool _isConfirmObscured = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F4F8),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.asset('assets/SplashScreen__1_-removebg-preview.png',
//                 height: 150),
//             const SizedBox(height: 20),
//             const Text(
//               'Vendor Sign Up',
//               style: TextStyle(
//                 fontSize: 32,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF3D82DB),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Form(
//               key: formKey,
//               child: Column(
//                 children: [
//                   _buildTextField(
//                     controller: _name,
//                     hintText: 'Full Name',
//                     icon: Icons.person,
//                   ),
//                   const SizedBox(height: 15),
//                   _buildTextField(
//                     controller: _email,
//                     hintText: 'Email Address',
//                     icon: Icons.email,
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) =>
//                         validation.EmailValidation(value ?? ''),
//                   ),
//                   const SizedBox(height: 15),
//                   _buildPasswordField(
//                     controller: _password,
//                     hintText: 'Password',
//                     icon: Icons.lock_outline,
//                     validator: (value) =>
//                         validation.PasswordValidation(value ?? ""),
//                     obscureText: _isObscured,
//                     onToggle: () => setState(() {
//                       _isObscured = !_isObscured;
//                     }),
//                   ),
//                   const SizedBox(height: 15),
//                   _buildPasswordField(
//                     controller: _confirmPassword,
//                     hintText: 'Confirm Password',
//                     icon: Icons.lock_outline,
//                     validator: (value) {
//                       if (value != _password.text) {
//                         return "Passwords do not match";
//                       }
//                       return null;
//                     },
//                     obscureText: _isConfirmObscured,
//                     onToggle: () => setState(() {
//                       _isConfirmObscured = !_isConfirmObscured;
//                     }),
//                   ),
//                   const SizedBox(height: 20),
//                   _buildSignupButton(),
//                   const SizedBox(height: 15),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("Already have an account?"),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const LoginPage()));
//                         },
//                         child: const Text(
//                           'LOGIN',
//                           style: TextStyle(color: Color(0xFF3D82DB)),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     String? Function(String?)? validator,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         validator: validator,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           hintText: hintText,
//           prefixIcon: Icon(icon, color: Colors.blueGrey),
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(15),
//               borderSide: BorderSide.none),
//         ),
//       ),
//     );
//   }

//   Widget _buildPasswordField({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData icon,
//     required String? Function(String?) validator,
//     required bool obscureText,
//     required VoidCallback onToggle,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         validator: validator,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           hintText: hintText,
//           prefixIcon: Icon(icon, color: Colors.blueGrey),
//           suffixIcon: IconButton(
//             icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility,
//                 color: Colors.blueGrey),
//             onPressed: onToggle,
//           ),
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(15),
//               borderSide: BorderSide.none),
//         ),
//       ),
//     );
//   }

//   Widget _buildSignupButton() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: MaterialButton(
//         minWidth: double.infinity,
//         onPressed: _signupCustomer,
//         color: const Color(0xFF3D82DB),
//         textColor: Colors.white,
//         padding: const EdgeInsets.symmetric(vertical: 15),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: _isLoading
//             ? const CircularProgressIndicator(color: Colors.white)
//             : const Text(
//                 'Sign Up',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//       ),
//     );
//   }

//   Future<void> _signupCustomer() async {
//     if (formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       try {
//         UserCredential userCredential =
//             await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: _email.text.trim(),
//           password: _password.text.trim(),
//         );

//         await FirebaseFirestore.instance
//             .collection('customer_login')
//             .doc(userCredential.user!.uid)
//             .set({
//           'name': _name.text.trim(),
//           'email': _email.text.trim(),
//           'role': 'vendor',
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Signup successful!')),
//         );
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => const VendorRegistrationpage()));
//       } catch (e) {
//         log("Error during signup: $e");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Signup failed: $e")),
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
// }

// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:spot/charity/screens/charityRegistration.dart';
// import 'package:spot/vendor/screens/vendorRegistrationpage.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _nameController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   String _selectedRole = 'vendor';
//   bool _isLoading = false;
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _nameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign Up'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Image.asset('assets/SplashScreen__1_-removebg-preview.png',
//                   height: 150),
//               const SizedBox(height: 20),
//               Center(
//                 child: const Text(
//                   'Sign Up',
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF3D82DB),
//                   ),
//                 ),
//               ),
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Full Name',
//                   prefixIcon: const Icon(Icons.person),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Name is required';
//                   }
//                   if (value.length < 2) {
//                     return 'Name must be at least 2 characters';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   prefixIcon: const Icon(Icons.email),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Email is required';
//                   }
//                   if (!value.contains('@') || !value.contains('.')) {
//                     return 'Enter a valid email address';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   prefixIcon: const Icon(Icons.lock),
//                   suffixIcon: IconButton(
//                     icon: Icon(_obscurePassword
//                         ? Icons.visibility
//                         : Icons.visibility_off),
//                     onPressed: () =>
//                         setState(() => _obscurePassword = !_obscurePassword),
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 obscureText: _obscurePassword,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Password is required';
//                   }
//                   if (value.length < 6) {
//                     return 'Password must be at least 6 characters';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _confirmPasswordController,
//                 decoration: InputDecoration(
//                   labelText: 'Confirm Password',
//                   prefixIcon: const Icon(Icons.lock_outline),
//                   suffixIcon: IconButton(
//                     icon: Icon(_obscureConfirmPassword
//                         ? Icons.visibility
//                         : Icons.visibility_off),
//                     onPressed: () => setState(() =>
//                         _obscureConfirmPassword = !_obscureConfirmPassword),
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 obscureText: _obscureConfirmPassword,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please confirm your password';
//                   }
//                   if (value != _passwordController.text) {
//                     return 'Passwords do not match';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 value: _selectedRole,
//                 decoration: InputDecoration(
//                   labelText: 'Select Role',
//                   prefixIcon: const Icon(Icons.person_outline),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 items: const [
//                   DropdownMenuItem(value: 'vendor', child: Text('Vendor')),
//                   DropdownMenuItem(value: 'charity', child: Text('Charity')),
//                 ],
//                 onChanged: (value) => setState(() => _selectedRole = value!),
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _signup,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                     : const Text(
//                         'Sign Up',
//                         style: TextStyle(fontSize: 16),
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _signup() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       // Create user account
//       final UserCredential userCredential =
//           await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       if (!mounted) return;

//       final String userId = userCredential.user!.uid;

//       // Save user details to Firestore
//       await FirebaseFirestore.instance.collection('CV_users').doc(userId).set({
//         'name': _nameController.text.trim(),
//         'email': _emailController.text.trim(),
//         'role': _selectedRole,
//         'createdAt': FieldValue.serverTimestamp(),
//         'isProfileComplete': false,
//       }).then((_) {
//         // Navigate based on role after successful write
//         if (_selectedRole == 'vendor') {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => const VendorRegistrationpage()),
//           );
//         } else {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => const CharityRegistration()),
//           );
//         }
//       }).catchError((error) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error saving user data: $error')),
//         );
//         log('Firestore error: $error');
//       });
//     } on FirebaseAuthException catch (e) {
//       String message;
//       switch (e.code) {
//         case 'email-already-in-use':
//           message = 'This email is already registered.';
//           break;
//         case 'invalid-email':
//           message = 'The email address is badly formatted.';
//           break;
//         case 'operation-not-allowed':
//           message = 'Email/password accounts are not enabled.';
//           break;
//         case 'weak-password':
//           message = 'The password provided is too weak.';
//           break;
//         default:
//           message = 'Authentication error: ${e.message}';
//       }

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message)),
//       );
//       log('Signup error: ${e.code} - ${e.message}');
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Signup error: $e')),
//       );
//       log('Signup error: $e');
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
// }
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spot/charity/screens/charityRegistration.dart';
import 'package:spot/vendor/screens/vendorRegistrationpage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _selectedRole = 'vendor';
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _buildPasswordField(
                        controller: _passwordController,
                        label: 'Password',
                        obscureText: _obscurePassword,
                        onToggle: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                      const SizedBox(height: 16),
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        obscureText: _obscureConfirmPassword,
                        onToggle: () => setState(() =>
                            _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: InputDecoration(
                          labelText: 'Select Role',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'vendor', child: Text('Vendor')),
                          DropdownMenuItem(
                              value: 'charity', child: Text('Charity')),
                        ],
                        onChanged: (value) =>
                            setState(() => _selectedRole = value!),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _signup,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.teal,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black87),
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black87),
        prefixIcon: const Icon(Icons.lock, color: Colors.teal),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.teal),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        if (label == 'Password' && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create user account
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      final String userId = userCredential.user!.uid;

      // Save user details to Firestore
      await FirebaseFirestore.instance.collection('CV_users').doc(userId).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': _selectedRole,
        'createdAt': FieldValue.serverTimestamp(),
        'isProfileComplete': false,
      }).then((_) {
        // Navigate based on role after successful write
        if (_selectedRole == 'vendor') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const VendorRegistrationpage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const CharityRegistration()),
          );
        }
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving user data: $error')),
        );
        log('Firestore error: $error');
      });
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered.';
          break;
        case 'invalid-email':
          message = 'The email address is badly formatted.';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled.';
          break;
        case 'weak-password':
          message = 'The password provided is too weak.';
          break;
        default:
          message = 'Authentication error: ${e.message}';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      log('Signup error: ${e.code} - ${e.message}');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup error: $e')),
      );
      log('Signup error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
