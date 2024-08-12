import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/download/download_data/download_data_bloc.dart';
import 'download_card_view.dart';

class DownloadListView extends StatefulWidget {
  const DownloadListView({
    super.key,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;

  @override
  State<DownloadListView> createState() => _DownloadListViewState();
}

class _DownloadListViewState extends State<DownloadListView> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey animatedListGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadDataBloc, DownloadDataState>(
      builder: (context, state) => ShaderMask(
        shaderCallback: createShader,
        blendMode: BlendMode.dstOut,
        child: state.downloadList.isEmpty
            ? const Center(
                child: Text('No Download'),
              )
            : ListView.builder(
                key: animatedListGlobalKey,
                controller: widget._scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: state.downloadList.length,
                itemBuilder: (context, index) {
                  return DownloadCardView(
                    downloadEntity: state
                        .downloadList[state.downloadList.length - index - 1],
                  );
                },
              ),
      ),
    );
  }

  Shader createShader(Rect bounds) {
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
  }

  Animatable<Offset> listAddAnimation = Tween<Offset>(
    begin: const Offset(1.0, 0.0),
    end: Offset.zero,
  ).chain(
    CurveTween(
      curve: Curves.decelerate,
    ),
  );
}
