import 'package:flutter/material.dart';
import 'package:perfect_corp_homework/flutter/injection_container.dart';
import 'package:perfect_corp_homework/flutter/features/download/view/components/bottom_navigation_button_view.dart';
import 'package:perfect_corp_homework/flutter/features/download/view_model/download_view_model.dart';
import 'package:provider/provider.dart';

import '../components/download_list_view.dart';

class DownloadView extends StatelessWidget {
  static const String id = '/';
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final myFocusNode = FocusNode();

  DownloadView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: locator<DownloadViewModel>(),
      builder: (context, child) => Scaffold(
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
          waringMessage(context),
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
    return TextField(
      focusNode: myFocusNode,
      onTapOutside: (e) {
        myFocusNode.unfocus();
      },
      controller: _controller,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.black),
      onChanged: (value) =>
          Provider.of<DownloadViewModel>(context, listen: false)
              .urlInputChanged(value),
      decoration: const InputDecoration(
        hintText: 'Input your URL ...',
        hintStyle: TextStyle(color: Colors.black45),
      ),
    );
  }

  Widget waringMessage(BuildContext context) {
    return Visibility(
      visible: Provider.of<DownloadViewModel>(context, listen: false).needInput,
      child: Text(
        'URL cannot be empty',
        style:
            TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold),
        textAlign: TextAlign.end,
      ),
    );
  }

  Widget downloadButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: Provider.of<DownloadViewModel>(context).url.isEmpty
          ? Provider.of<DownloadViewModel>(context).showNeedInput
          : () {
              _controller.clear();
              // trigger view model to fetchImage
              Provider.of<DownloadViewModel>(context, listen: false)
                  .downloadImage()
                  .then((res) {
                if (Provider.of<DownloadViewModel>(context, listen: false)
                    .showErrorDialog) {
                  showErrorDialog(context);
                }
              });
            },
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

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(
          Provider.of<DownloadViewModel>(context, listen: false)
              .dialogErrorMessage,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<DownloadViewModel>(context, listen: false)
                  .closeErrorDialog();
              Navigator.of(context).pop();
            },
            child: const Text("Ok, got it!"),
          )
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
