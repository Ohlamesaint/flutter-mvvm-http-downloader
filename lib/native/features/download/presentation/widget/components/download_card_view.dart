import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_corp_homework/native/features/download/domain/entity/download_entity.dart';

import '../../../../../features/download/presentation/widget/components/download_progress_indicator.dart';
import '../../../../../constant.dart';
import '../../bloc/download/download_control/download_control_bloc.dart';

class DownloadCardView extends StatelessWidget {
  final DownloadEntity downloadEntity;

  const DownloadCardView({
    super.key,
    required this.downloadEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
        elevation: 10.0,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 4.0),
          decoration: kDownloadCardTheme,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(
                      downloadEntity.url,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ProgressIconIndicator(
                      status: downloadEntity.status,
                      totalLength: downloadEntity.totalLength,
                      currentLength: downloadEntity.currentLength,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      // change to provider of _downloadStatus
                      onPressed: (downloadEntity.isConcurrent ||
                              downloadEntity.status != DownloadStatus.ongoing)
                          ? null
                          : () {
                              BlocProvider.of<DownloadControlBloc>(context).add(
                                PauseDownload(
                                  downloadEntity.downloadID,
                                ),
                              );
                            },
                      child: const Text(
                        'Pause',
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: (downloadEntity.isConcurrent ||
                              (downloadEntity.status != DownloadStatus.paused &&
                                  downloadEntity.status !=
                                      DownloadStatus.manualPaused))
                          ? null
                          : () {
                              BlocProvider.of<DownloadControlBloc>(context).add(
                                ResumeDownload(
                                  downloadEntity.downloadID,
                                ),
                              );
                            },
                      child: const Text('Resume'),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: downloadEntity.status !=
                                  DownloadStatus.paused &&
                              downloadEntity.status != DownloadStatus.ongoing &&
                              downloadEntity.status !=
                                  DownloadStatus.manualPaused
                          ? null
                          : () {
                              BlocProvider.of<DownloadControlBloc>(context).add(
                                CancelDownload(
                                  downloadEntity.downloadID,
                                ),
                              );
                            },
                      child: const Text('Cancel'),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
