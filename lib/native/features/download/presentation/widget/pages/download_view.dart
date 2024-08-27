import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_corp_homework/native/features/download/presentation/bloc/url_input/url_input_bloc.dart';
import '../../bloc/download/download_control/download_control_bloc.dart';
import '../../bloc/download/download_data/download_data_bloc.dart';
import '../components/bottom_navigation_button_view.dart';

import '../components/download_list_view.dart';

class DownloadView extends StatefulWidget {
  static const String id = '/';

  DownloadView({super.key});

  @override
  State<DownloadView> createState() => _DownloadViewState();
}

class _DownloadViewState extends State<DownloadView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final myFocusNode = FocusNode();
  bool isConcurrent = true;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<DownloadDataBloc>(context).add(GetDownloadDataSource());
    return BlocListener<DownloadControlBloc, DownloadControlState>(
      listener: (context, state) {
        // control the DownloadDataBloc status
        if (state is ErrorOccur) {
          showErrorDialog(context, state.message);
        } else if (state is NoDownload) {
          BlocProvider.of<DownloadDataBloc>(context).add(StopFetchDownload());
        } else if (state is HasDownload) {
          BlocProvider.of<DownloadDataBloc>(context).add(StartFetchDownload());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'HTTP downloader',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: downloadMainBody(context),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavigationButtonView(),
      ),
    );
  }

  Widget downloadMainBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          inputTextField(context),
          verticalGap(10.0),
          downloadButton(context),
          verticalGap(10.0),
          Expanded(
            child: DownloadListView(scrollController: _scrollController),
          ),
        ],
      ),
    );
  }

  Widget inputTextField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          focusNode: myFocusNode,
          onTapOutside: (e) {
            myFocusNode.unfocus();
          },
          controller: _controller,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black),
          onChanged: (value) => BlocProvider.of<UrlInputBloc>(context).add(
            UrlInputChanged(
              _controller.text.trim(),
            ),
          ),
          decoration: const InputDecoration(
            hintText: 'Input your URL ...',
            hintStyle: TextStyle(color: Colors.black45),
          ),
        ),
        waringMessage(context),
        // waringMessage(context),
      ],
    );
  }

  Widget waringMessage(BuildContext context) {
    return BlocBuilder<UrlInputBloc, UrlInputState>(
      builder: (context, state) => Visibility(
          visible: state is UrlInputNoText,
          child: Text(
            'URL cannot be empty',
            style: TextStyle(
              color: Colors.red.shade900,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.end,
          )),
    );
  }

  Widget downloadButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: CupertinoButton(
            color: Colors.grey,
            onPressed: () => showCupertinoModalPopup(
                context: context,
                builder: (_) => Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                            child: Container(
                              height: 200.0,
                              color: Colors.transparent,
                              child: CupertinoPicker(
                                itemExtent: 30.0,
                                scrollController: FixedExtentScrollController(
                                    initialItem: isConcurrent ? 0 : 1),
                                onSelectedItemChanged: (value) {
                                  setState(() {
                                    isConcurrent = value == 0;
                                    if (!isConcurrent) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            elevation: 5.0,
                                            title: const Text(
                                              "Caution",
                                              textAlign: TextAlign.center,
                                            ),
                                            content: const Text(
                                                "Sequential download will consume more resource on your device"),
                                            actionsAlignment:
                                                MainAxisAlignment.spaceAround,
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("OK, I got it!"))
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  });
                                },
                                children: const [
                                  DropdownMenuItem(
                                      value: "Concurrent",
                                      alignment: AlignmentDirectional.center,
                                      child: Text(
                                        "Concurrent",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.black),
                                      )),
                                  DropdownMenuItem(
                                      value: "Sequential",
                                      alignment: AlignmentDirectional.center,
                                      child: Text(
                                        "Sequential",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.black),
                                      ))
                                ],
                              ),
                            ),
                          ),
                          verticalGap(5.0),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.white),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  )),
                              child: Text(
                                "Close",
                                style: TextStyle(color: Colors.blueAccent),
                              )),
                          verticalGap(30.0),
                        ],
                      ),
                    )),
            child: Text(
              "Mode: ${isConcurrent ? "Concurrent" : "Sequential"}",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(
          width: 15.0,
        ),
        Expanded(
          flex: 1,
          child: ElevatedButton.icon(
            onPressed: () => handleSubmit(context),
            style: const ButtonStyle(
                elevation: WidgetStatePropertyAll(3.0),
                backgroundColor: WidgetStatePropertyAll<Color>(Colors.black54),
                iconColor: WidgetStatePropertyAll<Color>(Colors.white),
                padding: WidgetStatePropertyAll(EdgeInsets.zero),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))))),
            // icon: const Icon(Icons.download),
            label: const Icon(
              Icons.download,
              size: 20.0,
            ),
          ),
        ),
      ],
    );
  }

  void handleSubmit(BuildContext context) {
    BlocProvider.of<UrlInputBloc>(context).add(UrlSubmitted(_controller.text));
    if (_controller.text.isNotEmpty) {
      BlocProvider.of<DownloadControlBloc>(context).add(
        CreateDownload(_controller.text.trim(), isConcurrent),
      );
      _controller.clear();
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Ok, got it!"),
          ),
        ],
      ),
    );
  }

  Widget verticalGap(double gap) {
    return SizedBox(
      height: gap,
    );
  }
}
