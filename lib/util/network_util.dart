import 'dart:developer';

import 'package:http/http.dart' as http;

import '../api/app_exception.dart';
import '../constant.dart';

class NetworkUtil {
  NetworkUtil._();

  /// api for streamed data fetching
  /// @Return [http.StreamedResponse]
  /// @Error [BadRequestError] for abnormal statusCode
  /// @Error [UnSupportImageTypeError] for invalid media type
  static Future<http.StreamedResponse> fetchStreamImageDataWithUrlString(
      String urlString) async {
    Uri uri = Uri.parse(urlString);
    http.Request request = http.Request('GET', uri);
    request.headers['keep-Alive'] = 'timeout=5, max=1';
    http.StreamedResponse response = await http.Client().send(request);

    // check if request is valid
    var contentType = response.headers['content-type']!.split('/');
    if (response.statusCode < 200 || response.statusCode > 300) {
      throw BadRequestError('bad request');
    }
    if (contentType.length != 2 ||
        contentType[0] != 'image' ||
        !kSupportMediaTypes.contains(contentType[1])) {
      throw UnSupportImageTypeError('invalid type');
    }
    return response;
  }
}
