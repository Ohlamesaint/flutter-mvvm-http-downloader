class ImageModel {
  final String url;
  final String filename;

  ImageModel({required this.url, required this.filename});

  factory ImageModel.fromJson(Map snapshot) {
    return ImageModel(url: snapshot['url'], filename: snapshot['filename']);
  }
}
