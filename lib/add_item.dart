import 'package:flutter/material.dart';
import 'package:tracko/database.dart';
import 'package:tracko/all_colors.dart';

class AddNewItem extends StatefulWidget {
  final List labels;
  final List habitsList;
  final List labelsList;
  const AddNewItem(
      {super.key,
      required this.labels,
      required this.habitsList,
      required this.labelsList});

  @override
  State<AddNewItem> createState() => _AddNewItemState();
}

class _AddNewItemState extends State<AddNewItem> {
  TextEditingController itemInput = TextEditingController();
  TextEditingController itemDetailsInput = TextEditingController();
  TextEditingController labelInput = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  FocusNode itemDetailsFocusNode = FocusNode();
  // print(widb.labelList);
  late List<String> items;
  late String selectedItem;
  late int selectedItemIndex;
  late List<int> labelsState;

  int labelAddState = 0;
  bool showLabelSuggestions = true;
  // late Map<String, dynamic> labelsList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // db = widget.db;
    // print(db.labelList);
    items = widget.labels as List<String>;
    selectedItem = items[0];
    selectedItemIndex = 0;
    labelsState = List<int>.filled(items.length, 0);
    // final tmpText = itemInput.text;
    // setState(() {
    //   showLabelSuggestions = tmpText.isEmpty;
    // });
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      height: 80,
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
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  labelsState[index] = 1 - labelsState[index];
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: labelsState[index] == 0
                                        ? myColorsOpa[index]
                                        : Colors.grey.withOpacity(0.5),
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
                                    Text(items[index])
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              FocusTraversalGroup(
                  child: Column(
                children: <Widget>[
                  TextField(
                    controller: itemInput,
                    onChanged: (value) {
                      setState(() {});
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
                      setState(() {});
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
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    widget.habitsList.add([itemInput.text, false]);
                    for (var i = 0; i < labelsState.length; i++) {
                      if (labelsState[i] == 1) {
                        widget.labelsList[i][widget.habitsList.length - 1] = 1;
                      }
                    }
                    widget.labelsList[0][widget.habitsList.length - 1] = 1;
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
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
                        itemCount: items.length,
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
                                      : Colors.grey.withOpacity(0.5),
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
                                  Text(items[index])
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
                            labelAddState = 1 - labelAddState;
                            if (labelAddState == 0) {
                              labelInput.clear();
                              _focusNode.unfocus();
                              showLabelSuggestions = true;
                            }
                          });
                        },
                        child: Image(
                          image: AssetImage('assets/images/label_image_2.png'),
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
        focusNode: _focusNode,
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
}
