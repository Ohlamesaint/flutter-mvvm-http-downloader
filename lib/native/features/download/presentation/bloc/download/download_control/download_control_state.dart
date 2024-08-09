part of 'download_control_bloc.dart';

@immutable
sealed class DownloadControlState {}

class ErrorOccur extends DownloadControlState {
  final String message;

  ErrorOccur(this.message);
}

class HasDownload extends DownloadControlState {}

class NoDownload extends DownloadControlState {}
