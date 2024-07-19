import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'image_lightbox.dart';

class History extends StatefulWidget {
  const History({super.key});

  static const String id = '/history';

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History>
    with AutomaticKeepAliveClientMixin<History> {
  late List<FileImage> imageFiles;
  bool isLoading = true;

  Future<void> getImageFiles() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    Directory dir = await getApplicationDocumentsDirectory();
    var fileList = await dir.list().toList();
    imageFiles = fileList.whereType<File>().map((file) {
      return FileImage(file);
    }).toList();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getImageFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'HTTP downloader',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              cacheExtent: 999,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 1.0),
              itemCount: imageFiles.length,
              itemBuilder: (context, index) {
                String imageType = imageFiles[index].file.path.split('.').last;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageLightBox(
                          initIndex: index,
                          imageFiles: imageFiles,
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (context) => Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              width: double.infinity,
                              padding: const EdgeInsets.all(32.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: imageFiles[index],
                                      fit: BoxFit.contain,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0, horizontal: 8.0),
                                      child: Row(
                                        // padding: const EdgeInsets.all(8.0),
                                        children: [
                                          const Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.file_copy,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15.0,
                                          ),
                                          Expanded(
                                            flex: 9,
                                            child: Text(
                                              imageFiles[index]
                                                  .file
                                                  .path
                                                  .split('/')
                                                  .last,
                                              style: const TextStyle(
                                                  color: Colors.black54),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        imageFiles[index].file.uri.toString(),
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                  },
                  child: Container(
                    child: Image(
                      image: imageFiles[index],
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) return child;
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 100),
                          switchOutCurve: Curves.easeInOut,
                          child: frame != null
                              ? child
                              : const CircularProgressIndicator(
                                  color: Colors.black54,
                                ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
