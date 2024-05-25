import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _userEnterMessage = '';
  void _sendMessage() {
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _userEnterMessage,
      'time': Timestamp.now(),
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Row(children: [
        Expanded(
            child: TextField(
          controller: _controller,
          decoration: InputDecoration(labelText: 'send a message'),
          onChanged: (value) {
            setState(() {
              _userEnterMessage = value;
            });
          },
        )),
        IconButton(
          onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
          icon: Icon(Icons.send),
          color: Colors.blue,
        )
      ]),
    );
  }
}
