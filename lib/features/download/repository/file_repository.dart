import 'package:perfect_corp_homework/features/download/model/download_file_model.dart';

abstract interface class FileRepository {
  void persistFile(DownloadFileModel downloadFileModel);
}
