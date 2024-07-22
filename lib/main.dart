import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:perfect_corp_homework/injection_container.dart';
import 'package:perfect_corp_homework/view/screens/download.dart';
import 'package:perfect_corp_homework/view/screens/history.dart';
import 'package:perfect_corp_homework/view_model/download_view_model.dart';

void _createThumbnailDir() async {
  Directory thumbnailDir = Directory(
      '${(await getApplicationDocumentsDirectory()).path}/thumbnails/');
  thumbnailDir.createSync(recursive: true);
}

void main() async {
  setup();
  WidgetsFlutterBinding.ensureInitialized();
  _createThumbnailDir();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      locator<DownloadViewModel>().pauseAllDownload();
    } else if (state == AppLifecycleState.resumed) {
      locator<DownloadViewModel>().resumeAllPausedDownload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          color: Colors.black,
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
