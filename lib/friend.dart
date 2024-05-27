import 'package:flutter/material.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ), 
      body: SingleChildScrollView(child: Column(
        children: [
          Text('내 친구'),
          Container(child: TextButton(
            child:Text('친구 추가'),
            onPressed:(){
              debugPrint('친구 추가 버튼 클릭');
            }
          ),),
          Divider(
            indent: 25,
            endIndent: 25,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(color: Color(0xffCCF9EE))),
          SizedBox(
            height: 30,
          ),
          Text('그룹'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              TextButton(
                child:Text('그룹 추가'),
                onPressed:(){
                  debugPrint('그룹 추가 버튼 클릭');
                }
              ),
              TextButton(
                child:Text('그룹 생성'),
                onPressed:(){
                  debugPrint('그룹 생성 버튼 클릭');
                }
              ),
            ]
          ),
          Divider(
            indent: 25,
            endIndent: 25,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              width: 300,
              height: 600,
              decoration: BoxDecoration(color: Color(0xffCCF9EE))),
          SizedBox(height: 30),
        ]
      ))
    );
  }
}
