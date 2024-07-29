import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../injection_container.dart';
import '../../view_model/history_view_model.dart';

class ImageDetailCardView extends StatefulWidget {
  const ImageDetailCardView(
      {super.key, required this.index, required this.filename});
  final int index;
  final String filename;

  @override
  State<ImageDetailCardView> createState() => _ImageDetailCardViewState();
}

class _ImageDetailCardViewState extends State<ImageDetailCardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        locator<HistoryViewModel>().fetchImageMetaData(widget.filename);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: locator<HistoryViewModel>(),
      builder: (context, child) => Container(
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(32.0),
        child: Provider.of<HistoryViewModel>(context).isFetchingImageMetaData
            ? const CircularProgressIndicator()
            : Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: Provider.of<HistoryViewModel>(context)
                          .thumbnails[widget.index],
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 20.0),
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
                              Provider.of<HistoryViewModel>(context)
                                  .thumbnails[widget.index]
                                  .file
                                  .path
                                  .split('/')
                                  .last,
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 20.0),
                      child: Row(
                        // padding: const EdgeInsets.all(8.0),
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.link,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                          Expanded(
                            flex: 9,
                            child: Text(
                              Provider.of<HistoryViewModel>(context)
                                  .imageDetail
                                  .imageUrl,
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
