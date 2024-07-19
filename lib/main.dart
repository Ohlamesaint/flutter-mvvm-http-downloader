import 'package:flutter/material.dart';
import 'package:perfect_corp_homework/injection_container.dart';
import 'package:perfect_corp_homework/view/screens/download.dart';
import 'package:perfect_corp_homework/view/screens/history.dart';

void main() {
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          color: Colors.black87,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      color: Colors.white,
      initialRoute: Download.id,
      routes: {
        Download.id: (context) => Download(),
        History.id: (context) => const History(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
