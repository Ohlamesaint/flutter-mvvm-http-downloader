import 'package:perfect_corp_homework/native/features/download/data/model/download_progress_response_model.dart';
import 'package:perfect_corp_homework/native/features/download/domain/repository/output/download_created_response.dart';

import '../../../../api/app_exception.dart';
import '../../../../api/service_result.dart';
import '../model/download_created_response_model.dart';
import '../repository/download_repository_native_impl.dart';

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
      default:
        // error free case
        ServiceResult<T> result = ServiceResult.success();
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

  factory MethodChannelResponse.fromJson(Map<String, dynamic> data) {
    return MethodChannelResponse(statusCode: data['statusCode']);
  }
}
