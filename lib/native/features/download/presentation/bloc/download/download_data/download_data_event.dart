part of 'download_data_bloc.dart';

sealed class DownloadDataEvent {}

class GetDownloadDataSource extends DownloadDataEvent {}

class StartFetchDownload extends DownloadDataEvent {}

class StopFetchDownload extends DownloadDataEvent {}
