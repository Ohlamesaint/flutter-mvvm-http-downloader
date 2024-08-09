class DownloadEntity {
  final String downloadID;
  final int targetLength;
  final String urlString;
  Stream<DownloadProcessEntity> stream;

  DownloadEntity(
      this.downloadID, this.targetLength, this.urlString, this.stream);
}

class DownloadProcessEntity {
  final String downloadID;
  final int addedLength;

  DownloadProcessEntity(this.downloadID, this.addedLength);
}
