// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trial_chat/data/datasources/firebase_datasources.dart';

import 'package:trial_chat/data/model/user_model.dart';

import '../data/model/channel_model.dart';
import '../data/model/message_model.dart';
import 'widgets/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  final UserModel partnerUser;
  const ChatPage({
    Key? key,
    required this.partnerUser,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CupertinoButton(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.partnerUser.userName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: FirebaseDatasources.instance.messageStream(channelId(widget.partnerUser.id, currentUser!.uid)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator());
                }
                final List<Message> messages = snapshot.data ?? [];
                // if message is null
                if (messages.isEmpty) {
                  return const Center(
                    child: Text('No message found'),
                  );
                }
                return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    reverse: true,
                    padding: const EdgeInsets.all(10),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ChatBubble(
                        direction: message.senderId == currentUser!.uid
                            ? Direction.right
                            : Direction.left,
                        message: message.textMessage,
                        type: BubbleType.alone,
                      );
                    },
                  );
              }
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // Send message logic here
                    sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage() async {
  if (_messageController.text.trim().isEmpty) {
    return;
  }

  // Channel not created yet
  final channel = Channel(
    id: channelId(currentUser!.uid, widget.partnerUser.id),
    memberIds: [currentUser!.uid, widget.partnerUser.id],
    members: [UserModel.fromFirebaseUser(currentUser!), widget.partnerUser],
    lastMessage: _messageController.text.trim(),
    sendBy: currentUser!.uid,
    lastTime: Timestamp.now(),
    unRead: {
      currentUser!.uid: false,
      widget.partnerUser.id: true,
    },
  );

  // Update channel
  await FirebaseDatasources.instance.updateChannel(channel.id, channel.toMap());

  // Create new message document
  var docRef = FirebaseFirestore.instance.collection('messages').doc();
  var message = Message(
    id: docRef.id,
    textMessage: _messageController.text.trim(),
    senderId: currentUser!.uid,
    sendAt: Timestamp.now(),
    channelId: channel.id, // Ensure the channel ID is used
  );
  // Add message to Firestore
  FirebaseDatasources.instance.addMessage(message);

  // Update channel with the latest message info
  var channelUpdateData = {
    'lastMessage': message.textMessage,
    'sendBy': currentUser!.uid,
    'lastTime': message.sendAt,
    'unRead': {
      currentUser!.uid: false,
      widget.partnerUser.id: true,
    },
  };
  FirebaseDatasources.instance.updateChannel(channel.id, channelUpdateData);

  // Clear message controller
  _messageController.clear();
 }
}
