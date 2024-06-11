import "package:flutter/material.dart";

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final bool isRead;

  ChatBubble(this.message, this.isMe, this.isRead);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: 145,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(color: isMe ? Colors.black : Colors.white),
              ),
              if (isMe && (isRead == false))
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '1',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
              bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
            ),
          ),
        ),
      ],
    );
  }
}
