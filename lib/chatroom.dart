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
  Map<String, String> friendsname = {};

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
    List<Future<void>> friendFetchFutures = chatroomNames.map((element) async {
      var _friend = await _firestore.collection('user').doc(element).get();
      friendsname[_friend.get('uid')] = _friend.get('name');
    }).toList();

    await Future.wait(friendFetchFutures);
    setState(() {});
  }

  getFriendName(String friendUID) async {
    var doc = await _firestore.collection('user').doc(friendUID).get();
    setState(() {
      friendsname[doc.get('uid')] = doc.get('name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내 채팅',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
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
                  child: Text('${friendsname[chatroomNames[index]]}'),
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
                      builder: (context) => EachChatroom(chatroomNames[index]),
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
