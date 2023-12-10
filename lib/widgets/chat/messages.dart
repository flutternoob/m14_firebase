import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:m14_firebase/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chat")
              .orderBy(
                "createdAt",
                descending: true,
              )
              .snapshots(),
          builder: (context, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              reverse: true,
              itemCount: chatSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return MessageBubble(
                  chatSnapshot.data!.docs[index]["text"],
                  chatSnapshot.data!.docs[index]["userName"],
                  chatSnapshot.data!.docs[index]["userImage"],
                  chatSnapshot.data!.docs[index]["userId"] == futureSnapshot.data!.uid,
                    key: ValueKey(chatSnapshot.data!.docs[index]["userId"]),
                );
              },
            );
          },
        );
      }
    );
  }
}
