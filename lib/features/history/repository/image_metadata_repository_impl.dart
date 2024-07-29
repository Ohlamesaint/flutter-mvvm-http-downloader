import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perfect_corp_homework/features/history/model/image_metadata_model.dart';

import 'image_metadata_repository.dart';

final _firestore = FirebaseFirestore.instance;

class ImageMetadataRepositoryImpl implements ImageMetadataRepository {
  CollectionReference images = _firestore.collection('images');

  @override
  Future<ImageMetadataModel> fetchImageMetaDataByImageName(
      String imageFileName) async {
    var image =
        await images.where('filename', isEqualTo: imageFileName).limit(1).get();
    if (image.docs.length != 1) {
      // TODO: throw file error
    }

    return ImageMetadataModel.fromJson(
        image.docs[0].data() as Map<String, dynamic>);
  }

  @override
  Future<void> addImageMetaData(ImageMetadataModel imageModel) async {
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
