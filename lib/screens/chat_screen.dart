import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  String messageText;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  void getCurrenrUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrenrUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'people');
              },
              icon: Icon(Icons.people)),
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                await _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  List<Bubbles> messageTexts = [];
                  if (snapshot.hasData) {
                    final x = snapshot.data.docs;
                    for (var p in x) {
                      String messageText = p.data()['Text'];
                      String senderText = p.data()['Sender'];
                      bool isMe = senderText == loggedInUser.email;
                      messageTexts.add(Bubbles(senderText, messageText, isMe));
                    }
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      children: messageTexts,
                    ),
                  );
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      messageController.clear();
                      int cnt = await _firestore
                          .collection("counter")
                          .doc('123')
                          .get()
                          .then((value) {
                        return value.data()['timestamp'];
                      });

                      _firestore.collection('messages').add({
                        'Text': messageText,
                        'Sender': loggedInUser.email,
                        'timestamp': cnt,
                      });

                      //updating counter in firestore cloud
                      _firestore
                          .collection("counter")
                          .doc('123')
                          .update({"timestamp": cnt + 1});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Bubbles extends StatelessWidget {
  final String message;
  final String sender;
  final bool isMe;
  Bubbles(this.sender, this.message, this.isMe);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe == true ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender,
              style: TextStyle(
                color: Colors.black54,
              )),
          Material(
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            elevation: 5.0,
            borderRadius: isMe == true
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text(
                message,
                style: TextStyle(
                    fontSize: 18.0, color: isMe ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class People extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: SafeArea(
        child: Column(
          children: [
            Text('Registered users',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold)),
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('users').snapshots(),
                builder: (context, snapshot) {
                  List<Padding> messageTexts = [];
                  if (snapshot.hasData) {
                    final x = snapshot.data.docs;
                    for (var p in x) {
                      String user = p.data()['email'];
                      messageTexts.add(Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              user,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                          elevation: 5.0,
                          color: Colors.blue,
                        ),
                      ));
                    }
                  }
                  return Expanded(
                    child: ListView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      children: messageTexts,
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
