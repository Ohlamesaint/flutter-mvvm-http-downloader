import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../domain/entity/download_entity.dart';

class ProgressIconIndicator extends StatelessWidget {
  const ProgressIconIndicator({
    super.key,
    required this.status,
    required this.totalLength,
    required this.currentLength,
  });

  final DownloadStatus status;
  final int totalLength;
  final int currentLength;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: switch (status) {
      // change to provider of _downloadStatus
      DownloadStatus.paused || DownloadStatus.manualPaused => const Icon(
          Icons.pause_circle_outline,
          color: Colors.amber,
        ),
      DownloadStatus.ongoing => CircularProgressIndicator(
          strokeWidth: 4.0,
          color: Colors.white,
          backgroundColor: Colors.grey,
          value: totalLength == 0
              ? 0
              : (currentLength /
                  totalLength), // change to provider of _downloadServiceStatus
        ),
      DownloadStatus.done => const Icon(
          Icons.download_done_outlined,
          color: Colors.lightGreen,
          weight: 10,
          size: 30.0,
        ),
      DownloadStatus.failed => const Icon(
          Icons.dangerous_outlined,
          color: Colors.red,
        ),
      DownloadStatus.pending => const CircularProgressIndicator(
          strokeWidth: 4.0,
          color: Colors.white,
          backgroundColor: Colors.grey,
        ),
      DownloadStatus.canceled => const Icon(
          Icons.file_download_off,
          color: Colors.grey,
          weight: 10,
          size: 30.0,
        ),
    });
  }
}
