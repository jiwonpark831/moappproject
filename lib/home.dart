import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'friend.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool myisGongGang = false;

  late bool mytag1 = false;
  late bool mytag2 = false;
  late bool mytag3 = false;
  late bool mytag4 = false;

  List<String> friendList = [];
  List<String> unfriendList=[];
  

  @override
  void initState() {
    super.initState();
    getFriendList();
    getunFriendList();
  }

  Future<void> getFriendList() async {
    var doc = await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      friendList = List<String>.from(doc['friendsList']);
    });
  }

  Future<void> getunFriendList() async {
    List<String> tmp=[];
    // var doc = await FirebaseFirestore.instance
    //     .collection('user')
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .get();

    await FirebaseFirestore.instance
        .collection('user')
        .snapshots()
        .listen((snapshot) {
          tmp.clear();
          snapshot.docs.forEach((element){
            if (!friendList.contains(element.id) && element.id != FirebaseAuth.instance.currentUser!.uid){
              tmp.add(element.id);
            }
          });
        }
      );
    // unfriendList.shuffle();
    // unfriendList.getRange(0,2);
    setState(() {
      unfriendList=tmp;
      // debugPrint('${tmp.length}');
      // debugPrint('${unfriendList.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      if (appState.currentuser != null) {
        myisGongGang = appState.currentuser!.isGonggang;
        mytag1 = appState.currentuser!.tagCheck[0];
        mytag2 = appState.currentuser!.tagCheck[1];
        mytag3 = appState.currentuser!.tagCheck[2];
        mytag4 = appState.currentuser!.tagCheck[3];
        debugPrint('${appState.currentuser!.schedule}');
      }
      return Scaffold(
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Container(
              width: 300,
              height: 80,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    myisGongGang = !myisGongGang;
                    FirebaseFirestore.instance
                        .collection('user')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update(<String, dynamic>{'isGonggang': myisGongGang});
                  });
                },
                child: Text(
                  myisGongGang ? '공강' : '수업중',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color(myisGongGang ? 0xff000000 : 0xffA0A0A0),
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor:
                      Color(myisGongGang ? 0xffFFD795 : 0xffFFEAC7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    mytag1 = !mytag1;
                    FirebaseFirestore.instance
                        .collection('user')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update(<String, dynamic>{
                      'tagCheck': [mytag1, mytag2, mytag3, mytag4]
                    });
                  });
                },
                child: Text(
                  "공부해요",
                  style: TextStyle(
                    color: Color(mytag1 ? 0xffFFFFFF : 0xff000000),
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Color(mytag1 ? 0xffA0A0A0 : 0xffF6F6F6),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    mytag2 = !mytag2;
                    FirebaseFirestore.instance
                        .collection('user')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update(<String, dynamic>{
                      'tagCheck': [mytag1, mytag2, mytag3, mytag4]
                    });
                  });
                },
                child: Text(
                  "밥먹어요",
                  style: TextStyle(
                    color: Color(mytag2 ? 0xffFFFFFF : 0xff000000),
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Color(mytag2 ? 0xffA0A0A0 : 0xffF6F6F6),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    mytag3 = !mytag3;
                    FirebaseFirestore.instance
                        .collection('user')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update(<String, dynamic>{
                      'tagCheck': [mytag1, mytag2, mytag3, mytag4]
                    });
                  });
                },
                child: Text(
                  "한한해요",
                  style: TextStyle(
                    color: Color(mytag3 ? 0xffFFFFFF : 0xff000000),
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Color(mytag3 ? 0xffA0A0A0 : 0xffF6F6F6),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    mytag4 = !mytag4;
                    FirebaseFirestore.instance
                        .collection('user')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update(<String, dynamic>{
                      'tagCheck': [mytag1, mytag2, mytag3, mytag4]
                    });
                  });
                },
                child: Text(
                  "일단만나요",
                  style: TextStyle(
                    color: Color(mytag4 ? 0xffFFFFFF : 0xff000000),
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Color(mytag4 ? 0xffA0A0A0 : 0xffF6F6F6),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Divider(
            indent: 25,
            endIndent: 25,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '공강인 친구들이 있어요!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 400,
            height: 150,
            decoration: BoxDecoration(color: Color(0xffCCF9EE)),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: friendList.length,
              itemBuilder: (context, index) {
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('user')
                      .doc(friendList[index])
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData && snapshot.data != null) {
                      var userData = snapshot.data!;
                      bool isFriendGonggang = userData['isGonggang'] ?? false;
                      List<bool> friendTagCheck =
                          List<bool>.from(userData['tagCheck']);
                      bool showCard =
                          isFriendGonggang || friendTagCheck.contains(true);
                      if (showCard) {
                        return InkWell(
                          onTap:((){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FriendProfiles(friendList[index]),
                                ),
                              );
                          }),
                          child: Card(
                          elevation: 0,
                          child: Container(
                            color: Color(0xffCCF9EE),
                            width: 150,
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(userData['imageURL']),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  userData['name'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (friendTagCheck[0])
                                      Container(
                                        child: Text("#공부해요"),
                                        color: Color(0xffFFFFFF),
                                      ),
                                    if (friendTagCheck[1])
                                      Container(
                                        child: Text("#밥먹어요"),
                                        color: Color(0xffFFFFFF),
                                      ),
                                    if (friendTagCheck[2])
                                      Container(
                                        child: Text("#한한해요"),
                                        color: Color(0xffFFFFFF),
                                      ),
                                    if (friendTagCheck[3])
                                      Container(
                                        child: Text("#일단만나요"),
                                        color: Color(0xffFFFFFF),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ));
                      } else {
                        return Container();
                      }
                    } else {
                      return Text(' ');
                    }
                  },
                );
              },
            ),
          ),
          SizedBox(height: 30),
          Divider(
            indent: 25,
            endIndent: 25,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '새로운 공강메이트를 찾아보세요!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              width: 400,
              height: 150,
              decoration: BoxDecoration(color: Color(0xffFEDFAA)),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: unfriendList.length,
                itemBuilder: (context, index) {
                  debugPrint('${unfriendList.length}');
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('user')
                        .doc(unfriendList[index])
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasData && snapshot.data != null) {
                        var userData = snapshot.data!;
                        bool isFriendGonggang = userData['isGonggang'] ?? false;
                        List<bool> friendTagCheck =
                            List<bool>.from(userData['tagCheck']);
                        bool showCard =
                            isFriendGonggang || friendTagCheck.contains(true);
                        if (showCard) {
                          return InkWell(
                            onTap:((){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FriendProfiles(unfriendList[index]),
                                ),
                              );
                            }),
                            child: Card(
                            elevation: 0,
                            child: Container(
                              color: Color(0xffFEDFAA),
                              width: 150,
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        NetworkImage(userData['imageURL']),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    userData['name'],
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (friendTagCheck[0])
                                        Container(
                                          child: Text("#공부해요"),
                                          color: Color(0xffFFFFFF),
                                        ),
                                      if (friendTagCheck[1])
                                        Container(
                                          child: Text("#밥먹어요"),
                                          color: Color(0xffFFFFFF),
                                        ),
                                      if (friendTagCheck[2])
                                        Container(
                                          child: Text("#한한해요"),
                                          color: Color(0xffFFFFFF),
                                        ),
                                      if (friendTagCheck[3])
                                        Container(
                                          child: Text("#일단만나요"),
                                          color: Color(0xffFFFFFF),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ));
                        } else {
                          return Container();
                        }
                      } else {
                        return Text(' ');
                      }
                    },
                  );
                },
              ),
          )
        ]),
      );
    });
  }
}
