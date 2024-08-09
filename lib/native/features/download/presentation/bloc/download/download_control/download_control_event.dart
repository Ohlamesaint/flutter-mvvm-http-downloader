part of 'download_control_bloc.dart';

sealed class DownloadControlEvent {}

class CreateDownload extends DownloadControlEvent {
  String url;
  CreateDownload(this.url);
}

class PauseDownload extends DownloadControlEvent {
  String downloadID;
  PauseDownload(this.downloadID);
}

class ResumeDownload extends DownloadControlEvent {
  String downloadID;
  ResumeDownload(this.downloadID);
}

class CancelDownload extends DownloadControlEvent {
  String downloadID;
  CancelDownload(this.downloadID);
}
