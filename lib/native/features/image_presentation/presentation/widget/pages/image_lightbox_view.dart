import 'package:flutter/material.dart';
import 'package:perfect_corp_homework/native/features/image_presentation/view_model/history_view_model.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../../../../../injection_container.dart';

class ImageLightBoxView extends StatefulWidget {
  const ImageLightBoxView({super.key, required this.initIndex});

  final int initIndex;
  @override
  State<ImageLightBoxView> createState() => _ImageLightBoxViewState();
}

class _ImageLightBoxViewState extends State<ImageLightBoxView> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(
      initialPage: widget.initIndex,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: locator<HistoryViewModel>(),
      builder: (context, child) => Scaffold(
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
            itemCount:
                Provider.of<HistoryViewModel>(context).imageModels.length,
            itemBuilder: (context, index) => PhotoView(
              loadingBuilder: (context, imageChunkEvent) {
                return Container(
                  width: double.infinity,
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                );
              },
              imageProvider: FileImage(Provider.of<HistoryViewModel>(context)
                  .imageModels[index]
                  .originImage),
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      ),
    );
  }
}
