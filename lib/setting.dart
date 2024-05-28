import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

import 'package:moappproject/timetable.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  XFile? image;

  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _priceController = TextEditingController();

  String imagePath ='/Users/sw/Desktop/MAD/finalterm/assets/logo.png';
  
  String? name;
  String? description;
  String? price;

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

  Widget _buildPhotoArea() {
    return image != null
        ? ClipOval(
          child: Container(
            height: 300,
            child: Image.file(File(image!.path)),
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
    return Scaffold(
      appBar: AppBar( 
        title: const Text('Edit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // name=_nameController.text;
              // price=_priceController.text;
              // description=_descriptionController.text;

              // File file = File(imagePath);
              // await FirebaseStorage.instance.ref('/${FirebaseAuth.instance.currentUser?.uid}_${name}_$price.jpeg').putFile(file);
              // Reference tmpref= FirebaseStorage.instance.ref().child('/${FirebaseAuth.instance.currentUser?.uid}_${name}_$price.jpeg');
              // String _url= await tmpref.getDownloadURL();

              // await FirebaseFirestore.instance.collection('product').add(<String, dynamic>{
              //   'name': name,
              //   'price': num.parse(price!),
              //   'url': _url,
              //   'description': description,
              //   'uid': FirebaseAuth.instance.currentUser!.uid,
              //   'created_time': FieldValue.serverTimestamp(),
              //   'modified_time': FieldValue.serverTimestamp(),
              //   'likeList': List<String>.from([])
              // });


                    // name: document.data()['name'] as String,
                    // gender: document.data()['gender'] as String,
                    // major: document.data()['major'] as String,
                    // birth: document.data()['birth'] as String,
                    // status: document.data()['status'] as String,
                    // uid: document.data()['uid'] as String,
                    // imageURL: document.data()['imageURL'] as String,
                    // tagCheck: List.from(document.data()['tagCheck']),
                    // isGonggang: document.data()['isGonggang'] as bool,
                    // schedule: document.data()['schedule'] as String,
                    // friendList: List.from(document.data()['friendList']),
                    // groupList: List.from(document.data()['groupList'])

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
              _buildPhotoArea(),
              const SizedBox(height: 20),
              _buildButton(),
              const SizedBox(height: 20),
              ListTile(
                leading: const Text('이름'),
                title:TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '이름',
                  ),
                ),
              ),
              ListTile(
                leading: Text('성별'),
                title:TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '남 / 여',
                  ),
                ),
              ),
              ListTile(
                leading: Text('전공'),
                title:TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'ex) 전산전자공학부',
                  ),
                ),
              ),
              ListTile(
                leading: Text('생년월일'),
                title:TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'ex) 2000.03.30',
                  ),
                ),
              ),
              ListTile(
                leading: Text('한 줄 소개'),
                title:TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '나는 공강을 사랑합니다.',
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
  }
}