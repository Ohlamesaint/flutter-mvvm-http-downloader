import 'package:perfect_corp_homework/api/app_exception.dart';

class ServiceResult<T> {
  ServiceStatus serviceStatus;
  Object? error;
  T? data;

  ServiceResult.pending() : serviceStatus = ServiceStatus.pending;
  ServiceResult.loading() : serviceStatus = ServiceStatus.loading;
  ServiceResult.paused() : serviceStatus = ServiceStatus.paused;
  ServiceResult.manualPaused() : serviceStatus = ServiceStatus.manualPaused;
  ServiceResult.error(this.error) : serviceStatus = ServiceStatus.error;
  ServiceResult.done() : serviceStatus = ServiceStatus.done;
  ServiceResult.cancel() : serviceStatus = ServiceStatus.cancel;
}

enum ServiceStatus {
  pending,
  loading,
  paused,
  manualPaused,
  error,
  done,
  cancel;
}
