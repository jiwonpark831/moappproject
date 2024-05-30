import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late bool isGongGang = false;

  late bool tag1 = false;
  late bool tag2 = false;
  late bool tag3 = false;
  late bool tag4 = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context,appState, _){
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
                      isGongGang = !isGongGang;
                      appState.toggleGonggang();
                    });
                  },
                  child: Text(
                    isGongGang ? '공강' : '수업중',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Color(isGongGang ? 0xff000000 : 0xffA0A0A0),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(isGongGang ? 0xffFFD795 : 0xffFFEAC7),
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
                      tag1 = !tag1;
                    });
                  },
                  child: Text(
                    "공부해요",
                    style: TextStyle(
                      color: Color(tag1 ? 0xffFFFFFF : 0xff000000),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(tag1 ? 0xffA0A0A0 : 0xffF6F6F6),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      tag2 = !tag2;
                    });
                  },
                  child: Text(
                    "밥먹어요",
                    style: TextStyle(
                      color: Color(tag2 ? 0xffFFFFFF : 0xff000000),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(tag2 ? 0xffA0A0A0 : 0xffF6F6F6),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      tag3 = !tag3;
                    });
                  },
                  child: Text(
                    "한한해요",
                    style: TextStyle(
                      color: Color(tag3 ? 0xffFFFFFF : 0xff000000),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(tag3 ? 0xffA0A0A0 : 0xffF6F6F6),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      tag4 = !tag4;
                    });
                  },
                  child: Text(
                    "일단만나요",
                    style: TextStyle(
                      color: Color(tag4 ? 0xffFFFFFF : 0xff000000),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(tag4 ? 0xffA0A0A0 : 0xffF6F6F6),
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
                width: 300,
                height: 100,
                decoration: BoxDecoration(color: Color(0xffCCF9EE))),
            SizedBox(height: 30),
            Divider(
              indent: 25,
              endIndent: 25,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '새로운 공강메이트를 찾아보세요!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
                SizedBox(
                  width: 15,
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.filter_list))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(color: Color(0xffFEDFAA))),
          ]),
        );
      }
    );
  }
}
