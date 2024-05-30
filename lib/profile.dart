import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moappproject/setting.dart';

import 'dart:io';

import 'app_state.dart';

import 'package:provider/provider.dart';

import 'package:moappproject/timetable.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  XFile? image;
  _ProfilePageState();
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
    return Consumer<ApplicationState>(
      builder: (context,appState, _){
        return Scaffold(
          appBar: AppBar( 
            title: const Text('Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
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

                  // debugPrint('$name / $price / $description / ${image!.path} / $_url');
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingPage(),
                    ),
                  );
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
                    title: Text(appState.currentuser!.name)
                  ),
                  ListTile(
                    leading: Text('성별'),
                    title: Text(appState.currentuser!.gender)
                  ),
                  ListTile(
                    leading: Text('전공'),
                    title: Text(appState.currentuser!.major)
                  ),
                  ListTile(
                    leading: Text('생년월일'),
                    title: Text(appState.currentuser!.birth)
                  ),
                  ListTile(
                    leading: Text('한 줄 소개'),
                    title: Text(appState.currentuser!.status)
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
    );
  }
}