import 'package:get_it/get_it.dart';
import 'package:perfect_corp_homework/native/features/download/data/backend_service/controller/backend_download_controller.dart';
import 'package:perfect_corp_homework/native/features/download/data/backend_service/repository/backend_download_repository.dart';
import 'package:perfect_corp_homework/native/features/download/data/backend_service/repository/backend_download_repository_impl.dart';
import 'package:perfect_corp_homework/native/features/download/data/backend_service/service/backend_download_service.dart';
import 'package:perfect_corp_homework/native/features/download/data/backend_service/service/backend_download_service_impl.dart';
import 'package:perfect_corp_homework/native/features/download/data/repository/download_repository_flutter_impl.dart';
import 'package:perfect_corp_homework/native/features/download/data/repository/download_repository_native_impl.dart';
import 'package:perfect_corp_homework/native/features/image_presentation/view_model/history_view_model.dart';

import 'features/download/domain/repository/download_repository.dart';
import 'features/image_presentation/repository/image_repository.dart';
import 'features/image_presentation/repository/image_repository_impl.dart';

final locator = GetIt.instance;

void setup() {
  // locator.registerLazySingleton<DownloadViewModel>(() => DownloadViewModel());
  // locator.registerLazySingleton<DownloadRepository.kt>(
  //     () => DownloadRepositoryMethodChannel());
  // locator.registerLazySingleton<BackendDownloadRepository>(
  //     () => BackendDownloadRepositoryImpl());
  // locator.registerLazySingleton<BackendDownloadService>(
  //     () => BackendDownloadServiceImpl(locator<BackendDownloadRepository>()));
  // locator.registerLazySingleton<BackendDownloadController>(
  //     () => BackendDownloadControllerImpl(locator<BackendDownloadService>()));
  locator.registerLazySingleton<DownloadRepository>(
      () => DownloadRepositoryNativeImpl());
  locator.registerLazySingleton<ImageRepository>(() => ImageRepositoryImpl());
  locator.registerSingleton<HistoryViewModel>(
      HistoryViewModel(locator<DownloadRepository>()));
}
