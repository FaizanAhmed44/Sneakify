// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecommerce_app/features/Admin/chat/chat_detail_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class ChatListScreen extends StatelessWidget {
//   final String currentUserId;

//   const ChatListScreen(
//       {super.key,
//       required this.currentUserId}); // Pass the logged-in user/admin ID

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Chats')),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('chats')
//             .where('participants', arrayContains: currentUserId)
//             .orderBy('lastTimestamp', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           final chats = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: chats.length,
//             itemBuilder: (context, index) {
//               final chat = chats[index];
//               final participants = chat['participants'];
//               final lastMessage = chat['lastMessage'];
//               final lastTimestamp = chat['lastTimestamp'].toDate();

//               return ListTile(
//                 title: Text(
//                     'Chat with ${participants[1]}'), // Replace with actual name
//                 subtitle: Text(lastMessage),
//                 trailing: Text(DateFormat('hh:mm a').format(lastTimestamp)),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ChatDetailScreen(chatId: chat!.id),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'chat_detail_screen.dart';

class ChatListScreen extends StatelessWidget {
  final String currentUserId;
  final bool isAdmin;

  const ChatListScreen({
    super.key,
    required this.currentUserId,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: currentUserId)
            .orderBy('lastTimestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return const Center(child: Text("No Chats Found"));
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final participants = chat['participants'];
              final lastMessage = chat['lastMessage'] ?? '';
              final lastTimestamp = chat['lastTimestamp'].toDate();
              final otherParticipant = participants.firstWhere(
                (id) => id != currentUserId,
              );

              return ListTile(
                title: Text(
                    isAdmin ? 'Chat with User: $otherParticipant' : 'Admin'),
                subtitle: Text(lastMessage),
                trailing: Text(
                  DateFormat('hh:mm a').format(lastTimestamp),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailScreen(
                          chatId: chat.id, currentUserId: currentUserId),
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
