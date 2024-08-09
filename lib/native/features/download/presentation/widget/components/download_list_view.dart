import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../features/download/domain/entity/download_entity.dart';
import '../../bloc/download/download_control/download_control_bloc.dart';
import '../../bloc/download/download_data/download_data_bloc.dart';
import '../../view_model/download_view_model.dart';
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
            : AnimatedList(
                key: animatedListGlobalKey,
                controller: widget._scrollController,
                padding: const EdgeInsets.all(16.0),
                initialItemCount: state.downloadList.length,
                itemBuilder: (context, index, animation) {
                  return SlideTransition(
                    position: animation.drive(
                      listAddAnimation,
                    ),
                    child: DownloadCardView(
                      downloadEntity: state.downloadList[index],
                    ),
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
