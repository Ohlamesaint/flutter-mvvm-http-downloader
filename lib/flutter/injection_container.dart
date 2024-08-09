import 'package:get_it/get_it.dart';
import 'package:perfect_corp_homework/native/features/download/presentation/view_model/download_view_model.dart';
import 'package:perfect_corp_homework/native/features/image_presentation/view_model/history_view_model.dart';

import '../flutter/features/download/repository/download_repository.dart';
import '../flutter/features/download/repository/download_repository_impl.dart';
import '../flutter/features/image_presentation/repository/image_repository.dart';
import '../flutter/features/image_presentation/repository/image_repository_impl.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<DownloadViewModel>(() => DownloadViewModel());
  locator.registerLazySingleton<DownloadRepository>(
      () => DownloadRepositoryImpl());
  locator.registerLazySingleton<ImageRepository>(() => ImageRepositoryImpl());
  locator.registerLazySingleton<HistoryViewModel>(() => HistoryViewModel());
}
