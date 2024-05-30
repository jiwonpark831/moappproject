import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'message.dart';
import 'newMessage.dart';

class EachChatroom extends StatefulWidget {
  final String friendUid;

  EachChatroom(this.friendUid);

  @override
  _EachChatroomState createState() => _EachChatroomState();
}

class _EachChatroomState extends State<EachChatroom> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.friendUid}'),
      ),
      body: Column(
        children: [
          Expanded(child: Messages(friendUid: widget.friendUid)),
          NewMessage(friendUid: widget.friendUid),
        ],
      ),
    );
  }
}
