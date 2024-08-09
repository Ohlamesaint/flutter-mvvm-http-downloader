import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_corp_homework/flutter/constant.dart';
import 'package:perfect_corp_homework/native/api/app_exception.dart';

import '../../../../../../api/service_result.dart';
import '../../../../domain/entity/download_entity.dart';
import '../../../../domain/repository/download_repository.dart';
part 'download_data_event.dart';
part 'download_data_state.dart';

class DownloadDataBloc extends Bloc<DownloadDataEvent, DownloadDataState> {
  final DownloadRepository downloadRepository;
  late StreamSubscription _subscription;

  DownloadDataBloc(this.downloadRepository)
      : super(const DownloadInitState([])) {
    on<GetDownloadDataSource>(onGetDownloadDataSource);
    on<StartFetchDownload>(onStartFetchDownload);
    on<StopFetchDownload>(onStopFetchDownload);
  }

  onGetDownloadDataSource(DownloadDataEvent event, Emitter emit) {
    ServiceResult<Stream<List<DownloadEntity>>> serviceResult =
        downloadRepository.getDownloadListStream();
    if (!serviceResult.isSuccess) {
      String message = _handleOnCreateDownloadError(serviceResult.error!);
      return emit(DownloadSetUpFailed(message, const []));
    }
    _subscription = serviceResult.data!.listen((dataReturnFromSource) {
      emit(DownloadUpdatedFromSource([...dataReturnFromSource]));
    });

    return emit(const DownloadSetUpFinished([]));
  }

  onStartFetchDownload(DownloadDataEvent event, Emitter emit) {
    _subscription.resume();
  }

  onStopFetchDownload(DownloadDataEvent event, Emitter emit) {
    _subscription.pause();
  }

  String _handleOnCreateDownloadError(Object error) {
    switch (error) {
      case BadRequestError:
        return kBadRequestErrorMessage;
      case UnSupportImageTypeError:
        return kUnSupportMediaTypeErrorMessage;
      case NoInternetError:
        return kNoInternetErrorMessage;
      case _:
        return 'Unknown Error Occur';
    }
  }
}
