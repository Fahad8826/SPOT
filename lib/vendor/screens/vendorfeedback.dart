// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FeedbackPage extends StatefulWidget {
//   const FeedbackPage({Key? key}) : super(key: key);

//   @override
//   State<FeedbackPage> createState() => _FeedbackPageState();
// }

// class _FeedbackPageState extends State<FeedbackPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('All Feedback'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('feedback')
//             .orderBy('timestamp', descending: true) // Sort by latest feedback
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No feedback available.'));
//           }

//           final feedbackDocs = snapshot.data!.docs;

//           return ListView.builder(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: feedbackDocs.length,
//             itemBuilder: (context, index) {
//               final feedback = feedbackDocs[index].data() as Map<String, dynamic>;
//               final userEmail = feedback['userEmail'] ?? 'Anonymous';
//               final rating = feedback['rating'] ?? 0.0;
//               final comment = feedback['comment'] ?? 'No comment';
//               // final timestamp = feedback['timestamp'] as Timestamp?;
//               final vendorId = feedback['vendorId'] ?? 'Unknown Vendor';

//               return Card(
//                 margin: const EdgeInsets.only(bottom: 16.0),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // User Email
//                       Text(
//                         'User: $userEmail',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),

//                       // Vendor ID
//                       Text(
//                         'Vendor ID: $vendorId',
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(height: 8),

//                       // Rating
//                       Row(
//                         children: [
//                           const Icon(Icons.star, color: Colors.amber, size: 20),
//                           const SizedBox(width: 4),
//                           Text(
//                             rating.toStringAsFixed(1),
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),

//                       // Comment
//                       Text(
//                         'Comment: $comment',
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                       const SizedBox(height: 8),

//                       // Timestamp
//                       // if (timestamp != null)
//                       //   Text(
//                       //     'Submitted on: ${_formatTimestamp(timestamp)}',
//                       //     style: const TextStyle(
//                       //       fontSize: 12,
//                       //       color: Colors.grey,
//                       //     ),
//                       //   ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   // Helper function to format timestamp
//   // String _formatTimestamp(Timestamp timestamp) {
//   //   final dateTime = timestamp.toDate();
//   //   return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
//   // }
// }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FeedbackPage extends StatefulWidget {
//   final String vendorEmail;

//   const FeedbackPage({Key? key, required this.vendorEmail}) : super(key: key);

//   @override
//   State<FeedbackPage> createState() => _FeedbackPageState();
// }

// class _FeedbackPageState extends State<FeedbackPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Shop Feedback'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('feedback')
//             .where('vendorId', isEqualTo: widget.vendorEmail)  // Ensures we filter by the vendor's email
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No feedback available for your shop.'));
//           }

//           final feedbackDocs = snapshot.data!.docs;

//           return ListView.builder(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: feedbackDocs.length,
//             itemBuilder: (context, index) {
//               final feedback = feedbackDocs[index].data() as Map<String, dynamic>;

//               // Null safety check for fields that may not exist
//               final userEmail = feedback['userEmail'] ?? 'Anonymous';
//               final rating = feedback['rating'] ?? 0.0;
//               final comment = feedback['comment'] ?? 'No comment';

//               return Card(
//                 margin: const EdgeInsets.only(bottom: 16.0),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // User Email
//                       Text(
//                         'User: $userEmail',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),

//                       // Rating
//                       Row(
//                         children: [
//                           const Icon(Icons.star, color: Colors.amber, size: 20),
//                           const SizedBox(width: 4),
//                           Text(
//                             rating.toStringAsFixed(1),
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),

//                       // Comment
//                       Text(
//                         'Comment: $comment',
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class FeedbackPage extends StatelessWidget {
  final String vendorEmail;

  const FeedbackPage({Key? key, required this.vendorEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop Feedback'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('feedback')
            .where('vendorId', isEqualTo: vendorEmail)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No feedback available for your shop.'));
          }

          final feedbackDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: feedbackDocs.length,
            itemBuilder: (context, index) {
              final feedback = feedbackDocs[index].data() as Map<String, dynamic>;
              final userEmail = feedback['userEmail'] ?? 'Anonymous';
              final rating = feedback['rating'] ?? 0.0;
              final comment = feedback['comment'] ?? 'No comment';

              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User: $userEmail',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Comment: $comment',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
