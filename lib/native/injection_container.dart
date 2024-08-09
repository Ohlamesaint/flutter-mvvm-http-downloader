import 'package:get_it/get_it.dart';
import 'package:perfect_corp_homework/native/features/image_presentation/view_model/history_view_model.dart';

import 'features/download/presentation/view_model/download_view_model.dart';
import 'features/download/domain/repository/download_repository.dart';
// import 'features/download/data/repository_impl/download_repository_native_impl.dart';
import 'features/image_presentation/repository/image_repository.dart';
import 'features/image_presentation/repository/image_repository_impl.dart';

final locator = GetIt.instance;

void setup() {
  // locator.registerLazySingleton<DownloadViewModel>(() => DownloadViewModel());
  // locator.registerLazySingleton<DownloadRepository>(
  //     () => DownloadRepositoryMethodChannel());
  locator.registerLazySingleton<ImageRepository>(() => ImageRepositoryImpl());
  locator.registerLazySingleton<HistoryViewModel>(() => HistoryViewModel());
}
