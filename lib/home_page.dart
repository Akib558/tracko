import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tracko/database.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tracko/form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TrackoDatabase db = TrackoDatabase();
  final _myBox = Hive.box("Tracko_Database");

  List habitsList = [
    ["eat", false],
    ["sleep", false],
    ["walk", false],
    ["read", false],
  ];

  List<String> labels = [
    "All",
    "Daily",
    "Weekly",
    "Focus",
    "Dailway",
    "Weeklysdfs",
    "Focussd"
  ];

  List<int> showItem = [];
  int val = 0;

  // List<int> lableListInititalizer = [
  //   for (int i = 0; i < habitsList.length; i++) 0
  // ];

  List labelsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _myBox.delete("HabitList");
    // _myBox.delete("LabelsList");
    // _myBox.delete("Labels");
    if (_myBox.get("HabitList") == null) {
      _myBox.put("HabitList", habitsList);
    } else {
      habitsList = _myBox.get("HabitList");
    }
    if (_myBox.get("Labels") == null) {
      _myBox.put("Labels", labels);
    } else {
      labels = _myBox.get("Labels") as List<String>;
    }
    // int len = habitsList.length;
    int len = 10;

    if (_myBox.get("LabelsList") == null) {
      // String temp = jsonEncode(labelsList);
      labelsList.add(List<int>.filled(len, 1));
      // labelsList[labels[0]] = List<int>.filled(habitsList.length, 1);
      for (var i = 1; i < labels.length; i++) {
        labelsList.add(List<int>.filled(len, 0));
        // labelsList[labels[i]] = List<int>.filled(habitsList.length, 0);
      }
      // print(temp);
      _myBox.put("LabelsList", labelsList);
      // _myBox.put("LabelsList", jsonEncode(labelsList) as String);
    } else {
      labelsList = _myBox.get("LabelsList");
    }

    // showItem = labelsList[labels[0]];
    showItem = labelsList[0];

    val = 0;

    print(habitsList);
    print(labels);
    // habitsList.removeLast();
    // _myBox.put("HabitList", habitsList);
  }

  @override
  Widget build(BuildContext context) {
    print("showItem: " + "$showItem");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Tracko"),
        ),
        drawer: Drawer(
          width: 200,
          child: ListView.builder(
            itemCount: labels.length,
            itemBuilder: (context, index) {
              return Container(
                  padding: EdgeInsets.all(2),
                  child: GestureDetector(
                    onTap: () {
                      print("In draweer");
                      // print(labelsList[index]);
                      print(index);
                      print(labelsList);
                      setState(() {
                        // val = index;
                        showItem = labelsList[index];
                        Navigator.of(context).pop();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Image(
                            image:
                                AssetImage('assets/images/label_image_2.png'),
                            height: 20,
                            width: 20,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(labels[index])
                        ],
                      ),
                    ),
                  ));
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: habitsList.length,
                    itemBuilder: (context, index) {
                      if (showItem[index] == 1) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                // settings option
                                SlidableAction(
                                  onPressed: (value) {},
                                  backgroundColor: Colors.grey.shade800,
                                  icon: Icons.settings,
                                  borderRadius: BorderRadius.circular(12),
                                ),

                                // delete option
                                SlidableAction(
                                  onPressed: (value) {
                                    setState(() {
                                      habitsList.removeAt(index);
                                      _myBox.put("HabitList", habitsList);
                                    });
                                  },
                                  backgroundColor: Colors.red.shade400,
                                  icon: Icons.delete,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ],
                            ),
                            child: Container(
                              // margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 174, 206, 176),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: habitsList[index][1],
                                    onChanged: (value) {
                                      setState(() {
                                        habitsList[index][1] =
                                            habitsList[index][1] ? false : true;
                                        _myBox.put("HabitList", habitsList);
                                      });
                                    },
                                  ),
                                  Text(
                                    habitsList[index][0],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                      // return Placeholder();
                    }),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // db.addItem("hello", "");
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AddNewItem(
                  labels: labels,
                  habitsList: habitsList,
                  labelsList: labelsList);
            })).then((value) => {
                  setState(() {
                    _myBox.put("HabitList", habitsList);
                    _myBox.put("Labels", labels);
                    _myBox.put("LabelsList", labelsList);
                    // _myBox["HabitList"][0] = [1];
                  }),
                });
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
