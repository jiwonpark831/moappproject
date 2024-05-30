import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

import 'package:moappproject/timetable.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  XFile? image;

  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _majorController = TextEditingController();
  final _birthController = TextEditingController();
  final _statusController = TextEditingController();

  String imagePath ='/Users/sw/Desktop/MAD/finalterm/assets/logo.png';
  
  String? name;
  String? gender;
  String? major;
  String? birth;
  String? status;

  final ImagePicker imagePicker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    
    final XFile? pickedFile = await imagePicker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        image = XFile(pickedFile.path); 
        imagePath=image!.path;
      });
    }
  }

  Widget _buildPhotoArea(String imagepath) {
    return imagepath != null
        ? ClipOval(
          child: Container(
            height: 300,
            // child: Image.file(File(image!.path)),
                child: Image.network(imagepath)
          ))
        : ClipOval(child: Container(
            height: 300,
            child: Image.network('http://handong.edu/site/handong/res/img/logo.png')
          ));
  }
  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.gallery);
          },
          child: Text("갤러리"),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      return Scaffold(
        appBar: AppBar( 
          title: const Text('Edit'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                name=_nameController.text;
                gender=_genderController.text;
                major=_majorController.text;
                birth=_birthController.text;
                status=_statusController.text;

                File file = File(imagePath);
                await FirebaseStorage.instance.ref('/${FirebaseAuth.instance.currentUser?.uid}.jpeg').putFile(file);
                Reference tmpref= FirebaseStorage.instance.ref().child('/${FirebaseAuth.instance.currentUser?.uid}.jpeg');
                String _url= await tmpref.getDownloadURL();

                await FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser?.uid).update(<String, dynamic>{
                  'name': name,
                  'gender': gender,
                  'major': major,
                  'birth': birth,
                  'status': status,
                  // 'uid': FirebaseAuth.instance.currentUser!.uid,
                  'imageURL': _url,
                  // 'tagCheck': [false,false,false,false],
                  // 'isGonggang': false,
                  // 'schedule': 'this is a schedule by json format',
                  // 'friendsList': ['asdfasdf'],
                  // 'groupList': ['asdfasdf']
                });
                // debugPrint('$name / $price / $description / ${image!.path} / $_url');
                
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child:Column(
              children: [
                const SizedBox(height: 30),
                _buildPhotoArea(appState.currentuser!.imageURL),
                const SizedBox(height: 20),
                _buildButton(),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Text('이름'),
                  title:TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '이름',
                      hintText: appState.currentuser!.name,
                    ),
                  ),
                ),
                ListTile(
                  leading: Text('성별'),
                  title:TextField(
                    controller: _genderController,
                    decoration: InputDecoration(
                      labelText: '남 / 여',
                      hintText: appState.currentuser!.gender,
                    ),
                  ),
                ),
                ListTile(
                  leading: Text('전공'),
                  title:TextField(
                    controller: _majorController,
                    decoration: InputDecoration(
                      labelText: 'ex) 전산전자공학부',
                      hintText: appState.currentuser!.major,
                    ),
                  ),
                ),
                ListTile(
                  leading: Text('생년월일'),
                  title:TextField(
                    controller: _birthController,
                    decoration: InputDecoration(
                      labelText: 'ex) 2000.03.30',
                      hintText: appState.currentuser!.birth,
                    ),
                  ),
                ),
                ListTile(
                  leading: Text('한 줄 소개'),
                  title:TextField(
                    controller: _statusController,
                    decoration: InputDecoration(
                      labelText: '나는 공강을 사랑합니다.',
                      hintText: appState.currentuser!.status,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_month_outlined),
                  onPressed:() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TimeTablePage(),
                      ),
                    );
                  },
                ),
                TextButton(child: Text('log out'),
                onPressed: (){
                  debugPrint('log out');
                },)
              ],
            )
          ),
        )
      );
    });
  }
}