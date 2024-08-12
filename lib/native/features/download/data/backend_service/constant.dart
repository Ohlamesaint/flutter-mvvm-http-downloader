import 'package:flutter/material.dart';

const kSupportMediaTypes = {
  'apng',
  'avif',
  'gif',
  'jpeg',
  'png',
  'webp'
}; // svg is not supported

const kUnSupportMediaTypeErrorMessage =
    '''The requested media type is not supported
Please download the media included below:
apng, avif, gif, jpeg, png, webp''';

const kBadRequestErrorMessage = '''Please check the format of the input URL.
It seems to be incorrect.''';

const kNoInternetErrorMessage = '''Please connect to the internet.
''';
