import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tracko/database.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tracko/edit_item.dart';
import 'package:tracko/add_item.dart';
import 'package:tracko/all_colors.dart';
import 'package:tracko/focus_page.dart';
import 'dart:math';
// import 'package:tracko/math_functions.dart';
import 'package:tracko/math_functions.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TrackoDatabase db = TrackoDatabase();
  TextEditingController itemInput = TextEditingController();
  TextEditingController addFolderController = TextEditingController();

  // String itemInputButtonCharachter = "HELLO";
  final FocusNode _focusNode = FocusNode();

  final _myBox = Hive.box("Tracko_Database");

  List habitsList = [
    [
      "eat",
      false,
      [1],
      [2],
      "",
      [
        false,
        0,
        0,
        null,
        null,
      ]
    ],
    [
      "sleep",
      false,
      [1],
      [2],
      "",
      [
        false,
        0,
        0,
        null,
        null,
      ]
    ],
    [
      "walk",
      false,
      [1],
      [2],
      "",
      [
        false,
        0,
        0,
        null,
        null,
      ]
    ],
    [
      "read", //0
      false, //1
      [1], //2
      [2], //3
      "", //4
      [
        false,
        0,
        0,
        null,
        null,
      ] //5
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
  late List<int> foldersState;

  Map<String, List> historyList = {
    "demo": [],
  };

  // List labelsList = [];
  // List foldersList = [];
  // print(_myBox.get("HistoryList"));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // print(jsonEncode(labels));
    // _myBox.delete("HabitList");
    // _myBox.delete("LabelsList");
    // _myBox.delete("Labels");
    // _myBox.delete("HistoryList");
    print(_myBox.get("HistoryList"));

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
    // print(_myBox.get("HistoryList"));
    if (_myBox.get("HistoryList") == null) {
      historyList[todaysDateFormatted()] = habitsList;
      historyList["start_date"] = [todaysDateFormatted()];
      print("initializing historyList");
      _myBox.put("HistoryList", historyList);
      print("ok: ");
      print(_myBox.get("HistoryList"));
    } else {
      print("historyList inititalized");
      historyList = Map<String, List>.from(_myBox.get("HistoryList"));
      if (historyList[todaysDateFormatted()] == null) {
        historyList[todaysDateFormatted()] = habitsList;
        print(
            "habit list retrieving from historyList is null so storing habitslist");
      } else {
        print("habitsList get from historyList");
        habitsList = historyList[todaysDateFormatted()] as List;
      }
    }

    print("historyList: " + "$historyList");

    val = 0;

    print(habitsList);
    print(labels);

    List<String> pp = labels.keys.toList();
    List<int> pp2 = labels.values.toList();
    label = List<List<dynamic>>.generate(
        pp.length, (index) => [pp[index], pp2[index]]);

    // folder = folders.keys.toList();

    pp = folders.keys.toList();
    pp2 = folders.values.toList();
    folder = List<List<dynamic>>.generate(
        pp.length, (index) => [pp[index], pp2[index]]);

    labelsState = List<int>.filled(labels.length, 0);
    foldersState = List<int>.filled(folders.length, 0);

    // print(loadHeatMap(historyList));
    List demo = historyList["start_date"] as List;
    startDate = demo[0] as String;
    // if (_myBox.get("focus") == 1) {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (BuildContext context) => FocusItemListPage(),
    //     ),
    //   );
    // }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
    itemInput.dispose();
  }

  bool addItemStateButton = true;
  bool showLabels = false;
  bool showFolders = false;
  int currentlyShowing = 1;
  bool folderClicked = false;
  bool labelClicked = true;
  bool isExpanded = false;

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  List<Widget> generateWidgetList() {
    // Convert the list of items to a list of widgets
    return label.map((item) {
      return ListTile(
        title: Text(item),
      );
    }).toList();
  }

  void updateHabit() {
    historyList[todaysDateFormatted()] = habitsList;
    print(historyList);
    // print(_myBox.get("HistoryList"));
    _myBox.put("HabitList", habitsList);
    _myBox.put("HistoryList", historyList);
  }

  late String startDate;

  void subInit() {
    print(_myBox.get("HistoryList"));

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

    if (_myBox.get("HistoryList") == null) {
      historyList[todaysDateFormatted()] = habitsList;
      historyList["start_date"] = [todaysDateFormatted()];
      print("initializing historyList inside subInit");
      _myBox.put("HistoryList", historyList);
    } else {
      print("historyList inititalized inside subInit");
      historyList = Map<String, List>.from(_myBox.get("HistoryList"));
      if (historyList[todaysDateFormatted()] == null) {
        historyList[todaysDateFormatted()] = habitsList;
        print(
            "habit list retrieving from historyList is null so storing habitslist inside subInit");
      } else {
        print("habitsList get from historyList inside subInit");
        habitsList = historyList[todaysDateFormatted()] as List;
      }
    }

    print(_myBox.get("HistoryList"));

    List<String> pp = labels.keys.toList();
    List<int> pp2 = labels.values.toList();
    label = List<List<dynamic>>.generate(
        pp.length, (index) => [pp[index], pp2[index]]);

    // folder = folders.keys.toList();

    pp = folders.keys.toList();
    pp2 = folders.values.toList();
    folder = List<List<dynamic>>.generate(
        pp.length, (index) => [pp[index], pp2[index]]);

    labelsState = List<int>.filled(labels.length, 0);
    foldersState = List<int>.filled(folders.length, 0);
  }

  void _showAlertDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            // title: Text("THIS IS AN ALERT DIALOG"),
            content: Container(
              width: double.maxFinite,
              height: 300, // Set a fixed height or adjust as needed
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: folders.length, // Replace with your item count
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text("${folder[index][0]}"),
                          // Add more widgets or customize as needed
                        );
                      },
                    ),
                  ),
                  TextField(
                    controller: addFolderController,
                    autofocus: true,
                    onChanged: (value) {},
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  addFolderController.clear();
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  folders[addFolderController.text] = generateUniqueRandom();
                  _myBox.put("Folders", folders);
                  subInit();
                  setState(() {});
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Save'),
              )
            ],
          );
        });
    // print(_myBox.get("HistoryList"));
  }

  void _showConfirmationForDeletion(
      BuildContext context, String name, int itemVal, bool isFolder) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          int pos = 2;
          if (isFolder) pos = 3;
          return AlertDialog(
            scrollable: true,
            title: Text("Delete this item ?"),
            // content: Container(
            //   width: double.maxFinite,
            //   height: 300, // Set a fixed height or adjust as needed
            //   child: Column(
            //     children: [
            //       Expanded(
            //         child: ListView.builder(
            //           itemCount: folders.length, // Replace with your item count
            //           itemBuilder: (BuildContext context, int index) {
            //             return ListTile(
            //               title: Text("${folder[index][0]}"),
            //               // Add more widgets or customize as needed
            //             );
            //           },
            //         ),
            //       ),
            //       TextField(
            //         controller: addFolderController,
            //         autofocus: true,
            //         onChanged: (value) {},
            //       )
            //     ],
            //   ),
            // ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // addFolderController.clear();
                  if (isFolder) {
                    folders.remove(name);
                    for (var i = 0; i < habitsList.length; i++) {
                      habitsList[i][3]
                          .removeWhere((element) => element == itemVal);
                    }
                    _myBox.put("Folders", folders);
                  } else {
                    labels.remove(name);
                    for (var i = 0; i < habitsList.length; i++) {
                      habitsList[i][2]
                          .removeWhere((element) => element == itemVal);
                    }
                    _myBox.put("Labels", labels);
                  }
                  _myBox.put("HabitList", habitsList);
                  updateHabit();
                  subInit();

                  // print("${name} => ${itemVal}");
                  setState(() {});

                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('No'),
              )
            ],
          );
        });
    print(_myBox.get("HistoryList"));
  }

  String folderName = "Inbox";
  bool showHeatMap = false;
  // bool pp = true;
  @override
  Widget build(BuildContext context) {
    // print("showItem: " + "$showItem");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(folderName),
          actions: [
            GestureDetector(
              onTap: () {
                // showHeatMap = !showHeatMap;
                _myBox.put("focus", 1);
                // return FocusItemListPage();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => FocusItemListPage(),
                  ),
                );
                // setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.center_focus_strong),
              ),
            ),
            GestureDetector(
              onTap: () {
                showHeatMap = !showHeatMap;
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.show_chart_rounded),
              ),
            )
          ],
        ),
        drawer: Drawer(
          // width: 200,
          // key: UniqueKey(),
          child: Stack(children: [
            Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: folders.length,
                    itemBuilder: (context, index) {
                      if (index < 2) {
                        return GestureDetector(
                          onTap: () {
                            // print("In draweer");
                            // print(labelsList[index]);
                            // print(index);
                            // print(labelsList);
                            setState(() {
                              // val = index;
                              // showItem = labelsList[index];
                              // currentlyShowing = labels[item[0]] as int;
                              folderClicked = true;
                              labelClicked = false;

                              //print(folder[index][1]);

                              currentlyShowing = folder[index][1];

                              //print("CLICKED");
                              Navigator.of(context).pop();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(7),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Image(
                                  image: AssetImage(
                                      "assets/images/${folder[index][0]}.png"),
                                  height: 20,
                                  width: 20,
                                  // color: Colors.blue,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  folder[index][0],
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        );
                      } else if (index == 2) {
                        // String selectedItem = label[0][0];
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                isExpanded = !isExpanded;
                                setState(() {});
                              },
                              child: Container(
                                color: isExpanded ? Colors.grey[300] : null,
                                padding: EdgeInsets.all(2.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(7),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Image(
                                            image: AssetImage(
                                                'assets/images/label_image_2.png'),
                                            height: 20,
                                            width: 20,
                                            // color: Colors.blue,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            folder[index][0],
                                            style: TextStyle(fontSize: 16),
                                          )
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      isExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            isExpanded
                                ? Column(
                                    children: label.map((item) {
                                      return Container(
                                          padding: EdgeInsets.all(2),
                                          child: GestureDetector(
                                            onLongPress: () {
                                              _showConfirmationForDeletion(
                                                  context,
                                                  item[0],
                                                  item[1],
                                                  false);
                                              setState(() {});
                                            },
                                            onTap: () {
                                              //print("In draweer");
                                              // //print(labelsList[index]);
                                              //print(index);
                                              // //print(labelsList);
                                              setState(() {
                                                // val = index;
                                                // showItem = labelsList[index];
                                                labelClicked = true;
                                                folderClicked = false;
                                                currentlyShowing =
                                                    labels[item[0]] as int;

                                                folderName = item[0];
                                                //print("CLICKED");
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30),
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
                                                    SizedBox(
                                                        width: 180,
                                                        // width: double.maxFinite,

                                                        // color:
                                                        child: Text(item[0]))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ));
                                    }).toList(),
                                  )
                                : Container()
                          ],
                        );
                      } else {
                        return GestureDetector(
                          onLongPress: () {
                            _showConfirmationForDeletion(context,
                                folder[index][0], folder[index][1], true);
                            // setState(() {});
                            setState(() {});
                          },
                          onTap: () {
                            //print("In draweer");
                            // //print(labelsList[index]);
                            //print(index);
                            // //print(labelsList);
                            setState(() {
                              // val = index;
                              // showItem = labelsList[index];
                              // currentlyShowing = labels[item[0]] as int;
                              folderClicked = true;
                              labelClicked = false;

                              //print(folder[index][1]);

                              currentlyShowing = folder[index][1];
                              folderName = folder[index][0];

                              //print("CLICKED");
                              Navigator.of(context).pop();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(7),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Image(
                                  image: AssetImage("assets/images/Folder.png"),
                                  height: 20,
                                  width: 20,
                                  // color: Colors.blue,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  // width: 60,
                                  child: Text(
                                    folder[index][0],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                // Spacer(),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                child: GestureDetector(
                  onTap: () {
                    // folders[""]
                    _showAlertDialog(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Add List",
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
        body: Stack(children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                showHeatMap
                    ? Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(9),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)),
                        // padding: const EdgeInsets.only(top: 25, bottom: 25),
                        child: HeatMap(
                          startDate: createDateTimeObject(startDate),
                          endDate: DateTime.now().add(Duration(days: 0)),
                          datasets: loadHeatMap(historyList),
                          colorMode: ColorMode.color,
                          defaultColor: Colors.white,
                          textColor: Colors.black,
                          showColorTip: false,
                          showText: true,
                          scrollable: true,
                          size: 20,
                          colorsets: const {
                            1: Color.fromARGB(20, 2, 179, 8),
                            2: Color.fromARGB(40, 2, 179, 8),
                            3: Color.fromARGB(60, 2, 179, 8),
                            4: Color.fromARGB(80, 2, 179, 8),
                            5: Color.fromARGB(100, 2, 179, 8),
                            6: Color.fromARGB(120, 2, 179, 8),
                            7: Color.fromARGB(150, 2, 179, 8),
                            8: Color.fromARGB(180, 2, 179, 8),
                            9: Color.fromARGB(220, 2, 179, 8),
                            10: Color.fromARGB(255, 2, 179, 8),
                          },
                          onClick: (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(value.toString())));
                          },
                        ),
                      )
                    : Container(),
                Expanded(
                  child: ListView.builder(
                      itemCount: habitsList.length,
                      itemBuilder: (context, index) {
                        // TODO ---------------------------------------------
                        // TODO ---------------------------------------------
                        if ((labelClicked &&
                                habitsList[index][2]
                                    .contains(currentlyShowing)) ||
                            (folderClicked &&
                                habitsList[index][3]
                                    .contains(currentlyShowing))) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Slidable(
                              endActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  // settings option
                                  SlidableAction(
                                    onPressed: (value) {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditItem(
                                                          itemIndex: index)))
                                          .then((value) => setState(() {
                                                subInit();
                                              }));
                                    },
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
                                        updateHabit();
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
                                          updateHabit();
                                          _myBox.put("HabitList", habitsList);
                                          print(_myBox.get("HistoryList"));
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
                ),
              ],
            ),
          ),

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
                    ),
                    child: InkWell(
                      // Handle button tap here
                      onTap: () {
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
                ))
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
                      showFolders
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                // height: 80,
                                child: Wrap(
                                  // direction: Axis.vertical,
                                  direction: Axis.horizontal,

                                  alignment: WrapAlignment.start,
                                  spacing:
                                      8.0, // Adjust the spacing between items
                                  runSpacing:
                                      8.0, // Adjust the spacing between rows
                                  children: List.generate(
                                    foldersState
                                        .length, // Replace with the number of items you want to display
                                    (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            foldersState[index] =
                                                1 - foldersState[index];
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: foldersState[index] == 0
                                                  ? myColorsOpa[index]
                                                  : Colors.grey
                                                      .withOpacity(0.5),
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
                                              Text(folder[index][0])
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      showLabels
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                // height: 80,
                                child: Wrap(
                                  // direction: Axis.vertical,
                                  direction: Axis.horizontal,

                                  alignment: WrapAlignment.start,
                                  spacing:
                                      8.0, // Adjust the spacing between items
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
                                                  : Colors.grey
                                                      .withOpacity(0.5),
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
                            )
                          : Container(),
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
                                  showFolders = false;
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
                          GestureDetector(
                            onTap: () {
                              showLabels = false;
                              showFolders = !showFolders;
                              //print("SHOW FOLDER CLICKED");
                              setState(() {});
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.folder,
                                size: 30,
                              ),
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              habitsList.add([
                                itemInput.text,
                                false,
                                [1],
                                [2],
                                "",
                                [
                                  false,
                                  0,
                                  0,
                                  null,
                                  null,
                                ]
                              ]);
                              for (var i = 0; i < labelsState.length; i++) {
                                if (labelsState[i] == 1) {
                                  habitsList.last[2].add(labels[label[i][0]]);
                                }
                              }

                              // print("Currently Showing: "+"$currentlyShowing");
                              // habitsList
                              for (var i = 0; i < foldersState.length; i++) {
                                if (foldersState[i] == 1) {
                                  habitsList.last[3].add(folders[folder[i][0]]);
                                }
                              }
                              habitsList.last[3].add(currentlyShowing);

                              // labelsList[0][habitsList.length - 1] = 1;
                              _myBox.put("Labels", labels);
                              _myBox.put("Folders", folders);
                              _myBox.put("HabitList", habitsList);
                              updateHabit();
                              // _myBox.put("LabelsList", labelsList);

                              setState(() {
                                // widget.updateParentCallBack
                                labelsState =
                                    List<int>.filled(labelsState.length, 0);
                                foldersState =
                                    List<int>.filled(foldersState.length, 0);
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
    print(_myBox.get("HistoryList"));
  }
}
