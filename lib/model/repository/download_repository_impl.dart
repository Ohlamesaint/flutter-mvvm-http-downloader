import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:perfect_corp_homework/view_model/download_view_model.dart';

import 'package:perfect_corp_homework/view_model/entity/download_entity.dart';

import '../../constant.dart';
import '../../injection_container.dart';
import '../../shared/app_exception.dart';
import 'download_repository.dart';

import 'package:http/http.dart' as http;

class DownloadRepositoryImpl implements DownloadRepository {
  @override
  List<DownloadEntity> fetchDownloadList() {
    // TODO: implement fetchDownloadList
    throw UnimplementedError();
  }

  @override
  Future<void> fetchImageWithUrl({required String urlString}) async {
    Uri uri = Uri.parse(urlString);
    try {
      http.Request request = http.Request('GET', uri);
      request.headers['keep-Alive'] = 'timeout=5, max=1';
      http.StreamedResponse response = await http.Client().send(request);
      late DownloadEntity targetEntity;
      late StreamSubscription<List<int>> subscription;

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

      // generate temporary file name
      String temporaryAbsolute =
          '${(await getTemporaryDirectory()).path}/${_generateFileName()}.${contentType[1]}';

      // initialize download entity with callback from download view model
      targetEntity = locator<DownloadViewModel>().initDownloadEntity(
        urlString: urlString,
        length: response.contentLength ?? 0,
        temporaryAbsolute: temporaryAbsolute,
      );

      // open temporary file
      var file = File(temporaryAbsolute);
      var fileStream = file.openWrite();

      // start download
      locator<DownloadViewModel>().startDownload(targetEntity);

      // subscribe to stream and update entity each time the new data comes
      subscription = response.stream.listen((List<int> value) {
        locator<DownloadViewModel>().updateDownloadEntity(
            downloadEntity: targetEntity, length: value.length);
        fileStream.add(value);
      });

      // download finished
      subscription.onDone(() async {
        locator<DownloadViewModel>().finishDownload(targetEntity);

        // release resource
        subscription.cancel();
        fileStream.close();

        // move temp file to document directory
        String documentAbsolute =
            '${(await getApplicationDocumentsDirectory()).path}/${_generateFileName()}.${contentType[1]}';
        await moveFile(file, documentAbsolute);
      });

      // download error occur
      subscription.onError((_) {
        locator<DownloadViewModel>().errorDownload(targetEntity);
        subscription.cancel();
        fileStream.close();
        file.delete();
      });

      targetEntity.sub = subscription;
    } on BadRequestError catch (e) {
      locator<DownloadViewModel>().showError(e.toString());
      // alert dialog to notify user the url is invalid
    } on UnSupportImageTypeError catch (e) {
      locator<DownloadViewModel>().showError(e.toString());
      // alert dialog to notify user the target type is invalid
    } on ArgumentError catch (e) {
      locator<DownloadViewModel>().showError(e.toString());
    }
  }

  Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      return await sourceFile.rename(newPath);
    } on FileSystemException catch (e) {
      final newFile = await sourceFile.copy(newPath);
      await sourceFile.delete();
      return newFile;
    }
  }

  String _generateFileName() {
    return sha256
        .convert(utf8.encode(DateTime.timestamp().toString()))
        .toString();
  }
}
