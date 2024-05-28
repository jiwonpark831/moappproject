import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser {
  CurrentUser({required this.name, required this.gender, required this.major, required this.birth, required this.status, required this.uid, required this.imageURL, required this.tagCheck, required this.isGonggang,required this.schedule,required this.friendList,required this.groupList});

  final String name;
  final String gender;
  final String major;
  final String birth;
  final String status;

  final String uid;

  final String imageURL;
  final List<bool> tagCheck;
  final bool isGonggang;


  final String schedule;

  // final Timestamp createdTime;
  // final Timestamp modifiedTime;

  final List<String> friendList;
  final List<String> groupList;
}