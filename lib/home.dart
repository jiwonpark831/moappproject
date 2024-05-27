import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: TextButton(onPressed: () {}, child: Text('공강')),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () {},
              child: Text("공부해요"),
            ),
            TextButton(
              onPressed: () {},
              child: Text("밥먹어요"),
            ),
            TextButton(
              onPressed: () {},
              child: Text("한한해요"),
            ),
            TextButton(
              onPressed: () {},
              child: Text("일단만나요"),
            ),
          ],
        ),
        Divider(),
        Text('공강인 친구들이 있어요!'),
        Container(
            width: 300,
            height: 100,
            decoration: BoxDecoration(color: Color(0xffCCF9EE))),
        Divider(),
        Text('새로운 공강메이트를 찾아보세요!'),
        Row(
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
            IconButton(onPressed: () {}, icon: Icon(Icons.filter_list))
          ],
        ),
        Container(
            width: 300,
            height: 100,
            decoration: BoxDecoration(color: Color(0xffFEDFAA))),
      ]),
    );
  }
}
