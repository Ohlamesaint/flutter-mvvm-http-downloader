import 'package:flutter/material.dart';
import 'package:perfect_corp_homework/injection_container.dart';
import 'package:perfect_corp_homework/view/components/bottom_navigation_button.dart';
import 'package:perfect_corp_homework/view/components/download_card.dart';
import 'package:perfect_corp_homework/view_model/download_view_model.dart';
import 'package:provider/provider.dart';

import '../components/download_list.dart';

class Download extends StatelessWidget {
  static const String id = '/';
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  // final downloadViewModel = locator<DownloadViewModel>();
  final myFocusNode = FocusNode();

  Download({super.key});

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
          children: [
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
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
                      onChanged: (value) =>
                          Provider.of<DownloadViewModel>(context, listen: false)
                              .urlInputChanged(value),
                      decoration: const InputDecoration(
                        hintText: 'Input your URL ...',
                        hintStyle: TextStyle(color: Colors.black45),
                      ),
                    ),
                    Visibility(
                        visible: Provider.of<DownloadViewModel>(context,
                                listen: false)
                            .needInput,
                        child: Text(
                          'URL cannot be empty',
                          style: TextStyle(
                              color: Colors.red.shade900,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        )),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton.icon(
                      onPressed:
                          Provider.of<DownloadViewModel>(context).url.isEmpty
                              ? Provider.of<DownloadViewModel>(context)
                                  .showNeedInput
                              : () {
                                  _controller.clear();
                                  // trigger view model to fetchImage
                                  Provider.of<DownloadViewModel>(context,
                                          listen: false)
                                      .fetchImage();
                                },
                      style: const ButtonStyle(
                        elevation: WidgetStatePropertyAll(3.0),
                        backgroundColor:
                            WidgetStatePropertyAll<Color>(Colors.black54),
                        iconColor: WidgetStatePropertyAll<Color>(Colors.white),
                      ),
                      icon: const Icon(Icons.download),
                      label: const Text(
                        'Download',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: DownloadList(scrollController: _scrollController),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(child: BottomNavigationButton()),
          ],
        ),
      ),
    );
  }
}
