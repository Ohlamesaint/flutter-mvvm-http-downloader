part of 'download_data_bloc.dart';

@immutable
sealed class DownloadDataState {
  final List<DownloadEntity> downloadList;

  const DownloadDataState(this.downloadList);
}

class DownloadInitState extends DownloadDataState {
  const DownloadInitState(super.downloadList);
}

class DownloadSetUpFinished extends DownloadDataState {
  const DownloadSetUpFinished(super.downloadList);
}

class DownloadSetUpFailed extends DownloadDataState {
  final String message;

  const DownloadSetUpFailed(this.message, super.downloadList);
}

class DownloadUpdatedFromSource extends DownloadDataState with EquatableMixin {
  DownloadUpdatedFromSource(super.downloadList);

  @override
  List<Object?> get props => [downloadList];
}
