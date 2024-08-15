import '../../api/service_result.dart';
import '../../api/app_exception.dart';

class ServiceResultToMethodChannelResponseMapper<T> {
  MethodChannelResponse<T> mapping(ServiceResult serviceResult,
      T Function(Map<String, dynamic>)? factoryFunction) {
    if (!serviceResult.isSuccess) {
      switch (serviceResult.error) {
        case UnSupportImageTypeError:
          return MethodChannelResponse.unSupportImageTypeError(
              serviceResult.getErrorMessage());
        case BadRequestError:
          return MethodChannelResponse.badRequestError(
              serviceResult.getErrorMessage());
        case NoInternetError:
          return MethodChannelResponse.noInternetError(
              serviceResult.getErrorMessage());
        case JsonSerializationError:
          return MethodChannelResponse.jsonSerializationError(
              serviceResult.getErrorMessage());
        case _:
          return MethodChannelResponse.unknownError(
              serviceResult.getErrorMessage());
      }
    } else {
      return MethodChannelResponse.success(serviceResult.data);
    }
  }
}

class MethodChannelResponse<T> {
  int statusCode;
  String? errorMessage;
  T? data;

  MethodChannelResponse(
      {required this.statusCode, this.errorMessage, this.data});

  MethodChannelResponse.unSupportImageTypeError(this.errorMessage)
      : statusCode = 10000;
  MethodChannelResponse.badRequestError(this.errorMessage) : statusCode = 10001;
  MethodChannelResponse.noInternetError(this.errorMessage) : statusCode = 10002;
  MethodChannelResponse.unknownError(this.errorMessage) : statusCode = 10003;
  MethodChannelResponse.jsonSerializationError(this.errorMessage)
      : statusCode = 10004;
  MethodChannelResponse.success(this.data) : statusCode = 0;

  factory MethodChannelResponse.fromJson(Map<String, dynamic> json,
          T Function(Map<String, dynamic>) factoryFunction) =>
      MethodChannelResponse<T>(
          statusCode: json['statusCode'],
          errorMessage: json['errorMessage'],
          data: factoryFunction(json['data']));

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'errorMessage': errorMessage,
        'data': data,
      };
}
