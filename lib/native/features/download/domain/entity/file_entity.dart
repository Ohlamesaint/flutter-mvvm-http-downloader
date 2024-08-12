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

  factory FileEntity.fromJson(Map<String, dynamic> json) => FileEntity(
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
