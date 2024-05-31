import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

class NewMessage extends StatefulWidget {
  final String friendUid;

  NewMessage({required this.friendUid});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _userEnterMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection(widget.friendUid)
        .add({
      'text': _userEnterMessage,
      'time': Timestamp.now(),
      'userID': userId,
    });
    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.friendUid)
        .collection(userId)
        .add({
      'text': _userEnterMessage,
      'time': Timestamp.now(),
      'userID': userId,
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      margin: EdgeInsets.only(top: 10, bottom: 15, left: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              decoration: InputDecoration(hintText: '메세지를 입력하세요'),
              onChanged: (value) {
                setState(() {
                  _userEnterMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
            color: Colors.black,
          )
        ],
      ),
    );
  }
}
