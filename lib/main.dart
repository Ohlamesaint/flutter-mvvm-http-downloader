import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:perfect_corp_homework/native/features/download/data/model/download_model.dart';

import 'native/features/download/data/backend_service/controller/mapper/service_result_to_raw_response.dart';

void _isolateMain(RootIsolateToken rootIsolateToken) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
}

void main() async {
  // setUp background isolate
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  Isolate.spawn(_isolateMain, rootIsolateToken);

  // set methodChannel request
  WidgetsFlutterBinding.ensureInitialized();

  EventChannel eventChannel =
      const EventChannel('http_downloader/download/progress');
  EventChannel finishedEventChannel =
      const EventChannel('http_downloader/download/finished');
  MethodChannel methodChannel = const MethodChannel('http_downloader/download');

  Stream progress = eventChannel.receiveBroadcastStream();
  progress.listen((data) {
    log(data);
  });

  Stream finished = finishedEventChannel.receiveBroadcastStream();
  finished.listen((data) {
    log(data);
  });

  MethodChannelResponse methodChannelResponse =
      MethodChannelResponse<DownloadModel>.fromJson(
          jsonDecode(await methodChannel.invokeMethod('createDownload', {
            'urlString': 'https://photock.jp/photo/download/photo0000-4753.jpg'
          })),
          DownloadModel.fromJson);
  log("StatusCode: ${methodChannelResponse.statusCode}");
  DownloadModel downloadModel = methodChannelResponse.data;
  log(downloadModel.downloadID);
  log(downloadModel.url);
  log(downloadModel.totalLength.toString());
  log(downloadModel.currentLength.toString());
  log(downloadModel.status.toString());
  log(downloadModel.fileEntity.temporaryImagePath.toString());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
