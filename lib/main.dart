import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracko/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tracko/pages/auth_page.dart';
import 'package:tracko/provider/focus_provider.dart';
import 'package:tracko/core/theme/app_theme.dart';

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
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FocusProvider()),
      ],
      child: MaterialApp(
        title: 'Tracko',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AuthPage(),
      ),
    );
  }
}
