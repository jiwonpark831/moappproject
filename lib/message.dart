import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chatBubble.dart';

class Messages extends StatelessWidget {
  final String friendUid;

  Messages({required this.friendUid});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(friendUid)
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index) {
            return ChatBubble(
              chatDocs[index]['text'],
              chatDocs[index]['userID'] == user?.uid,
              chatDocs[index]['isRead'],
            );
          },
        );
      },
    );
  }
}
