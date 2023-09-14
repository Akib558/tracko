import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tracko/database.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tracko/edit_item.dart';
import 'package:tracko/add_item.dart';
import 'package:tracko/all_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TrackoDatabase db = TrackoDatabase();
  TextEditingController itemInput = TextEditingController();
  // String itemInputButtonCharachter = "HELLO";
  final FocusNode _focusNode = FocusNode();

  final _myBox = Hive.box("Tracko_Database");

  List habitsList = [
    [
      "eat",
      false,
      [1],
      []
    ],
    [
      "sleep",
      false,
      [1],
      []
    ],
    [
      "walk",
      false,
      [1],
      []
    ],
    [
      "read",
      false,
      [1],
      []
    ],
  ];

  Map<String, int> labels = {
    "All": 1,
    "Daily": 2,
    "Weekly": 3,
    "Focus": 4,
    "Dailway": 5,
    "Weeklysdfs": 6,
    "Focussd": 7
  };

  // List<String> labels = [
  //   "All",
  //   "Daily",
  //   "Weekly",
  //   "Focus",
  //   "Dailway",
  //   "Weeklysdfs",
  //   "Focussd"
  // ];

  Map<String, int> folders = {
    "Today": 1,
    "Inbox": 2,
    "Tags": 3,
  };

  List<int> showItem = [];
  int val = 0;

  List<dynamic> label = [];
  List<dynamic> folder = [];

  // List<int> lableListInititalizer = [
  //   for (int i = 0; i < habitsList.length; i++) 0
  // ];
  late List<int> labelsState;

  // List labelsList = [];
  // List foldersList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(jsonEncode(labels));
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
      labels = Map<String, int>.from(_myBox.get("Labels"));
    }

    if (_myBox.get("Folders") == null) {
      _myBox.put("Folders", folders);
    } else {
      folders = Map<String, int>.from(_myBox.get("Folders"));
    }
    // int len = habitsList.length;
    // int len = 10;

    // if (_myBox.get("LabelsList") == null) {
    //   // String temp = jsonEncode(labelsList);
    //   labelsList.add(List<int>.filled(len, 1));
    //   // labelsList[labels[0]] = List<int>.filled(habitsList.length, 1);
    //   for (var i = 1; i < labels.length; i++) {
    //     labelsList.add(List<int>.filled(len, 0));
    //     // labelsList[labels[i]] = List<int>.filled(habitsList.length, 0);
    //   }
    //   // print(temp);
    //   _myBox.put("LabelsList", labelsList);
    //   // _myBox.put("LabelsList", jsonEncode(labelsList) as String);
    // } else {
    //   labelsList = _myBox.get("LabelsList");
    // }

    // if (_myBox.get("FoldersList") == null) {
    //   // String temp = jsonEncode(labelsList);
    //   foldersList.add(List<int>.filled(len, 1));
    //   ;
    //   // labelsList[labels[0]] = List<int>.filled(habitsList.length, 1);
    //   for (var i = 1; i < labels.length; i++) {
    //     foldersList.add(List<int>.filled(len, 0));
    //     // labelsList[labels[i]] = List<int>.filled(habitsList.length, 0);
    //   }
    //   // print(temp);
    //   _myBox.put("LabelsList", labelsList);
    //   // _myBox.put("LabelsList", jsonEncode(labelsList) as String);
    // } else {
    //   foldersList = _myBox.get("LabelsList");
    // }

    // // showItem = labelsList[labels[0]];
    // showItem = labelsList[0];

    val = 0;

    print(habitsList);
    print(labels);
    // habitsList.removeLast();
    // _myBox.put("HabitList", habitsList);
    // _focusNode.addListener(() {
    //   if (_focusNode.hasFocus) {
    //     _showBottomDialog(context);
    //   }
    // });
    List<String> pp = labels.keys.toList();
    List<int> pp2 = labels.values.toList();
    label = List<List<dynamic>>.generate(
        pp.length, (index) => [pp[index], pp2[index]]);

    folder = folders.keys.toList();

    labelsState = List<int>.filled(labels.length, 0);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
    itemInput.dispose();
  }

  bool addItemStateButton = true;
  bool showLabels = false;
  int currentlyShowing = 1;
  bool folderClicked = false;
  bool labelClicked = false;
  List<Widget> generateWidgetList() {
    // Convert the list of items to a list of widgets
    return label.map((item) {
      return ListTile(
        title: Text(item),
      );
    }).toList();
  }

  // bool pp = true;
  @override
  Widget build(BuildContext context) {
    print("showItem: " + "$showItem");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Tracko"),
        ),
        drawer: Drawer(
          // width: 200,
          child: ListView.builder(
            itemCount: folders.length,
            itemBuilder: (context, index) {
              if (index < 2) {
                return Text(folder[index]);
              } else if (index == 2) {
                String selectedItem = label[0][0];
                return ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(folder[2]),
                  children: label.map((item) {
                    return Container(
                        padding: EdgeInsets.all(2),
                        child: GestureDetector(
                          onTap: () {
                            print("In draweer");
                            // print(labelsList[index]);
                            print(index);
                            // print(labelsList);
                            setState(() {
                              // val = index;
                              // showItem = labelsList[index];
                              currentlyShowing = labels[item[0]] as int;
                              print("CLICKED");
                              Navigator.of(context).pop();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Image(
                                  image: AssetImage(
                                      'assets/images/label_image_2.png'),
                                  height: 20,
                                  width: 20,
                                  color: Colors.blue,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(item[0])
                              ],
                            ),
                          ),
                        ));
                  }).toList(),
                  // [
                  //   Text("1"),
                  //   Text("1"),

                  //   Text("1"),

                  // Container(
                  //   child: ListView.builder(
                  //     itemCount: label.length,
                  //     itemBuilder: (context, index) {
                  //       return Text(label[index]);
                  //     },
                  //   ),
                  // )
                  // Padding(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: DropdownButton<String>(
                  //     value: selectedItem,
                  //     items: label.map((String item) {
                  //       return DropdownMenuItem<String>(
                  //         value: item,
                  //         child: Text(item),
                  //       );
                  //     }).toList(),
                  //     onChanged: (String? newValue) {
                  //       setState(() {
                  //         selectedItem = newValue ?? '';
                  //       });
                  //     },
                  //   ),
                  // ),
                  // ],
                );
              } else {
                return Container();
              }
            },
          ),
        ),
        body: Stack(children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: habitsList.length,
                      itemBuilder: (context, index) {
                        if (habitsList[index][2].contains(currentlyShowing)) {
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
                                              habitsList[index][1]
                                                  ? false
                                                  : true;
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
          // if (addItemState)
          //   Positioned(
          //     left: 0,
          //     right: 0,
          //     bottom: 0,
          //     // top: 0,
          //     child: Container(
          //         color: Colors.grey,
          //         // height: ,
          //         // width: 50,
          //         child: inputFieldForLabel()),
          //   ),
          if (addItemStateButton)
            Positioned(
                // left: 0,
                right: 30,
                bottom: 30,
                // top: 0,
                child: Material(
                  elevation: 5.0, // Adjust the elevation value as needed
                  shape: CircleBorder(), // Use CircleBorder to make it circular
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle, // Make it circular
                      // border: Border.all(
                      //   color: Colors.blue, // Border color
                      //   width: 2.0, // Border width
                      // ),
                    ),
                    child: InkWell(
                      // Handle button tap here
                      onTap: () {
                        // Add your button's tap action here
                        // addItemState = !addItemState;
                        // _focusNode.unfocus();
                        _showBottomDialog(context);
                        setState(() {});
                      },
                      borderRadius: BorderRadius.circular(
                          50.0), // Half the width/height to make it circular
                      child: Container(
                          width: 70.0, // Adjust the button size
                          height: 70.0,
                          // Adjust the button size
                          alignment: Alignment.center,
                          child: Icon(Icons.add)),
                    ),
                  ),
                )
                // GestureDetector(
                //   onTap: () {
                //   },
                //   child: Container(
                //     decoration: BoxDecoration(
                //         color: Colors.green,
                //         borderRadius: BorderRadius.circular(100)),
                //     child: Card(
                //       elevation: 3,
                //       color: Color.fromARGB(0, 255, 255, 255),
                //       child: Container(
                //           height: 50,
                //           width: 50,
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [Icon(Icons.add)],
                //           )),
                //     ),
                //   ),
                // ),
                )
        ]),
      ),
    );
  }

  void updateParentPage() {
    setState(() {});
  }

  void _showBottomDialog(BuildContext context) async {
    setState(() {
      addItemStateButton = false;
      updateParentPage();
    });
    // show
    // showdia
    await showModalBottomSheet(
      isScrollControlled: true,
      // constraints: BoxConstraints(minHeight: 150),
      backgroundColor: const Color.fromARGB(0, 244, 67, 54),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return Container(
            // padding: EdgeInsets.all(16.0),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Column(children: [
                      if (showLabels)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            // height: 80,
                            child: Wrap(
                              // direction: Axis.vertical,
                              direction: Axis.horizontal,

                              alignment: WrapAlignment.start,
                              spacing: 8.0, // Adjust the spacing between items
                              runSpacing:
                                  8.0, // Adjust the spacing between rows
                              children: List.generate(
                                labelsState
                                    .length, // Replace with the number of items you want to display
                                (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        labelsState[index] =
                                            1 - labelsState[index];
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: labelsState[index] == 0
                                              ? myColorsOpa[index]
                                              : Colors.grey.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Row(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                'assets/images/label_image_2.png'),
                                            height: 20,
                                            width: 20,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(label[index][0])
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                            controller: itemInput,
                            onChanged: (value) {
                              // if (showLabelSuggestions) {
                              //   setState(() {
                              //     showLabelSuggestions = false;
                              //   });
                              // }
                            },
                            autofocus: true,
                            // focusNode: _focusNode,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              hintText: 'Search...',
                            )),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showLabels = !showLabels;
                                  //showInbox = false;
                                });
                              },
                              child: Image(
                                image: AssetImage(
                                    'assets/images/label_image_2.png'),
                                height: 30,
                                width: 30,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              Icons.folder,
                              size: 30,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              habitsList.add([
                                itemInput.text,
                                false,
                                [1],
                                []
                              ]);
                              for (var i = 0; i < labelsState.length; i++) {
                                if (labelsState[i] == 1) {
                                  habitsList.last[2].add(labels[label[i][0]]);
                                }
                              }
                              // labelsList[0][habitsList.length - 1] = 1;
                              _myBox.put("Labels", labels);
                              _myBox.put("HabitList", habitsList);
                              // _myBox.put("LabelsList", labelsList);

                              setState(() {
                                // widget.updateParentCallBack
                                labelsState =
                                    List<int>.filled(labelsState.length, 0);
                                itemInput.clear();
                                updateParentPage();
                              });
                            },
                            child: Icon(
                              Icons.arrow_circle_right_outlined,
                              size: 40,
                            ),
                          ),
                        ],
                      )
                    ]),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
    setState(() {
      updateParentPage();
      addItemStateButton = true;
    });
  }
}
