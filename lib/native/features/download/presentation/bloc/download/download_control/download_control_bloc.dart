import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_corp_homework/flutter/constant.dart';
import 'package:perfect_corp_homework/native/api/app_exception.dart';

import '../../../../../../api/service_result.dart';
import '../../../../domain/repository/download_repository.dart';
part 'download_control_event.dart';
part 'download_control_state.dart';

class DownloadControlBloc
    extends Bloc<DownloadControlEvent, DownloadControlState> {
  final DownloadRepository downloadRepository;

  DownloadControlBloc(this.downloadRepository) : super(NoDownload()) {
    on<CreateDownload>(onCreateDownload);
    on<PauseDownload>(onPauseDownload);
    on<ResumeDownload>(onResumeDownload);
    on<CancelDownload>(onCancelDownload);
  }

  onCreateDownload(CreateDownload event, Emitter emit) async {
    ServiceResult<int> serviceResult = await downloadRepository.createDownload(
        urlString: event.url, isConcurrent: event.isConcurrent);
    if (!serviceResult.isSuccess) {
      String message = _handleDownloadError(serviceResult.error!);
      emit(ErrorOccur(message));
      return;
    }
    return serviceResult.data! != 0 ? emit(HasDownload()) : emit(NoDownload());
  }

  onPauseDownload(PauseDownload event, Emitter emit) async {
    ServiceResult<int> serviceResult =
        await downloadRepository.pauseDownload(downloadID: event.downloadID);
    if (!serviceResult.isSuccess) {
      String message = _handleDownloadError(serviceResult.error!);
      emit(ErrorOccur(message));
      return;
    }
    return serviceResult.data! != 0 ? emit(HasDownload()) : emit(NoDownload());
  }

  onResumeDownload(ResumeDownload event, Emitter emit) async {
    ServiceResult<int> serviceResult =
        await downloadRepository.resumeDownload(downloadID: event.downloadID);
    if (!serviceResult.isSuccess) {
      String message = _handleDownloadError(serviceResult.error!);
      emit(ErrorOccur(message));
      return;
    }
    return serviceResult.data! != 0 ? emit(HasDownload()) : emit(NoDownload());
  }

  onCancelDownload(CancelDownload event, Emitter emit) async {
    ServiceResult<int> serviceResult =
        await downloadRepository.cancelDownload(downloadID: event.downloadID);
    if (!serviceResult.isSuccess) {
      String message = _handleDownloadError(serviceResult.error!);
      emit(ErrorOccur(message));
      return;
    }
    return serviceResult.data! != 0 ? emit(HasDownload()) : emit(NoDownload());
  }

  String _handleDownloadError(Object error) {
    switch (error) {
      case BadRequestError:
        return kBadRequestErrorMessage;
      case UnSupportImageTypeError:
        return kUnSupportMediaTypeErrorMessage;
      case NoInternetError:
        return kNoInternetErrorMessage;
      case _:
        return error.toString();
    }
  }
}
