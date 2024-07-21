import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/download_view_model.dart';
import 'download_card.dart';

class DownloadList extends StatelessWidget {
  const DownloadList({
    super.key,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [
            Colors.white,
            Colors.transparent,
            Colors.transparent,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.015, 0.975, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstOut,
      child: Provider.of<DownloadViewModel>(context).downloads.isEmpty
          ? const Center(child: Text('No Download'))
          : SizedBox(
              // height: 100.0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount:
                      Provider.of<DownloadViewModel>(context, listen: false)
                          .downloads
                          .length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10.0,
                    );
                  },
                  itemBuilder: (context, index) {
                    return index == 0
                        ? AnimatedSlide(
                            offset: Offset.fromDirection(1, 0),
                            duration: const Duration(seconds: 1),
                            curve: Curves.bounceIn,
                            child: DownloadCard(
                                downloadEntity: Provider.of<DownloadViewModel>(
                                        context,
                                        listen: false)
                                    .downloads[index]),
                          )
                        : DownloadCard(
                            downloadEntity: Provider.of<DownloadViewModel>(
                                    context,
                                    listen: false)
                                .downloads[index]);
                  },
                ),
              ),
            ),
    );
  }
}
