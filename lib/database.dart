import 'package:hive_flutter/hive_flutter.dart';

final _myBox = Hive.box("Tracko_Database");

class TrackoDatabase {
  List mainList = [];

  List<String> labelList = ["daily", "weekly", "focus", "normal"];

  void initDatabase() {
    mainList = [
      ["Eat", [], false],
      ["Sleep", [], false],
      ["Run", [], false],
    ];
    _myBox.put("MainList", mainList);
  }

  void addItem(String item, String label) {
    if (_myBox.get("MainList") == null) {
      initDatabase();
    }
    mainList.add([
      item,
      [label],
      false
    ]);
    _myBox.put("MainList", mainList);
  }

  void removeItem(int index) {
    if (_myBox.get("MainList") == null) {
      initDatabase();
    }
    mainList.removeAt(index);
    _myBox.put("MainList", mainList);
  }

  void updateItem(String item, int index) {
    if (_myBox.get("MainList") == null) {
      initDatabase();
    }
    mainList[index][0] = item;
    _myBox.put("MainList", mainList);
  }

  void addLabeltoItem(String label, int index) {
    if (_myBox.get("MainList") == null) {
      initDatabase();
    }
    mainList[index][1].add(label);
    _myBox.put("MainList", mainList);
  }

  void removeLabelfromItem(String label, int index) {
    if (_myBox.get("MainList") == null) {
      initDatabase();
    }
    mainList[index][1].removeWhere((value) => value == label);
    _myBox.put("MainList", mainList);
  }

  List<String> getLabelListForItem(int index) {
    if (_myBox.get("MainList") == null) {
      initDatabase();
    }
    return mainList[index][1];
  }

  List<String> getItemListForLabel(String label) {
    List<String> itemList = [];

    if (_myBox.get("MainList") == null) {
      initDatabase();
    }
    for (int i = 0; i < mainList.length; i++) {
      if (mainList[i][1].contains(label)) {
        itemList.add(mainList[i][0]);
      }
    }

    return itemList;
  }

  List getCheckBoxList() {
    List itemList = [];
    // print(mainList);
    if (_myBox.get("MainList") == null) {
      initDatabase();
    }
    for (int i = 0; i < mainList.length; i++) {
      itemList.add(mainList[i]);
      itemList[i].removeAt(1);
    }
    // print("Inside getCheckboxList");
    // print(itemList);
    return itemList;
  }

  void updateDatabase() {
    if (_myBox.get("MainList") == null) {
      initDatabase();
    }
    _myBox.put("MainList", mainList);
  }

  // void toggleStatus(int index) {
  //   mainList[index][2] = mainList[index][2] ? false : true;
  //   _myBox.put("MainList", mainList);
  // }
}
