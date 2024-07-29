import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryEntity {
  final String filename;
  final String imageUrl;

  HistoryEntity({required this.filename, required this.imageUrl});
}
