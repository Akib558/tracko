import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:tracko/edit_item.dart';
// import 'package:tracko/focus_page.dart';
import 'package:tracko/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tracko/pages/auth_page.dart';
// import 'package:tracko/pages/login_page.dart';
import 'package:tracko/provider/focus_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();

  // open a box
  await Hive.openBox("Tracko_Database");
  // Hive.deleteBoxFromDisk("Tracko_Database");
  final _myBox = Hive.box("Tracko_Database");
  if (_myBox.get("focus") == null) {
    _myBox.put("focus", 0);
  }
  runApp(const Tracko());
}

class Tracko extends StatefulWidget {
  const Tracko({super.key});

  @override
  State<Tracko> createState() => _TrackoState();
}

class _TrackoState extends State<Tracko> {
  // final _myBox = Hive.box("Tracko_Database");

  @override
  Widget build(BuildContext context) {
    //   if (_myBox.get("focus") == 1) {
    //     return MaterialApp(
    //       // home: HomePage(),
    //       // home: EditItem(itemIndex: 0),
    //       // home: LoginPage(),
    //       home: AuthPage(),
    //       // home: FocusItemListPage(),
    //       theme: ThemeData(
    //         primarySwatch: Colors.green,
    //         // useMaterial3: true,
    //       ),
    //       // darkTheme: ThemeData.dark(),
    //     );
    //   }
    //   return MaterialApp(
    //     // home: HomePage(),
    //     home: AuthPage(),
    //     // home: EditItem(itemIndex: 0),
    //     // home: FocusItemListPage(),
    //     theme: ThemeData(
    //       primarySwatch: Colors.green,
    //       // useMaterial3: true,
    //     ),
    //     // darkTheme: ThemeData.dark(),
    //   );
    // }

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FocusProvider())],
      child: MaterialApp(
        // home: HomePage(),
        // home: EditItem(itemIndex: 0),
        // home: LoginPage(),
        home: AuthPage(),
        // home: FocusItemListPage(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          // useMaterial3: true,
        ),
        // darkTheme: ThemeData.dark(),
      ),
    );
  }
}
