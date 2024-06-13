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
  Map<String, dynamic>? friendProfile;

  @override
  void initState() {
    super.initState();
    ShowFriendProfile();
    ReadMessage();
  }

  Future<void> ShowFriendProfile() async {
    DocumentSnapshot doc =
        await _firestore.collection('user').doc(widget.friendUid).get();
    if (doc.exists) {
      setState(() {
        friendProfile = doc.data() as Map<String, dynamic>?;
      });
    }
  }

  void ReadMessage() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final messagesQuery = _firestore
        .collection('user')
        .doc(userId)
        .collection(widget.friendUid)
        .where('isRead', isEqualTo: false);

    final messages = await messagesQuery.get();

    for (var message in messages.docs) {
      var tmp = await message.reference.get();
      if (tmp['userID']!=FirebaseAuth.instance.currentUser!.uid){
        await message.reference.update({'isRead': true});
      }
    }
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(friendProfile != null ? friendProfile!['name'] : 'loading..'),
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
