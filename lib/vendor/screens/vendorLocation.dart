// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';

// class PlacePickerScreen extends StatefulWidget {
//   @override
//   _PlacePickerScreenState createState() => _PlacePickerScreenState();
// }

// class _PlacePickerScreenState extends State<PlacePickerScreen> {
//   LatLng selectedLocation = LatLng(12.9716, 77.5946); // Default location (Bangalore)
//   TextEditingController _searchController = TextEditingController();
//   final String nominatimApiUrl = "https://nominatim.openstreetmap.org/search";

//   void _searchLocation(String query) async {
//     final response = await http.get(Uri.parse("$nominatimApiUrl?q=$query&format=json"));

//     if (response.statusCode == 200) {
//       List data = json.decode(response.body);
//       if (data.isNotEmpty) {
//         setState(() {
//           selectedLocation = LatLng(
//             double.parse(data[0]['lat']),
//             double.parse(data[0]['lon']),
//           );
//         });
//         _saveLocationToFirestore();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('No location found')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error searching location')),
//       );
//     }
//   }

//   void _saveLocationToFirestore() {
//     FirebaseFirestore.instance.collection('selected_places').add({
//       'latitude': selectedLocation.latitude,
//       'longitude': selectedLocation.longitude,
//       'timestamp': FieldValue.serverTimestamp(),
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Location saved successfully!')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Select a Place')),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search for a place',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: () => _searchLocation(_searchController.text),
//                 ),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//           Expanded(
//             child: FlutterMap(
//               options: MapOptions(
//                 center: selectedLocation,
//                 zoom: 10.0,
//                 onTap: (tapPosition, point) {
//                   setState(() {
//                     selectedLocation = point;
//                   });
//                   _saveLocationToFirestore();
//                 },
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                   subdomains: ['a', 'b', 'c'],
//                 ),
//                 MarkerLayer(
//                   markers: [
//                     Marker(
//                       width: 80.0,
//                       height: 80.0,
//                       point: selectedLocation,
//                       child: Icon(
//                         Icons.location_on,
//                         color: Colors.red,
//                         size: 40.0,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
// }
