class ImageMetadataModel {
  final String url;
  final String filename;

  ImageMetadataModel({required this.url, required this.filename});

  factory ImageMetadataModel.fromJson(Map snapshot) {
    return ImageMetadataModel(
        url: snapshot['url'], filename: snapshot['filename']);
  }
}
