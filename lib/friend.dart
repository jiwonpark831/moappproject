import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moappproject/timetable.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> friends = [];
  final _uidcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getfriendList();
  }

  getfriendList() async {
    DocumentSnapshot doc = await _firestore
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (doc.data() != null && doc.get('friendsList') != null) {
      friends = List<String>.from(doc.get('friendsList'));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내 친구',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            color: Colors.white),
                        height: 500,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 35, left: 30),
                              child: Text(
                                '친구 추가',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Center(
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 72),
                                    child: Container(
                                      height: 60,
                                      width: 250,
                                      child: TextField(
                                        controller: _uidcontroller,
                                        decoration: InputDecoration(
                                          hintText: '친구의 uid를 입력하세요',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                          ),
                                        ),
                                        maxLength: 10,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 24),
                                    child: TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        minimumSize: const Size(250, 38),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      child: Text('추가'),
                                    ),
                                  ),
                                ]),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text("친구 추가"))
        ],
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Container(
              width: 320,
              height: 60,
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 15),
                  child: Text(friends[index]),
                ),
                subtitle: Divider(
                  indent: 10,
                  endIndent: 10,
                  thickness: 1,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FriendProfiles(friends[index]),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class FriendProfiles extends StatefulWidget {
  final String friendUid;
  const FriendProfiles(this.friendUid);

  @override
  State<FriendProfiles> createState() => _FriendProfilesState();
}

class _FriendProfilesState extends State<FriendProfiles> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text('${widget.friendUid}'),
    ));
  }
}
