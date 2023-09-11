import 'package:flutter/material.dart';
import 'package:tracko/database.dart';

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
  final List<Color> myColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];
  final List<Color> myColorsOpa = [
    Colors.red.withOpacity(0.5),
    Colors.pink.withOpacity(0.5),
    Colors.purple.withOpacity(0.5),
    Colors.deepPurple.withOpacity(0.5),
    Colors.indigo.withOpacity(0.5),
    Colors.blue.withOpacity(0.5),
    Colors.lightBlue.withOpacity(0.5),
    Colors.cyan.withOpacity(0.5),
    Colors.teal.withOpacity(0.5),
    Colors.green.withOpacity(0.5),
    Colors.lightGreen.withOpacity(0.5),
    Colors.lime.withOpacity(0.5),
    Colors.yellow.withOpacity(0.5),
    Colors.amber.withOpacity(0.5),
    Colors.orange.withOpacity(0.5),
    Colors.deepOrange.withOpacity(0.5),
    Colors.brown.withOpacity(0.5),
    Colors.grey.withOpacity(0.5),
    Colors.blueGrey.withOpacity(0.5),
  ];
  // TrackoDatabase db = TrackoDatabase();
  TextEditingController itemInput = TextEditingController();
  // print(widb.labelList);
  late List<String> items;
  late String selectedItem;
  late int selectedItemIndex;
  late List<int> labelsState;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Item"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
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

            // Expanded(
            //   child: GridView.builder(
            //     gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 5,
            //         childAspectRatio: 1.5,
            //         mainAxisSpacing: 8,
            //         crossAxisSpacing: 8),
            //     // scrollDirection: Axis.horizontal,
            //     itemCount: items.length,
            //     itemBuilder: (context, index) {
            //       return GestureDetector(
            //         onTap: () {
            //           setState(() {
            //             labelsState[index] = 1 - labelsState[index];
            //           });
            //         },
            //         child: Container(
            //           height: 20,
            //           width: 20,
            //           padding: EdgeInsets.all(5),
            //           decoration: BoxDecoration(
            //               // height: 10
            //               color: labelsState[index] == 0
            //                   ? myColorsOpa[index]
            //                   : Colors.grey.withOpacity(0.5),
            //               borderRadius: BorderRadius.circular(20)),
            //           child: Row(
            //             children: [
            //               Image(
            //                 image:
            //                     AssetImage('assets/images/label_image_2.png'),
            //                 height: 20,
            //                 width: 20,
            //                 color: Colors.black,
            //               ),
            //               SizedBox(
            //                 width: 5,
            //               ),
            //               Text(items[index])
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),

            // DropdownButton<String>(
            //   value: selectedItem1,
            //   onChanged: (String? newValue) {
            //     setState(() {
            //       selectedItem1 = newValue!;
            //     });
            //   },
            //   items: dropdownItems1
            //       .map<DropdownMenuItem<String>>((String item) {
            //     return DropdownMenuItem<String>(
            //       value: item,
            //       child: Text(item),
            //     );
            //   }).toList(),
            // ),
            TextField(
              controller: itemInput,
              onChanged: (value) {
                setState(() {});
              },
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  hintText: 'Search...',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black, width: 2))),
            ),

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
      ),
    );
  }
}
