import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moappproject/app_state.dart';
import 'package:provider/provider.dart';
import 'package:time_scheduler_table/time_scheduler_table.dart';
import 'package:flutter/material.dart';

// List<EventModel> eventList = [
//   EventModel(
//     title: "Math",
//     columnIndex:0, // columnIndex is columnTitle's index (Monday : 0 or Day 1 : 0)
//     rowIndex: 2, // rowIndex is rowTitle's index (08:00 : 0 or Time 1 : 0)
//     color: Colors.orange,
//   ),
//   EventModel(
//     title: "History",
//     columnIndex: 1,
//     rowIndex: 5,
//     color: Colors.pink,
//   ),
//   EventModel(
//     title: "Guitar & Piano Course",
//     columnIndex: 4,
//     rowIndex: 8,
//     color: Colors.green,
//   ),
//   EventModel(
//     title: "Meeting",
//     columnIndex: 3,
//     rowIndex: 1,
//     color: Colors.deepPurple,
//   ),
//   EventModel(
//     title: "Guitar and Piano Course",
//     columnIndex: 2,
//     rowIndex: 9,
//     color: Colors.blue,
//   )
// ];
TextEditingController textController = TextEditingController();

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({super.key});

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {

  List<dynamic>? tmpuserSchedule;
  List<dynamic>? newuserSchedule=[];
  List<EventModel> userSchedule=[];

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context,appState, _) {
        tmpuserSchedule=appState.currentuser!.schedule;
        tmpuserSchedule?.forEach((element){
          userSchedule.add(
            EventModel(
              title: element['content'],
              columnIndex:element['time']['column'], // columnIndex is columnTitle's index (Monday : 0 or Day 1 : 0)
              rowIndex: element['time']['row'], // rowIndex is rowTitle's index (08:00 : 0 or Time 1 : 0)
              color: Color(element['color'])
            ),
          );
        },);
        return Scaffold(
          appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                Navigator.pop(context);
              },
            ),    
          title: const Text('TimeTable'),
          actions:[IconButton(
            icon:Icon(Icons.save),
            onPressed: (){
              debugPrint('${userSchedule}');
              userSchedule.forEach((element) {
                Map tmp={};
                tmp['content']=element.title;
                Map time={};
                time['row']=element.rowIndex;
                time['column']=element.columnIndex;
                tmp['time']=time;
                tmp['color']=element.color!.value;
                newuserSchedule!.add(tmp);
              });
              FirebaseFirestore.instance
                  .collection('user')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update(<String, dynamic>{
                'schedule' : newuserSchedule
              });
            },
          )]
          ),
          body: TimeSchedulerTable(
            cellHeight: 64,
            cellWidth: 72,
            columnTitles: const [
              // You can assign any value to columnTitles. For Example : ['Column 1','Column 2','Column 3', ...]
              "Mon",
              "Tue",
              "Wed",
              "Thur",
              "Fri"
            ],
            currentColumnTitleIndex: DateTime.now().weekday - 1,
            rowTitles: const [
              // You can assign any value to rowTitles. For Example : ['Row 1','Row 2','Row 3', ...]
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
            // title: "Event Schedule",
            // titleStyle: const TextStyle(
            //     fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            // eventTitleStyle: const TextStyle(color: Colors.white, fontSize: 8),
            isBack: false, // back button
            eventList: userSchedule,
            eventAlert: EventAlert(
              alertTextController: textController,
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
              addAlertTitle: "Add Event",
              editAlertTitle: "Edit",
              addButtonTitle: "ADD",
              deleteButtonTitle: "DELETE",
              updateButtonTitle: "UPDATE",
              hintText: "Event Name",
              textFieldEmptyValidateMessage: "Cannot be empty!",
              addOnPressed: (event) {
                // when an event added to your list
                // Your code after event added.
              },
              updateOnPressed: (event) {
                // when an event updated from your list
                // Your code after event updated.
              },
              deleteOnPressed: (event) {
                // when an event deleted from your list
                // Your code after event deleted.
              },
            ),
          )
        );
      });
  }
}
