import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:perfect_corp_homework/native/features/download/domain/repository/download_repository.dart';
import 'package:perfect_corp_homework/native/features/download/presentation/bloc/bloc_observer.dart';
import 'package:perfect_corp_homework/native/features/download/presentation/bloc/download/download_data/download_data_bloc.dart';
import 'package:perfect_corp_homework/native/injection_container.dart';
import 'package:perfect_corp_homework/native/features/download/presentation/bloc/download/download_control/download_control_bloc.dart';
import 'package:perfect_corp_homework/native/features/download/presentation/bloc/error_dialog/error_dialog_bloc.dart';
import 'package:perfect_corp_homework/native/features/download/presentation/bloc/url_input/url_input_bloc.dart';
import 'package:perfect_corp_homework/native/features/download/presentation/widget/pages/download_view.dart';
import 'package:perfect_corp_homework/native/features/image_presentation/presentation/widget/pages/history_view.dart';

void _createThumbnailDir() async {
  Directory thumbnailDir = Directory(
      '${(await getApplicationDocumentsDirectory()).path}/thumbnails/');
  thumbnailDir.createSync(recursive: true);
}

void main() async {
  Bloc.observer = AppBlocObserver();
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

    /// TODO: control download when screen on/off
    // if (state == AppLifecycleState.hidden ||
    //     state == AppLifecycleState.paused) {
    //   locator<DownloadViewModel>().pauseAllDownload();
    // } else if (state == AppLifecycleState.resumed) {
    //   locator<DownloadViewModel>().resumeAllPausedDownload();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => locator<DownloadRepository>(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DownloadDataBloc(
                RepositoryProvider.of<DownloadRepository>(context)),
          ),
          BlocProvider(
              create: (context) => DownloadControlBloc(
                  RepositoryProvider.of<DownloadRepository>(context))),
          BlocProvider(create: (context) => ErrorDialogBloc()),
          BlocProvider(create: (context) => UrlInputBloc())
        ],
        child: MaterialApp(
          title: 'HTTP downloader',
          theme: ThemeData.dark().copyWith(
            appBarTheme: const AppBarTheme(
              color: Colors.black,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
          color: Colors.white,
          initialRoute: DownloadView.id,
          routes: {
            DownloadView.id: (context) => DownloadView(),
            HistoryView.id: (context) => const HistoryView(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
