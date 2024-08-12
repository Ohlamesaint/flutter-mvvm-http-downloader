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

  Map<String, dynamic> toJson() => {
        'isSuccess': isSuccess,
        'error': error,
        'data': data,
      };

  factory ServiceResult.fromJson(Map<String, dynamic> json) => ServiceResult(
        json['isSuccess'],
        json['error'],
        json['data'],
      );
}
