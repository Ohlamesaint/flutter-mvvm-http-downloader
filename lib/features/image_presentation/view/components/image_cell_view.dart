import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/history_view_model.dart';

class ImageCellView extends StatelessWidget {
  const ImageCellView({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Image(
      filterQuality: FilterQuality.none,
      image: FileImage(
        Provider.of<HistoryViewModel>(context).imageModels[index].thumbnail,
      ),
      width: double.infinity,
      height: double.infinity,
      frameBuilder: frameBuilderCallback,
      fit: BoxFit.fill,
    );
  }

  /// handle image loading and animated show up
  Widget frameBuilderCallback(context, child, frame, wasSynchronouslyLoaded) {
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
  }
}
