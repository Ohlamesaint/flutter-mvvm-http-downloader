import 'package:get_it/get_it.dart';
import 'package:perfect_corp_homework/features/download/repository/file_repository_impl.dart';
import 'package:perfect_corp_homework/model/repository/image_repository_impl.dart';
import 'package:perfect_corp_homework/features/download/view_model/download_view_model.dart';
import 'package:perfect_corp_homework/view_model/history_view_model.dart';

import 'features/download/repository/download_repository_impl.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<DownloadViewModel>(() => DownloadViewModel());
  locator.registerLazySingleton<DownloadRepositoryImpl>(
      () => DownloadRepositoryImpl());
  locator
      .registerLazySingleton<ImageRepositoryImpl>(() => ImageRepositoryImpl());
  locator.registerLazySingleton<HistoryViewModel>(() => HistoryViewModel());
  locator.registerLazySingleton<FileRepositoryImpl>(() => FileRepositoryImpl());
}
