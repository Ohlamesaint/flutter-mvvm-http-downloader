import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:perfect_corp_homework/view/components/image_detail_card.dart';
import 'package:perfect_corp_homework/view_model/history_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../injection_container.dart';
import 'image_lightbox.dart';

class History extends StatefulWidget {
  const History({super.key});

  static const String id = '/history';

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History>
    with AutomaticKeepAliveClientMixin<History> {
  @override
  void initState() {
    locator<HistoryViewModel>().fetchThumbnails();
    locator<HistoryViewModel>().fetchImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: locator<HistoryViewModel>(),
      builder: (context, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'HTTP downloader',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Provider.of<HistoryViewModel>(context).isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                addAutomaticKeepAlives: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 0.5,
                  crossAxisSpacing: 0.5,
                ),
                itemCount:
                    Provider.of<HistoryViewModel>(context).thumbnails.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageLightBox(
                            initIndex: index,
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (context) => Hero(
                                tag: 'preview',
                                child: ChangeNotifierProvider.value(
                                  value: locator<HistoryViewModel>(),
                                  builder: (context, child) => ImageDetailCard(
                                      index: index,
                                      filename:
                                          Provider.of<HistoryViewModel>(context)
                                              .thumbnails[index]
                                              .file
                                              .path
                                              .split('/')
                                              .last
                                              .split('.')[0]),
                                ),
                              ));
                    },
                    child: Image(
                      filterQuality: FilterQuality.none,
                      image: Provider.of<HistoryViewModel>(context)
                          .thumbnails[index],
                      width: double.infinity,
                      height: double.infinity,
                      // alignment: Alignment.center,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        } else {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            switchOutCurve: Curves.easeInOut,
                            child: frame != null
                                ? child
                                : const SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 6,
                                      color: Colors.black54,
                                    ),
                                  ),
                          );
                        }
                      },
                      fit: BoxFit.fill,
                    ),
                  );
                },
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
