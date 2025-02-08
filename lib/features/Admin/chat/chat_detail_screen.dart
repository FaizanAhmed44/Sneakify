// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ChatDetailScreen extends StatefulWidget {
//   final String chatId;

//   ChatDetailScreen({required this.chatId});

//   @override
//   _ChatDetailScreenState createState() => _ChatDetailScreenState();
// }

// class _ChatDetailScreenState extends State<ChatDetailScreen> {
//   final TextEditingController _messageController = TextEditingController();

//   void sendMessage() async {
//     if (_messageController.text.trim().isEmpty) return;

//     final newMessage = {
//       'text': _messageController.text,
//       'senderId': FirebaseAuth.instance.currentUser!.uid,
//       'timestamp': FieldValue.serverTimestamp(),
//     };

//     await FirebaseFirestore.instance
//         .collection('chats')
//         .doc(widget.chatId)
//         .collection('messages')
//         .add(newMessage);

//     // Update lastMessage and lastTimestamp
//     await FirebaseFirestore.instance
//         .collection('chats')
//         .doc(widget.chatId)
//         .update({
//       'lastMessage': _messageController.text,
//       'lastTimestamp': FieldValue.serverTimestamp(),
//     });

//     _messageController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('chats')
//                   .doc(widget.chatId)
//                   .collection('messages')
//                   .orderBy('timestamp', descending: false)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 final messages = snapshot.data!.docs;

//                 return ListView.builder(
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message = messages[index];
//                     final isCurrentUser = message['senderId'] ==
//                         FirebaseAuth.instance.currentUser!.uid;

//                     return Align(
//                       alignment: isCurrentUser
//                           ? Alignment.centerRight
//                           : Alignment.centerLeft,
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           vertical: 10,
//                           horizontal: 14,
//                         ),
//                         margin: EdgeInsets.symmetric(
//                           vertical: 5,
//                           horizontal: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           color: isCurrentUser
//                               ? Colors.blueAccent
//                               : Colors.grey[300],
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text(message['text']),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type your message...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/const/colors.dart';
import 'package:ecommerce_app/theme/theme_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.currentUserId,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();

  void sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final message = _messageController.text;
    final messageDoc = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .doc();

    await messageDoc.set({
      'senderId': widget.currentUserId,
      'text': message,
      'timestamp': Timestamp.now(),
    });

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .update({
      'lastMessage': message,
      'lastTimestamp': Timestamp.now(),
    });

    _messageController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, TheamModal theamNotifier, child) {
      return Scaffold(
        backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
        appBar: AppBar(
          backgroundColor: theamNotifier.isDark ? mainColor : scaffoldColor,
          title: "Chat With Admin"
              .text
              .size(19)
              .bold
              .color(theamNotifier.isDark ? Colors.white : Colors.black)
              .make(),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(widget.chatId)
                    .collection('messages')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isCurrentUser =
                          message['senderId'] == widget.currentUserId;

                      return ListTile(
                        title: Align(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              message['text'],
                              style: TextStyle(
                                  color: isCurrentUser
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 12.0, left: 10, right: 10, top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(
                        color: theamNotifier.isDark
                            ? Colors.white.withOpacity(0.7)
                            : Colors.black.withOpacity(0.7),
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: lightColor,
                    ),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
