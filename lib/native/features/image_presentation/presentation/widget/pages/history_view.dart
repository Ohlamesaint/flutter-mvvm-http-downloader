import 'package:flutter/material.dart';
import 'package:perfect_corp_homework/native/features/image_presentation/view_model/history_view_model.dart';
import 'package:provider/provider.dart';

import '../components/image_detail_card_view.dart';

import '../../../../../constant.dart';
import '../../../../../injection_container.dart';
import '../components/image_cell_view.dart';
import 'image_lightbox_view.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  static const String id = '/history';

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView>
    with AutomaticKeepAliveClientMixin<HistoryView> {
  @override
  void initState() {
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
        body: Provider.of<HistoryViewModel>(context).isFetchingData
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                addAutomaticKeepAlives: true,
                gridDelegate: kGridAxisCount,
                itemCount:
                    Provider.of<HistoryViewModel>(context).imageModels.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => navigateToLightBox(context, index),
                    onLongPress: () => showImageDetailDialog(context, index),
                    child: ImageCellView(
                      index: index,
                    ),
                  );
                },
              ),
      ),
    );
  }

  Function navigateToLightBox = (BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageLightBoxView(
          initIndex: index,
        ),
      ),
    );
  };

  Function showImageDetailDialog = (BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => ChangeNotifierProvider.value(
        value: locator<HistoryViewModel>(),
        builder: (context, child) => ImageDetailCardView(
          imageModel: Provider.of<HistoryViewModel>(context).imageModels[index],
        ),
      ),
    );
  };

  @override
  bool get wantKeepAlive => true;
}
