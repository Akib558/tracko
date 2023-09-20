import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tracko/home_page.dart';
import 'dart:async';
import 'package:tracko/math_functions.dart';

import 'package:tracko/all_colors.dart';

class FocusItemListPage extends StatefulWidget {
  const FocusItemListPage({super.key});

  @override
  State<FocusItemListPage> createState() => _FocusItemListPageState();
}

class _FocusItemListPageState extends State<FocusItemListPage> {
  final _myBox = Hive.box("Tracko_Database");

  late FixedExtentScrollController _controller1;
  late FixedExtentScrollController _controller2;

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

  Map<String, List> historyList = {
    "demo": [],
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
  int counter = 0;
  late Timer timer;
  // List labelsList = [];
  // List foldersList = [];
  bool prevStateStart = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // print(jsonEncode(labels));
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

    if (prevStateStart) {
      for (int i = 0; i < habitsList.length; i++) {
        if (habitsList[i][5][0]) {
          habitStarted(i, false);
        }
      }
    }

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

    // timer = Timer.periodic(Duration(seconds: 1), (timer) {
    //   setState(() {
    //     counter++;
    //   });
    // });
    _controller1 = FixedExtentScrollController();
    _controller2 = FixedExtentScrollController();
    // if (_myBox.get("focus") == 0) {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (BuildContext context) => HomePage(),
    //     ),
    //   );
    // }
  }

  bool playStatus = false;

  // double returnPercentValue() {
  //   return min(counter / 30, 1.0);
  // }

  String formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);

    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    int remainingSeconds = duration.inSeconds % 60;

    String formattedDuration = '';

    if (days > 0) {
      formattedDuration += '$days days ';
    }

    if (hours > 0) {
      formattedDuration += '$hours' + 'h';
    }

    if (minutes > 0) {
      formattedDuration += '$minutes' + 'm';
    }

    formattedDuration += '$remainingSeconds' + 's';

    return formattedDuration.trim(); // Remove any trailing spaces
  }

  void habitStarted(int index, bool fromBuilder) {
    var startTime = DateTime.now();
    // print(startTime);
    if (fromBuilder) {
      setState(() {
        habitsList[index][5][0] = !habitsList[index][5][0];
      });
    }

    var elapsedTime = habitsList[index][5][1];
    if (habitsList[index][5][3] != null &&
        !fromBuilder &&
        habitsList[index][5][0] == true) {
      var lastFinishedTime = habitsList[index][5][3];
      elapsedTime += (startTime.second - lastFinishedTime.second) +
          60 * (startTime.minute - lastFinishedTime.minute) +
          60 * 60 * (startTime.hour - lastFinishedTime.hour);
    }

    if (habitsList[index][5][0] == true) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        print(timer);
        if (habitsList[index][5][0] == false) {
          _myBox.put("HabitList", habitsList);
          timer.cancel();
          return;
        }
        setState(() {
          updateParentPage();
          var currentTime = DateTime.now();
          habitsList[index][5][3] = DateTime.now();
          habitsList[index][5][1] = elapsedTime +
              (currentTime.second - startTime.second) +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);
          _myBox.put("HabitList", habitsList);
        });
      });
    }
  }

  double statusRatio(int a, int b) {
    if (a == 0 && b == 0) {
      return 0;
    }
    double aa = a / b;
    print("$a, $b, $aa");
    return min(a / b, 1);
  }

  Widget hourVal(int hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        child: Center(
          child: Text(
            hours.toString(),
            style: TextStyle(
              fontSize: 20,
              // color: Colors.white,
              color: Colors.black,

              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget minVal(int mins) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        child: Center(
          child: Text(
            mins < 10 ? '0' + mins.toString() : mins.toString(),
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void updateParentPage() {
    setState(() {});
  }

  void _showFocusEditDialog(BuildContext context, int itemIndex) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // scrollable: true,
            // title: Text("THIS IS AN ALERT DIALOG"),
            // backgroundColor: Colors.red,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // color: Colors.red,
                  height: 120,
                  width: 70,
                  child: ListWheelScrollView.useDelegate(
                    controller: _controller1,
                    itemExtent: 50,
                    perspective: 0.000001,
                    diameterRatio: 1.2,
                    physics: FixedExtentScrollPhysics(),
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 100,
                      builder: (context, index) {
                        return hourVal(index);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  // width: 15,
                  child: Text(
                    "hrs",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // am or pm
                Container(
                  height: 120,
                  width: 70,
                  child: ListWheelScrollView.useDelegate(
                    controller: _controller2,
                    itemExtent: 50,
                    perspective: 0.01,
                    diameterRatio: 5,
                    physics: FixedExtentScrollPhysics(),
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 60,
                      builder: (context, index) {
                        return minVal(index);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  // width: 15,
                  child: Text(
                    "mins",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // addFolderController.clear();
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  habitsList[itemIndex][5][2] =
                      3600 * _controller1.selectedItem.toInt() +
                          60 * _controller2.selectedItem.toInt();
                  updateParentPage();
                  _myBox.put("HabitList", habitsList);
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Save'),
              )
            ],
          );
        });
  }

  String ratioValue(int index) {
    return ((statusRatio(habitsList[index][5][1], habitsList[index][5][2]) *
                    10000)
                .toInt() /
            100)
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Focus"),
        actions: [
          GestureDetector(
            onTap: () {
              // showHeatMap = !showHeatMap;
              _myBox.put("focus", 0);
              // return FocusItemListPage();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HomePage(),
                ),
              );
              // setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.center_focus_strong),
            ),
          ),
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: habitsList.length,
          itemBuilder: (context, index) {
            String remain = formatDuration(habitsList[index][5][1]);
            String goal = formatDuration(habitsList[index][5][2]);

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // color: Colors.red,
                      height: 60,
                      width: 60,
                      child: Stack(children: [
                        CircularPercentIndicator(
                          radius: 30,
                          lineWidth: 10,
                          progressColor: myColors[(statusRatio(
                                      habitsList[index][5][1],
                                      habitsList[index][5][2]) *
                                  10)
                              .toInt()],
                          percent: statusRatio(
                              habitsList[index][5][1], habitsList[index][5][2]),
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              // habitsList[index][5][0] =
                              //     !habitsList[index][5][0];
                              // setState(() {});
                              habitStarted(index, true);
                              setState(() {});
                            },
                            child: Icon(
                              !habitsList[index][5][0]
                                  ? Icons.play_arrow
                                  : Icons.pause,
                              size: 30,
                            ),
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habitsList[index][0],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text("${remain}/${goal}=${ratioValue(index)}%")
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          _showFocusEditDialog(context, index);
                        },
                        child: Icon(Icons.settings))
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
