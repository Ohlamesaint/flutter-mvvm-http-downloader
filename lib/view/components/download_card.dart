import 'package:flutter/material.dart';
import 'package:perfect_corp_homework/view_model/download_view_model.dart';
import 'package:provider/provider.dart';

import '../../shared/api_response.dart';
import '../../view_model/entity/download_entity.dart';

class DownloadCard extends StatelessWidget {
  final DownloadEntity downloadEntity;

  const DownloadCard({
    super.key,
    required this.downloadEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: const BorderRadius.all(
        Radius.circular(15.0),
      ),
      elevation: 10.0,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 63, 16, 16)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        // elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(
                      downloadEntity.urlString,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                        child: switch (downloadEntity.response.apiStatus) {
                      // change to provider of _downloadStatus
                      Status.paused || Status.manualPaused => const Icon(
                          Icons.pause_circle_outline,
                          color: Colors.amber,
                        ),
                      Status.loading => CircularProgressIndicator(
                          strokeWidth: 4.0,
                          color: Colors.white,
                          backgroundColor: Colors.grey,
                          value: downloadEntity.targetLength == 0
                              ? 0
                              : (downloadEntity.currentLength /
                                  downloadEntity
                                      .targetLength), // change to provider of _downloadStatus
                        ),
                      Status.done => const Icon(
                          Icons.download_done_outlined,
                          color: Colors.lightGreen,
                          weight: 10,
                          size: 30.0,
                        ),
                      Status.error => const Icon(
                          Icons.dangerous_outlined,
                          color: Colors.red,
                        ),
                      Status.pending => const CircularProgressIndicator(
                          strokeWidth: 4.0,
                          color: Colors.white,
                          backgroundColor: Colors.grey,
                        ),
                      Status.cancel => const Icon(
                          Icons.file_download_off,
                          color: Colors.grey,
                          weight: 10,
                          size: 30.0,
                        ),
                    }),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      // change to provider of _downloadStatus
                      onPressed:
                          downloadEntity.response.apiStatus != Status.loading
                              ? null
                              : () => Provider.of<DownloadViewModel>(context,
                                      listen: false)
                                  .manualPauseDownload(downloadEntity),
                      child: const Text(
                        'Pause',
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed:
                          downloadEntity.response.apiStatus != Status.paused &&
                                  downloadEntity.response.apiStatus !=
                                      Status.manualPaused
                              ? null
                              : () => Provider.of<DownloadViewModel>(context,
                                      listen: false)
                                  .resumeDownload(downloadEntity),
                      child: const Text('Resume'),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed:
                          downloadEntity.response.apiStatus != Status.paused &&
                                  downloadEntity.response.apiStatus !=
                                      Status.loading &&
                                  downloadEntity.response.apiStatus !=
                                      Status.manualPaused
                              ? null
                              : () => Provider.of<DownloadViewModel>(context,
                                      listen: false)
                                  .cancelDownload(downloadEntity),
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
