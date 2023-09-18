import 'package:flutter/material.dart';
import 'package:tracko/edit_item.dart';
import 'package:tracko/focus_page.dart';
import 'package:tracko/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();

  // open a box
  await Hive.openBox("Tracko_Database");
  // Hive.deleteBoxFromDisk("Tracko_Database");
  runApp(const Tracko());
}

class Tracko extends StatefulWidget {
  const Tracko({super.key});

  @override
  State<Tracko> createState() => _TrackoState();
}

class _TrackoState extends State<Tracko> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: HomePage(),
      // home: EditItem(itemIndex: 0),
      home: FocusItemListPage(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        // useMaterial3: true,
      ),
      // darkTheme: ThemeData.dark(),
    );
  }
}
