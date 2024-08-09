import 'package:flutter/material.dart';

const kSupportMediaTypes = {
  'apng',
  'avif',
  'gif',
  'jpeg',
  'png',
  'webp'
}; // svg is not supported

const kDownloadCardTheme = BoxDecoration(
  gradient: LinearGradient(
    colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(255, 63, 16, 16)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
  borderRadius: BorderRadius.all(
    Radius.circular(15.0),
  ),
);

const kGridAxisCount = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 3,
  childAspectRatio: 1.0,
  mainAxisSpacing: 0.5,
  crossAxisSpacing: 0.5,
);

const kDownloadButtonStyle = ButtonStyle(
  elevation: WidgetStatePropertyAll(3.0),
  backgroundColor: WidgetStatePropertyAll<Color>(Colors.black54),
  iconColor: WidgetStatePropertyAll<Color>(Colors.white),
);

const kUnSupportMediaTypeErrorMessage =
    '''The requested media type is not supported
Please download the media included below:
apng, avif, gif, jpeg, png, webp''';

const kBadRequestErrorMessage = '''Please check the format of the input URL.
It seems to be incorrect.''';

const kNoInternetErrorMessage = '''Please connect to the internet.
''';
