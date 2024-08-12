import 'package:get_it/get_it.dart';

import '../flutter/features/download/repository/download_repository.dart';
import '../flutter/features/download/repository/download_repository_impl.dart';
import '../flutter/features/image_presentation/repository/image_repository.dart';
import '../flutter/features/image_presentation/repository/image_repository_impl.dart';
import 'features/download/view_model/download_view_model.dart';
import 'features/image_presentation/view_model/history_view_model.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<DownloadViewModel>(() => DownloadViewModel());
  locator.registerLazySingleton<DownloadRepository>(
      () => DownloadRepositoryImpl());
  locator.registerLazySingleton<ImageRepository>(() => ImageRepositoryImpl());
  locator.registerLazySingleton<HistoryViewModel>(() => HistoryViewModel());
}
