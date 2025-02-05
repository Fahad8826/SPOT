import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final String vendorEmail;
  final String userEmail;
  final String userName;

  const ChatDetailScreen({
    Key? key,
    required this.vendorEmail,
    required this.userEmail,
    required this.userName,
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final List<String> roomParticipants = [widget.vendorEmail, widget.userEmail]..sort();
    final String chatRoomId = roomParticipants.join('_');

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.userName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index].data() as Map<String, dynamic>;
                    final isVendor = messageData['senderEmail'] == widget.vendorEmail;
                    final message = messageData['message'] as String? ?? '';

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: isVendor ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: isVendor ? Colors.amber : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              message,
                              style: TextStyle(color: isVendor ? Colors.black : Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final String message = _messageController.text.trim();
    final timestamp = DateTime.now();

    final List<String> roomParticipants = [widget.vendorEmail, widget.userEmail]..sort();
    final String chatRoomId = roomParticipants.join('_');

   FirebaseFirestore.instance.collection('chats').doc(chatRoomId).set({
  "participants": ["vendor_email@example.com", "user_email@example.com"],
  "lastMessage": "Initial chat message",
  "lastMessageTime": FieldValue.serverTimestamp(),
});

    

    FirebaseFirestore.instance.collection('chat_rooms').doc(chatRoomId).set({
      'participants': [widget.vendorEmail, widget.userEmail],
      'participantDetails': {
        widget.userEmail: {'name': widget.userName},
        widget.vendorEmail: {'name': 'email'}, // Update vendor details if available
      },
      'lastMessage': message,
      'lastMessageTime': timestamp,
    });

    _messageController.clear();

    // Scroll to the bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.jumpTo(0);
    });
  }
}
