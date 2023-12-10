import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String? message;
  final bool? isMe;

  @override
  final Key? key;
  final String? userName;
  final String? userImage;

  const MessageBubble(this.message, this.userName, this.userImage, this.isMe, {this.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isMe! ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              //width: 140,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              decoration: BoxDecoration(
                color: isMe! ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: isMe!
                        ? const Radius.circular(0)
                        : const Radius.circular(12),
                    bottomRight: isMe!
                        ? const Radius.circular(0)
                        : const Radius.circular(12)),
              ),
              child: Column(
                crossAxisAlignment: isMe!? CrossAxisAlignment.end: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName!,
                    style: TextStyle(color: isMe!? Colors.black: Theme.of(context).accentTextTheme.headline1!.color, fontWeight: FontWeight.bold,),
                  ),
                  Text(
                    message!,
                    textAlign: isMe!? TextAlign.end: TextAlign.start,
                    style: TextStyle(
                        color: isMe!
                            ? Colors.black
                            : Theme.of(context).accentTextTheme.headline1!.color),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -10,
          left: isMe!? null: 60,
          right: isMe!? 60: null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage!),
          ),
        ),
      ],
    );
  }
}