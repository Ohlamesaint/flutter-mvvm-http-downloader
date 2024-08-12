import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_corp_homework/native/features/download/presentation/bloc/url_input/url_input_bloc.dart';
import '../../bloc/download/download_control/download_control_bloc.dart';
import '../../bloc/download/download_data/download_data_bloc.dart';
import '../components/bottom_navigation_button_view.dart';

import '../components/download_list_view.dart';

class DownloadView extends StatelessWidget {
  static const String id = '/';
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final myFocusNode = FocusNode();

  DownloadView({super.key});

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
    return ElevatedButton.icon(
      onPressed: () => handleSubmit(context),
      style: const ButtonStyle(
        elevation: WidgetStatePropertyAll(3.0),
        backgroundColor: WidgetStatePropertyAll<Color>(Colors.black54),
        iconColor: WidgetStatePropertyAll<Color>(Colors.white),
      ),
      icon: const Icon(Icons.download),
      label: const Text(
        'Download',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void handleSubmit(BuildContext context) {
    BlocProvider.of<UrlInputBloc>(context).add(UrlSubmitted(_controller.text));
    if (_controller.text.isNotEmpty) {
      BlocProvider.of<DownloadControlBloc>(context).add(
        CreateDownload(
          _controller.text.trim(),
        ),
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
