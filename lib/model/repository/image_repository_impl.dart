import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../ImageModel.dart';
import 'image_repository.dart';

final _firestore = FirebaseFirestore.instance;

class ImageRepositoryImpl implements ImageRepository {
  CollectionReference images = _firestore.collection('images');

  @override
  Future<List<FileImage>> fetchThumbnails() async {
    var status = await Permission.storage.status;
    List<FileImage> thumbnails;

    if (!status.isGranted) {
      await Permission.storage.request();
    }
    Directory thumbnailDir = Directory(
        '${(await getApplicationDocumentsDirectory()).path}/thumbnails/');
    thumbnailDir.createSync(recursive: true);
    var thumbnailList = await thumbnailDir.list().toList();
    thumbnails = thumbnailList.whereType<File>().map((file) {
      return FileImage(file);
    }).toList();
    return thumbnails;
  }

  @override
  Future<ImageModel> fetchImageMetaDataByImageName(String imageFileName) async {
    var image =
        await images.where('filename', isEqualTo: imageFileName).limit(1).get();
    if (image.docs.length != 1) {
      // TODO: throw file error
    }

    return ImageModel.fromJson(image.docs[0].data() as Map<String, dynamic>);
  }

  @override
  Future<void> addImageMetaData(ImageModel imageModel) async {
    try {
      await images.add({
        'url': imageModel.url,
        'filename': imageModel.filename,
      });
    } catch (e) {
      // TODO: Image Add Error
    }

    log('file ${imageModel.filename} been added to firebase');
  }
}
