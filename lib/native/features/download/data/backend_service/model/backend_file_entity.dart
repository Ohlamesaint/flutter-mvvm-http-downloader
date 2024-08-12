import 'dart:io';

class BackendFileEntity {
  String filename;
  String fileType;
  String thumbnailPath;
  String imagePath;
  String temporaryImagePath;

  BackendFileEntity(
      {required this.filename,
      required this.fileType,
      required this.thumbnailPath,
      required this.imagePath,
      required this.temporaryImagePath});

  void removeTemporary() {
    File tempFile = File(temporaryImagePath);
    tempFile.delete();
  }

  factory BackendFileEntity.fromJson(Map<String, dynamic> json) =>
      BackendFileEntity(
          filename: json['filename'],
          fileType: json['fileType'],
          thumbnailPath: json['thumbnailPath'],
          imagePath: json['imagePath'],
          temporaryImagePath: json['temporaryImagePath']);

  Map<String, dynamic> toJson() => {
        'filename': filename,
        'fileType': fileType,
        'thumbnailPath': thumbnailPath,
        'imagePath': imagePath,
        'temporaryImagePath': temporaryImagePath,
      };
}
