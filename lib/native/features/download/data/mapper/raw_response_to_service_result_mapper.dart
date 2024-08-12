import '../../../../api/app_exception.dart';
import '../../../../api/service_result.dart';

class RawResponseToServiceResultMapper<T> {
  ServiceResult<T> mapping(Map<String, dynamic> rawResponse,
      T Function(Map<String, dynamic>)? factoryFunction) {
    MethodChannelResponse methodChannelResponse =
        RawResponseToMethodChannelResponseMapper().mapping(rawResponse);
    return MethodChannelResponseToServiceResultMapper<T>()
        .mapping(methodChannelResponse, factoryFunction);
  }
}

class RawResponseToMethodChannelResponseMapper {
  MethodChannelResponse mapping(Map<String, dynamic> rawResponse) {
    return MethodChannelResponse(
      statusCode: rawResponse['statusCode'],
      errorMessage: rawResponse['errorMessage'],
      data: rawResponse['data'],
    );
  }
}

class MethodChannelResponseToServiceResultMapper<T> {
  ServiceResult<T> mapping(MethodChannelResponse methodChannelResponse,
      T Function(Map<String, dynamic>)? factoryFunction) {
    switch (methodChannelResponse.statusCode) {
      case 10000:
        return ServiceResult.error(
            UnSupportImageTypeError(methodChannelResponse.errorMessage));
      case 10001:
        return ServiceResult.error(
            BadRequestError(methodChannelResponse.errorMessage));
      case 10002:
        return ServiceResult.error(
            NoInternetError(methodChannelResponse.errorMessage));
      case 10003:
        return ServiceResult.error(
            UnknownError(methodChannelResponse.errorMessage));
      case 10004:
        return ServiceResult.error(
            JsonSerializationError(methodChannelResponse.errorMessage));
      default:
        // error free case
        ServiceResult<T> result =
            ServiceResult.success(methodChannelResponse.data);
        if (factoryFunction == null) {
          result.data = methodChannelResponse.data;
        } else {
          result.data = factoryFunction(methodChannelResponse.data);
        }
        return result;
    }
  }
}

class MethodChannelResponse<T> {
  int statusCode;
  String? errorMessage;
  T? data;

  MethodChannelResponse(
      {required this.statusCode, this.errorMessage, this.data});

  factory MethodChannelResponse.fromJson(Map<String, dynamic> json) =>
      MethodChannelResponse(
          statusCode: json['statusCode'],
          errorMessage: json['errorMessage'],
          data: json['data']);

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'errorMessage': errorMessage,
        'data': data,
      };
}
