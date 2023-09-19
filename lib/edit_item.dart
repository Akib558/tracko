import 'package:flutter/material.dart';
import 'package:tracko/database.dart';
import 'package:tracko/all_colors.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tracko/math_functions.dart';

class EditItem extends StatefulWidget {
  final int itemIndex;
  const EditItem({
    super.key,
    required this.itemIndex,
  });

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  // TrackoDatabase db = TrackoDatabase();

  final _myBox = Hive.box("Tracko_Database");

  TextEditingController itemInput = TextEditingController();
  TextEditingController itemDetailsInput = TextEditingController();
  TextEditingController labelInput = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  FocusNode itemDetailsFocusNode = FocusNode();
  // print(widb.labelList);

  late List habitsList = [];
  late Map<String, int> labels = {};
  late Map<String, int> folders = {};

  late List<String> items;
  late String selectedItem;
  late int selectedItemIndex;
  late List<int> labelsState;
  late List<int> foldersState;

  List<dynamic> label = [];
  List<dynamic> folder = [];

  int labelAddState = 0;
  bool showLabelSuggestions = true;

  late int itemIndex = 0;
  // late Map<String, dynamic> labelsList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("inside editItem");
    print(_myBox.get("HabitList"));
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

    print(habitsList);

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

    itemIndex = widget.itemIndex;

    itemInput.text = habitsList[itemIndex][0];
    itemDetailsInput.text = habitsList[itemIndex][4];
  }

  bool bottomPanelShow = true;

  bool anyLabelIsSelectedForRemove() {
    for (int i = 0; i < labelsState.length; i++) {
      if (labelsState[i] == 1) {
        return true;
      }
    }
    return false;
  }

  void subInit() {
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

    itemIndex = widget.itemIndex;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
    itemInput.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Item"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Stack(children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FocusTraversalGroup(
                  child: Column(
                children: <Widget>[
                  TextField(
                    controller: itemInput,
                    onChanged: (value) {
                      habitsList[itemIndex][0] = itemInput.text;
                      print(habitsList[itemIndex][0]);
                      _myBox.put("HabitList", habitsList);
                      // setState(() {});
                    },
                    textInputAction: TextInputAction.next,
                    onSubmitted: (value) {
                      // FocusScope.of(context).requestFocus(FocusNode());
                      // FocusScope.of(context).nextFocus();
                      FocusScope.of(context).requestFocus(itemDetailsFocusNode);
                    },
                    // maxLines: null,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        hintText: 'What\'s on your mind?',
                        hintStyle: TextStyle(fontSize: 30),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2))),
                  ),
                  TextField(
                    controller: itemDetailsInput,
                    onChanged: (value) {
                      habitsList[itemIndex][4] = itemDetailsInput.text;
                      _myBox.put("HabitList", habitsList);
                      // setState(() {});
                    },
                    focusNode: itemDetailsFocusNode,
                    maxLines: null,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        hintText: "Description",
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2))),
                  ),
                ],
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        height: 30,
                        child: Wrap(
                          direction: Axis.vertical,
                          // direction: Axis.horizontal,

                          alignment: WrapAlignment.start,
                          spacing: 8.0, // Adjust the spacing between items
                          runSpacing: 8.0, // Adjust the spacing between rows
                          children: List.generate(
                            labelsState
                                .length, // Replace with the number of items you want to display
                            (index) {
                              if (habitsList[itemIndex][2]
                                  .contains(label[index][1])) {
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
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      children: [
                                        // Image(
                                        //   image: AssetImage(
                                        //       'assets/images/label_image_2.png'),
                                        //   height: 20,
                                        //   width: 20,
                                        //   color: Colors.black,
                                        // ),
                                        // SizedBox(
                                        //   width: 5,
                                        // ),
                                        Text(
                                          label[index][0],
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (anyLabelIsSelectedForRemove())
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: GestureDetector(
                      onTap: () {
                        for (var i = 0; i < labelsState.length; i++) {
                          if (labelsState[i] == 1) {
                            habitsList[itemIndex][2].removeWhere(
                                (element) => element == label[i][1]);
                          }
                        }
                        _myBox.put("HabitList", habitsList);
                        setState(() {});
                        subInit();
                      },
                      child: Text("Remove Labels")),
                ),
            ],
          ),
          if (bottomPanelShow)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                  // color: Colors.grey,
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showLabelSuggestions && labelAddState == 1)
                    Padding(
                      padding: EdgeInsets.only(left: 36),
                      child: Container(
                        color: Colors.grey[600],
                        alignment: Alignment.topLeft,
                        height: 100,
                        width: 200,
                        child: ListView.builder(
                          itemCount: label.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  labelAddState = 0;
                                  _focusNode.unfocus();
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: labelsState[index] == 0
                                        ? myColorsOpa[index]
                                        : Colors.grey.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(20)),
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
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showBottomDialog(context);
                              // labelAddState = 1 - labelAddState;
                              // if (labelAddState == 0) {
                              //   labelInput.clear();
                              //   _focusNode.unfocus();
                              //   showLabelSuggestions = true;
                              // }
                            });
                          },
                          child: Image(
                            image:
                                AssetImage('assets/images/label_image_2.png'),
                            height: 20,
                            width: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      labelAddState == 0
                          ? Icon(Icons.check_box)
                          : Expanded(
                              child: Container(
                                  height: 20,
                                  // width: double.infinity,
                                  child: inputFieldForLabel()),
                            ),
                    ],
                  ),
                ],
              )),
            )
        ]),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [],
      // ),
    );
  }

  Widget inputFieldForLabel() {
    if (labelAddState == 1) {
      FocusScope.of(context).requestFocus(_focusNode);
    } else {
      _focusNode.unfocus();
    }
    return TextField(
        controller: labelInput,
        onChanged: (value) {
          if (showLabelSuggestions) {
            setState(() {
              showLabelSuggestions = false;
            });
          }
        },
        autofocus: true,
        // focusNode: _focusNode,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: 'Search...',
          // contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          // border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(20),
          //     borderSide: BorderSide(color: Colors.black)),
          // enabledBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(20),
          //     borderSide: BorderSide(color: Colors.black)),
          // focusedBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(20),
          //     borderSide: BorderSide(color: Colors.black, width: 2))),
        ));
  }

  void updateParentPage() {
    // initState();
    setState(() {});
  }

  void _showAlertDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("THIS IS AN ALERT DIALOG"),
            actions: [
              Text("HELLO"),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Close"))
            ],
          );
        });
  }

  void _showBottomDialog(BuildContext context) async {
    setState(() {
      // addItemStateButton = false;
      updateParentPage();
      bottomPanelShow = false;
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
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            // padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (labelInput.text.isEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SizedBox(
                            height: 30,
                            child: Wrap(
                              direction: Axis.vertical,
                              // direction: Axis.horizontal,

                              alignment: WrapAlignment.start,
                              spacing: 8.0, // Adjust the spacing between items
                              runSpacing:
                                  8.0, // Adjust the spacing between rows
                              children: List.generate(
                                labelsState
                                    .length, // Replace with the number of items you want to display
                                (index) {
                                  if (!habitsList[itemIndex][2]
                                      .contains(label[index][1])) {
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
                                                BorderRadius.circular(5)),
                                        child: Row(
                                          children: [
                                            // Image(
                                            //   image: AssetImage(
                                            //       'assets/images/label_image_2.png'),
                                            //   height: 20,
                                            //   width: 20,
                                            //   color: Colors.black,
                                            // ),
                                            // SizedBox(
                                            //   width: 5,
                                            // ),
                                            Text(
                                              label[index][0],
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            // contentPadding:
                            // EdgeInsets.symmetric(vertical: -3, horizontal: 10),
                            ),
                        controller: labelInput,
                        onChanged: (value) {
                          setState(() {});
                        },
                        autofocus: true,
                        onSubmitted: (value) {},
                      ),
                    ),
                    // Spacer(),
                    GestureDetector(
                      onTap: () {
                        for (var i = 0; i < labelsState.length; i++) {
                          if (labelsState[i] == 1) {
                            habitsList[itemIndex][2].add(label[i][1]);
                          }
                        }
                        // _myBox.put("HabitList", habitsList);
                        // setState(() {});
                        // subInit();
                        if (!labelInput.text.isEmpty) {
                          labels[labelInput.text] = generateUniqueRandom();
                          habitsList[itemIndex][2].add(labels[labelInput.text]);
                        }
                        subInit();
                        updateParentPage();
                        // print(labelInput.text);
                        labelInput.clear();
                        print(labels);
                        _myBox.put("Labels", labels);
                        _myBox.put("HabitList", habitsList);
                        setState(() {});
                      },
                      child: Container(
                          child: Icon(
                        Icons.add_box,
                        size: 40,
                      )),
                    )
                  ],
                )
                // TextField(
                //     controller: itemInput,
                //     onChanged: (value) {
                //       setState(() {});
                //     },
                //     textInputAction: TextInputAction.next,
                //     onSubmitted: (value) {
                //       // FocusScope.of(context).requestFocus(FocusNode());
                //       // FocusScope.of(context).nextFocus();
                //       FocusScope.of(context).requestFocus(itemDetailsFocusNode);
                //     },
              ],
            ),
          );
        });
      },
    );
    setState(() {
      bottomPanelShow = true;
      updateParentPage();
      subInit();
      // addItemStateButton = true;
    });
  }
}
