import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorChatScreen extends StatefulWidget {
  final String vendorEmail;

  const VendorChatScreen({Key? key, required this.vendorEmail})
      : super(key: key);

  @override
  _VendorChatScreenState createState() => _VendorChatScreenState();
}

class _VendorChatScreenState extends State<VendorChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Chats'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: widget.vendorEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No chats available.'));
          }

          final chatRooms = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = chatRooms[index];
              final participants =
                  List.from(chatRoom['participants'])..remove(widget.vendorEmail);
              final userId = participants.isNotEmpty ? participants[0] : 'User';

              return ListTile(
                title: Text('Chat with $userId'),
                subtitle: Text(chatRoom['lastMessage'] ?? 'No messages yet'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailScreen(
                        vendorEmail: widget.vendorEmail,
                        userId: userId,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ChatDetailScreen extends StatelessWidget {
  final String vendorEmail;
  final String userId;

  const ChatDetailScreen({
    Key? key,
    required this.vendorEmail,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with $userId'),
      ),
      body: Center(
        child: Text('Chat details with $userId (Coming Soon)'),
      ),
    );
  }
}
