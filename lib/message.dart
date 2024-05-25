import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final ChatDocs = snapshot.data!.docs;
        return ListView.builder(
            reverse: true,
            itemCount: ChatDocs.length,
            itemBuilder: (context, index) {
              return Text(ChatDocs[index]['text']);
            });
      },
    );
  }
}
