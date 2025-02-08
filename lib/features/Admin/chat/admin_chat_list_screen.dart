// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecommerce_app/features/Admin/chat/admin_detail_chat.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class AdminChatListScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Chats'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('chats')
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
//               final userId = participants.firstWhere((id) =>
//                   id !=
//                   FirebaseAuth.instance.currentUser!.uid); // Find the user's ID
//               final lastMessage = chat['lastMessage'];
//               final lastTimestamp = chat['lastTimestamp'].toDate();

//               return ListTile(
//                 title: Text(
//                     'User: $userId'), // Replace with user's name via Firestore fetch
//                 subtitle: Text(lastMessage),
//                 trailing: Text(
//                   DateFormat('hh:mm a').format(lastTimestamp),
//                   style: TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AdminChatDetailScreen(
//                         chatId: chat.id,
//                         userId: userId,
//                       ),
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
import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/features/Admin/chat/chat_detail_screen.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminChatListScreen extends StatelessWidget {
  final String adminId;

  const AdminChatListScreen({super.key, required this.adminId});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, TheamModal theamNotifier, child) {
      return Scaffold(
        backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
        appBar: AppBar(
          title: "User Chat"
              .text
              .size(19)
              .bold
              .color(theamNotifier.isDark ? Colors.white : Colors.black)
              .make(),
          backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .where('participants', arrayContains: adminId)
              .orderBy('lastTimestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final chats = snapshot.data!.docs;

            if (chats.isEmpty) {
              return const Center(child: Text("No active user chats."));
            }

            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                final participants = chat['participants'];
                final lastMessage = chat['lastMessage'] ?? '';
                final lastTimestamp = chat['lastTimestamp'].toDate();
                final otherParticipant = participants.firstWhere(
                  (id) => id != adminId, // Find the user in the chat
                );

                // return ListTile(
                //   title: Text(
                //     'User ID: $otherParticipant',
                //     style: TextStyle(
                //       fontSize: 12,
                //     ),
                //   ),
                //   subtitle: Text(lastMessage),
                //   trailing: Text(
                //     DateFormat('hh:mm a').format(lastTimestamp),
                //   ),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => ChatDetailScreen(
                //           chatId: chat.id,
                //           currentUserId: adminId,
                //         ),
                //       ),
                //     );
                //   },
                // );

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          chatId: chat.id,
                          currentUserId: adminId,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color:
                          theamNotifier.isDark ? mainDarkColor : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'User ID: ',
                            style: TextStyle(
                                color: theamNotifier.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: '$otherParticipant',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            lastMessage
                                .toString()
                                .text
                                .size(15)
                                .color(theamNotifier.isDark
                                    ? Colors.white
                                    : Colors.black)
                                .make(),
                            Text(
                              DateFormat('hh:mm a').format(lastTimestamp),
                              style: TextStyle(
                                  color: theamNotifier.isDark
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ],
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
    });
  }
}
