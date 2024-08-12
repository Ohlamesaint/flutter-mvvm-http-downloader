import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_corp_homework/flutter/constant.dart';
import 'package:perfect_corp_homework/native/api/app_exception.dart';
import 'package:perfect_corp_homework/native/features/download/data/backend_service/service/backend_download_service_impl.dart';

import '../../../../data/model/download_model.dart';
import '../../../../domain/entity/download_entity.dart';
import '../../../../domain/repository/download_repository.dart';
part 'download_data_event.dart';
part 'download_data_state.dart';

class DownloadDataBloc extends Bloc<DownloadDataEvent, DownloadDataState> {
  final DownloadRepository downloadRepository;
  // late StreamSubscription _subscription = BackendDownloadServiceImpl.allDownloadStreamController.stream.
  DownloadDataBloc(this.downloadRepository)
      : super(const DownloadInitState([])) {
    on<GetDownloadDataSource>(onGetDownloadDataSource);
    on<StartFetchDownload>(onStartFetchDownload);
    on<StopFetchDownload>(onStopFetchDownload);
  }

  onGetDownloadDataSource(DownloadDataEvent event, Emitter emit) {
    return emit
        .forEach(BackendDownloadServiceImpl.allDownloadStreamController.stream,
            onData: (data) {
      final List rawDownloadEntityList = json.decode(data);
      final downloadEntities = rawDownloadEntityList
          .map((rawDownloadEntity) =>
              DownloadModel.fromJson(jsonDecode(rawDownloadEntity)))
          .toList();
      return DownloadUpdatedFromSource([...downloadEntities]);
    });
  }

  onStartFetchDownload(DownloadDataEvent event, Emitter emit) {
    // _subscription.resume();
  }

  onStopFetchDownload(DownloadDataEvent event, Emitter emit) {
    // _subscription.pause();
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
