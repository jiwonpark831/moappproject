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
  Map<String, String> friendsprofile = {};
  Map<String, int> isReadCount = {};

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

    final messagesQuery = _firestore
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    List<Future<void>> friendFetchFutures = chatroomNames.map((element) async {
      var _friend = await _firestore.collection('user').doc(element).get();
      friendsname[_friend.get('uid')] = _friend.get('name');
      friendsprofile[_friend.get('uid')] = _friend.get('imageURL');
      var tmp = await messagesQuery
          .collection(element)
          .where('isRead', isEqualTo: false)
          .get();
      int count =0;
      for (var message in tmp.docs) {
        var tmp = await message.reference.get();
        if (tmp['userID']!=FirebaseAuth.instance.currentUser!.uid){  
          count++;
        }
      }
      isReadCount[_friend.get('uid')] = count;
    }).toList();

    await Future.wait(friendFetchFutures);
    if (this.mounted) {
      setState(() {});
    }
  }

  getFriendName(String friendUID) async {
    var doc = await _firestore.collection('user').doc(friendUID).get();
    setState(() {
      friendsname[doc.get('uid')] = doc.get('name');
    });
  }

  @override
  Widget build(BuildContext context) {
    getChatroomNames();
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
              child: Column(children: [
                Container(
                  width: 450,
                  height: 60,
                  child: ListTile(
                    leading: Image.network(
                        '${friendsprofile[chatroomNames[index]]}'),
                    title: Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 15),
                      child: Text('${friendsname[chatroomNames[index]]}'),
                    ),
                    trailing: isReadCount[chatroomNames[index]] != 0
                        ? Container(
                          alignment:Alignment.center,
                          width:20,
                          height:20,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color:Colors.red),
                          child:Text('${isReadCount[chatroomNames[index]]}',style: TextStyle(color:Colors.white),))
                        : null,
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
                Divider(
                  indent: 10,
                  endIndent: 10,
                  thickness: 1,
                ),
              ]));
        },
      ),
    );
  }
}
