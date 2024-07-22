// extendable with isolate http or stream
class ApiResponse<T> {
  Status apiStatus;
  String? message;

  ApiResponse.pending(this.message) : apiStatus = Status.pending;
  ApiResponse.loading(this.message) : apiStatus = Status.loading;
  ApiResponse.paused(this.message) : apiStatus = Status.paused;
  ApiResponse.manualPaused(this.message) : apiStatus = Status.manualPaused;
  ApiResponse.error(this.message) : apiStatus = Status.error;
  ApiResponse.done(this.message) : apiStatus = Status.done;
  ApiResponse.cancel(this.message) : apiStatus = Status.cancel;
}

enum Status {
  pending,
  loading,
  paused,
  manualPaused,
  error,
  done,
  cancel;
}
