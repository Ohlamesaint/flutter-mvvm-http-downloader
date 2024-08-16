import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../../features/download/domain/entity/download_entity.dart';
import '../../../api/service_result.dart';
import '../../../util/file_util.dart';
import '../../download/domain/entity/file_entity.dart';
import '../model/image_model.dart';
import 'image_repository.dart';

final _firestore = FirebaseFirestore.instance;

class ImageRepositoryImpl implements ImageRepository {
  CollectionReference imageDatabase = _firestore.collection('images');

  @override
  Future<ServiceResult<void>> saveImage(DownloadEntity downloadEntity) async {
    try {
      String documentAbsolute = await FileUtil.generatePersistFileName(
          filename: downloadEntity.fileEntity.filename,
          fileType: downloadEntity.fileEntity.fileType);
      String documentThumbnailAbsolute =
          await FileUtil.generatePersistThumbnailName(
              filename: downloadEntity.fileEntity.filename,
              fileType: downloadEntity.fileEntity.fileType);
      File tempFile = File(downloadEntity.fileEntity.temporaryImagePath);
      var persistFile = await FileUtil.moveFile(tempFile, documentAbsolute);
      // compress the image as thumbnail

      await FileUtil.compressFile(persistFile, documentThumbnailAbsolute);

      await imageDatabase.add({
        'url': downloadEntity.url,
        'filename': downloadEntity.fileEntity.filename,
        'createTime': DateTime.now(),
      });

      log('file $documentAbsolute been added to firebase');
    } catch (e) {
      return ServiceResult.error(e);
    }

    return ServiceResult.success(null);
  }

  @override
  Future<ServiceResult<List<ImageModel>>> fetchImages() async {
    late ServiceResult<List<ImageModel>> serviceResult;
    try {
      String persistDirectory = await FileUtil.getPersistImageDirectory();
      String thumbnailsDirectory = await FileUtil.getThumbnailImageDirectory();

      List<File> originImages =
          FileUtil.getAllFilesInDirectory(persistDirectory);
      List<File> thumbnails =
          FileUtil.getAllFilesInDirectory(thumbnailsDirectory);

      if (originImages.isEmpty) {
        return ServiceResult.success([]);
      }

      Map<String, ImageModel> filename2ImageModel = <String, ImageModel>{};

      for (File originImage in originImages) {
        String filename = originImage.uri.pathSegments.last.split('.')[0];
        ImageModel newImageModel = ImageModel();
        newImageModel.originImage = originImage;
        newImageModel.filename = filename;
        filename2ImageModel[filename] = newImageModel;
      }
      for (File thumbnail in thumbnails) {
        String filename = thumbnail.uri.pathSegments.last.split('.')[0];
        filename2ImageModel[filename]!.thumbnail = thumbnail;
      }

      await Future.forEach(filename2ImageModel.entries, (entry) async {
        ImageModel imageModel = entry.value;
        String filename = entry.key;
        var image = await imageDatabase
            .where('filename', isEqualTo: filename)
            .limit(1)
            .get();
        if (image.docs.length != 1) {
          // TODO: throw file error
          log('image not found error: $filename');
          return;
        }
        Map<String, dynamic> snapshot =
            image.docs[0].data()! as Map<String, dynamic>;
        imageModel.url = snapshot['url'];
        imageModel.createTime = (snapshot['createTime'] as Timestamp).toDate();
      });
      List<ImageModel> imageModelLists = filename2ImageModel.values.toList();
      mergeSort(imageModelLists, compare: (ImageModel m1, ImageModel m2) {
        return -m1.createTime.compareTo(m2.createTime);
      });
      serviceResult = ServiceResult.success(imageModelLists);
    } catch (e) {
      print(e.toString());
      return ServiceResult.error(e);
    }

    return serviceResult;
  }
}
