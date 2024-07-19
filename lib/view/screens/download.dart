import 'package:flutter/material.dart';
import 'package:perfect_corp_homework/injection_container.dart';
import 'package:perfect_corp_homework/model/repository/download_repository_impl.dart';
import 'package:perfect_corp_homework/view/components/bottom_navigation_button.dart';
import 'package:perfect_corp_homework/view/components/download_card.dart';
import 'package:perfect_corp_homework/view_model/download_view_model.dart';
import 'package:perfect_corp_homework/view/screens/history.dart';
import 'package:perfect_corp_homework/view_model/history_view_model.dart';
import 'package:provider/provider.dart';

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
                    TextButton(
                      onPressed: Provider.of<DownloadViewModel>(context,
                                  listen: false)
                              .url
                              .isEmpty
                          ? Provider.of<DownloadViewModel>(context,
                                  listen: false)
                              .showNeedInput
                          : () {
                              _controller.clear();

                              // trigger view model to fetchImage
                              Provider.of<DownloadViewModel>(context,
                                      listen: false)
                                  .fetchImage();

                              // Scroll to the bottom
                              Future.delayed(const Duration(microseconds: 300))
                                  .then((_) {
                                if (_scrollController.hasClients) {
                                  _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent *
                                        1.1,
                                    duration: const Duration(milliseconds: 800),
                                    curve: Curves.fastOutSlowIn,
                                  );
                                }
                              });
                            },
                      style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll<Color>(Colors.black54),
                      ),
                      child: const Text(
                        'Download',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Expanded(
                      child: Provider.of<DownloadViewModel>(context)
                              .downloads
                              .isEmpty
                          ? const Center(child: Text('No Download'))
                          : SizedBox(
                              height: 100.0,
                              child: ListView.separated(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(16.0),
                                itemCount:
                                    Provider.of<DownloadViewModel>(context)
                                        .downloads
                                        .length,
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 10.0,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return DownloadCard(
                                      downloadEntity:
                                          Provider.of<DownloadViewModel>(
                                                  context)
                                              .downloads[index]);
                                },
                              ),
                            ),
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
