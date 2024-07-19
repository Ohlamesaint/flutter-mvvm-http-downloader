import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageLightBox extends StatefulWidget {
  const ImageLightBox(
      {super.key, required this.initIndex, required this.imageFiles});

  final int initIndex;
  final List<FileImage> imageFiles;
  @override
  State<ImageLightBox> createState() => _ImageLightBoxState();
}

class _ImageLightBoxState extends State<ImageLightBox> {
  late PageController pageController;
  late double startPos;
  late DateTime startTime;

  @override
  void initState() {
    pageController = PageController(
      initialPage: widget.initIndex,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'HTTP downloader',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Transform.translate(
        offset: const Offset(0, -25),
        child: PageView.builder(
          controller: pageController,
          itemCount: widget.imageFiles.length,
          itemBuilder: (context, index) => PhotoView(
            loadingBuilder: (context, imageChunkEvent) {
              return Container(
                width: double.infinity,
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              );
            },
            imageProvider: widget.imageFiles[index],
          ),
        ),
      ),
    );
  }
}
