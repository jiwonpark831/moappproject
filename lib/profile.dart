import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moappproject/login.dart';
import 'package:moappproject/setting.dart';
import 'package:moappproject/timetable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_scheduler_table/time_scheduler_table.dart';
import 'package:flutter/services.dart';

import 'app_state.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  XFile? image;
  _ProfilePageState();

  final ImagePicker imagePicker = ImagePicker();

  Widget _buildPhotoArea(String imagepath) {
    return ClipOval(
      clipper:MyClipper(),
      child: Container( width:300, height: 300,child: Image.network(imagepath,fit:BoxFit.cover)));
       
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingPage(),
                        ));
                  },
                  icon: Icon(Icons.edit))
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
                child: Column(
              children: [
                const SizedBox(height: 30),
                _buildPhotoArea(appState.currentuser!.imageURL),
                const SizedBox(height: 20),
                ListTile(
                    leading: const Text('이름'),
                    title: Text(appState.currentuser!.name)),
                ListTile(
                    leading: Text('성별'),
                    title: Text(appState.currentuser!.gender)),
                ListTile(
                    leading: Text('전공'),
                    title: Text(appState.currentuser!.major)),
                ListTile(
                    leading: Text('생년월일'),
                    title: Text(appState.currentuser!.birth)),
                ListTile(
                    leading: Text('한 줄 소개'),
                    title: Text(appState.currentuser!.status)),
                ListTile(
                    leading: Text('UID'),
                    title: Text(appState.currentuser!.uid,style: TextStyle(fontSize: 15)),
                    trailing: IconButton(icon:Icon(Icons.copy),onPressed:((){Clipboard.setData(ClipboardData(text: appState.currentuser!.uid)); })),
                  ),
                    
                Container(
                  child: _TimetablePreview(appState.currentuser!.schedule),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                  child: Text('로그아웃'),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                )
              ],
            )),
          ));
    });
  }

  Widget _TimetablePreview(List<dynamic> schedule) {
    List<EventModel> eventList = [];
    schedule.forEach((element) {
      eventList.add(EventModel(
        title: element['content'],
        columnIndex: element['time']['column'],
        rowIndex: element['time']['row'],
        color: Color(element['color']),
      ));
    });

    return AbsorbPointer(absorbing: true, child:
    Container(
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
    ));
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
