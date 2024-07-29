import 'package:flutter/material.dart';
import 'package:perfect_corp_homework/features/download/view_model/download_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../api/api_response.dart';
import '../../../../api/service_result.dart';
import '../../../../constant.dart';
import '../../model/download_model.dart';

class DownloadCardView extends StatelessWidget {
  final DownloadModel downloadModel;

  const DownloadCardView({
    super.key,
    required this.downloadModel,
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
                      downloadModel.urlString,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ProgressIconIndicator(downloadModel: downloadModel),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      // change to provider of _downloadStatus
                      onPressed: downloadModel.status != ServiceStatus.loading
                          ? null
                          : () => Provider.of<DownloadViewModel>(context,
                                  listen: false)
                              .manualPauseDownload(downloadModel),
                      child: const Text(
                        'Pause',
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: downloadModel.status != ServiceStatus.paused &&
                              downloadModel.status != ServiceStatus.manualPaused
                          ? null
                          : () => Provider.of<DownloadViewModel>(context,
                                  listen: false)
                              .resumeDownload(downloadModel),
                      child: const Text('Resume'),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: downloadModel.status != ServiceStatus.paused &&
                              downloadModel.status != ServiceStatus.loading &&
                              downloadModel.status != ServiceStatus.manualPaused
                          ? null
                          : () => Provider.of<DownloadViewModel>(context,
                                  listen: false)
                              .cancelDownload(downloadModel),
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

class ProgressIconIndicator extends StatelessWidget {
  const ProgressIconIndicator({
    super.key,
    required this.downloadModel,
  });

  final DownloadModel downloadModel;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: switch (downloadModel.status) {
      // change to provider of _downloadStatus
      ServiceStatus.paused || ServiceStatus.manualPaused => const Icon(
          Icons.pause_circle_outline,
          color: Colors.amber,
        ),
      ServiceStatus.loading => CircularProgressIndicator(
          strokeWidth: 4.0,
          color: Colors.white,
          backgroundColor: Colors.grey,
          value: downloadModel.targetLength == 0
              ? 0
              : (downloadModel.currentLength /
                  downloadModel
                      .targetLength), // change to provider of _downloadServiceStatus
        ),
      ServiceStatus.done => const Icon(
          Icons.download_done_outlined,
          color: Colors.lightGreen,
          weight: 10,
          size: 30.0,
        ),
      ServiceStatus.error => const Icon(
          Icons.dangerous_outlined,
          color: Colors.red,
        ),
      ServiceStatus.pending => const CircularProgressIndicator(
          strokeWidth: 4.0,
          color: Colors.white,
          backgroundColor: Colors.grey,
        ),
      ServiceStatus.cancel => const Icon(
          Icons.file_download_off,
          color: Colors.grey,
          weight: 10,
          size: 30.0,
        ),
    });
  }
}
