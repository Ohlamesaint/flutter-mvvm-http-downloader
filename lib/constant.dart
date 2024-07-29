import 'package:flutter/cupertino.dart';

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
