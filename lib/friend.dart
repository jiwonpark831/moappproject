import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moappproject/timetable.dart';
import 'package:provider/provider.dart';
import 'package:time_scheduler_table/time_scheduler_table.dart';

import 'app_state.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> friends = [];
  final _uidcontroller = TextEditingController();
  Map<String, String> friendsname = {};

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

    List<Future<void>> friendFetchFutures = friends.map((element) async {
      var _friend = await _firestore.collection('user').doc(element).get();
      friendsname[_friend.get('uid')] = _friend.get('name');
    }).toList();

    await Future.wait(friendFetchFutures);

    setState(() {});
  }

  void showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  AddFriend() async {
    String friendUid = _uidcontroller.text.trim();
    if (friendUid.isEmpty) return;

    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    if (friendUid == currentUserUid) {
      showAlertDialog('나는 나의 영원한 친구입니다');
      return;
    }

    DocumentReference currentUserDoc =
        _firestore.collection('user').doc(currentUserUid);
    DocumentReference friendUserDoc =
        _firestore.collection('user').doc(friendUid);

    DocumentSnapshot friendUserSnapshot = await friendUserDoc.get();

    if (!friendUserSnapshot.exists) {
      showAlertDialog('uid가 존재하지 않습니다');
      return;
    }

    if (friends.contains(friendUid)) {
      showAlertDialog('이미 있는 친구입니다');
      return;
    }

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot currentUserSnapshot =
          await transaction.get(currentUserDoc);
      if (currentUserSnapshot.exists) {
        transaction.update(currentUserDoc, {
          'friendsList': FieldValue.arrayUnion([friendUid])
        });
        transaction.update(friendUserDoc, {
          'friendsList': FieldValue.arrayUnion([currentUserUid])
        });
      }
    });

    _uidcontroller.clear();
    getfriendList();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      if (appState.currentuser != null) {
        friends = appState.currentuser!.friendList;
      }
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              '내 친구',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0, backgroundColor: Color(0xffFFEAC7)),
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
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
                                padding:
                                    const EdgeInsets.only(top: 35, left: 30),
                                child: Text(
                                  '친구 추가',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 72),
                                        child: Container(
                                          height: 60,
                                          width: 250,
                                          child: TextField(
                                            controller: _uidcontroller,
                                            decoration: InputDecoration(
                                              hintText: '친구의 UID를 입력하세요',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 24),
                                        child: ElevatedButton(
                                          onPressed: AddFriend,
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor: Color(0xffFFEAC7),
                                          ),
                                          child: Text(
                                            '추가',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text("친구 추가", style: TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                width: 320,
                height: 60,
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 25, bottom: 15),
                    child: Text('${friendsname[friends[index]]}'),
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
    });
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
  Map<String, dynamic>? friendProfile;

  @override
  void initState() {
    super.initState();
    ShowFriendProfile();
  }

  Future<void> ShowFriendProfile() async {
    DocumentSnapshot doc =
        await _firestore.collection('user').doc(widget.friendUid).get();
    if (doc.exists) {
      setState(() {
        friendProfile = doc.data() as Map<String, dynamic>?;
      });
    }
  }

  Future<void> removeFriend(String friendUid) async {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    DocumentReference currentUserDoc =
        _firestore.collection('user').doc(currentUserUid);
    DocumentReference friendUserDoc =
        _firestore.collection('user').doc(friendUid);

    await _firestore.runTransaction((transaction) async {
      transaction.update(currentUserDoc, {
        'friendsList': FieldValue.arrayRemove([friendUid])
      });
      transaction.update(friendUserDoc, {
        'friendsList': FieldValue.arrayRemove([currentUserUid])
      });
    });
    Navigator.of(context).pop();
  }

  Widget _ProfilePic(String imageurl) {
    return ClipOval(
        clipper: MyClipper(),
        child: Container(
            width: 300,
            height: 300,
            child: Image.network(imageurl, fit: BoxFit.fill)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
            Text(friendProfile != null ? friendProfile!['name'] : 'loading..'),
      ),
      body: friendProfile == null
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    _ProfilePic(friendProfile!['imageURL']),
                    const SizedBox(height: 40),
                    ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text('이름'),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(friendProfile!['name']),
                        )),
                    ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text('성별'),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(friendProfile!['gender']),
                        )),
                    ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text('전공'),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(friendProfile!['major']),
                        )),
                    ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text('생년월일'),
                        ),
                        title: Text(friendProfile!['birth'])),
                    ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text('한줄소개'),
                        ),
                        title: Text(friendProfile!['status'])),
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text('UId'),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          friendProfile!['uid'],
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: friendProfile!['uid']));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('클립보드에 복사되었습니다'),
                            duration: Duration(milliseconds: 1000),
                          ));
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    friendProfile!['schedule'] != null
                        ? _TimetablePreview(List<Map<String, dynamic>>.from(
                            friendProfile!['schedule']))
                        : Container(),
                    const SizedBox(height: 40),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffFFEAC7)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text('친구를 삭제하시겠습니까?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('아니요'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('네'),
                                    onPressed: () {
                                      removeFriend(widget.friendUid);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          '친구 삭제',
                          style: TextStyle(color: Colors.grey),
                        ))
                  ],
                ),
              ),
            ),
    );
  }

  Widget _TimetablePreview(List<Map<String, dynamic>> schedule) {
    List<EventModel> eventList = [];
    schedule.forEach((element) {
      eventList.add(EventModel(
        title: element['content'],
        columnIndex: element['time']['column'],
        rowIndex: element['time']['row'],
        color: Color(element['color']),
      ));
    });

    return AbsorbPointer(
      absorbing: true,
      child: Container(
        width: 400,
        height: 500,
        child: TimeSchedulerTable(
          cellHeight: 40,
          cellWidth: 56,
          columnTitles: const ["Mon", "Tue", "Wed", "Thur", "Fri"],
          rowTitles: const [
            '1교시',
            '2교시',
            '3교시',
            '4교시',
            '5교시',
            '6교시',
            '7교시',
            '8교시',
            '9교시',
            '10교시',
          ],
          eventList: eventList,
          isBack: false,
          eventAlert: EventAlert(
            alertTextController: TextEditingController(),
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, 300, 300);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}
