class ServiceResult<T> {
  bool isSuccess;
  Object? error;
  T? data;

  ServiceResult.success(this.data) : isSuccess = true;
  ServiceResult.error(this.error) : isSuccess = false;

  String getErrorMessage() {
    return error.toString();
  }

  ServiceResult(this.isSuccess, this.error, this.data);
}

// enum ServiceStatus {
//   pending,
//   loading,
//   paused,
//   manualPaused,
//   error,
//   done,
//   cancel;
// }

// class ServiceResult<T> {
//   ServiceStatus serviceStatus;
//   Object? error;
//   T? data;
//
//   ServiceResult.pending() : serviceStatus = ServiceStatus.pending;
//   ServiceResult.loading() : serviceStatus = ServiceStatus.loading;
//   ServiceResult.paused() : serviceStatus = ServiceStatus.paused;
//   ServiceResult.manualPaused() : serviceStatus = ServiceStatus.manualPaused;
//   ServiceResult.error(this.error) : serviceStatus = ServiceStatus.error;
//   ServiceResult.done() : serviceStatus = ServiceStatus.done;
//   ServiceResult.cancel() : serviceStatus = ServiceStatus.cancel;
//
//   String getErrorMessage() {
//     return error.toString();
//   }
// }
//
// enum ServiceStatus {
//   pending,
//   loading,
//   paused,
//   manualPaused,
//   error,
//   done,
//   cancel;
// }
