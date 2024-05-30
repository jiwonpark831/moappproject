import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

import 'eachroom.dart';

class ChatroomPage extends StatefulWidget {
  const ChatroomPage({super.key});

  @override
  State<ChatroomPage> createState() => _ChatroomPageState();
}

class _ChatroomPageState extends State<ChatroomPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> chatroomNames = [];

  @override
  void initState() {
    super.initState();
    getChatroomNames();
  }

  getChatroomNames() async {
    DocumentSnapshot doc = await _firestore
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (doc.data() != null && doc.get('friendsList') != null) {
      chatroomNames = List<String>.from(doc.get('friendsList'));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: chatroomNames.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Container(
              width: 320,
              height: 60,
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 15),
                  child: Text(chatroomNames[index]),
                ),
                subtitle: Divider(
                  indent: 10,
                  endIndent: 10,
                  thickness: 1,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EachChatroom(chatroomNames[index]),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
