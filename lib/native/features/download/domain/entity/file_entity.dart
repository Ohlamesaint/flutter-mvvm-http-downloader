class FileEntity {
  String filename;
  String fileType;
  String thumbnailPath;
  String imagePath;
  String temporaryImagePath;

  FileEntity({
    required this.filename,
    required this.fileType,
    required this.thumbnailPath,
    required this.imagePath,
    required this.temporaryImagePath,
  });
}
