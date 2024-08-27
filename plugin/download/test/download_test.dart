import 'package:flutter_test/flutter_test.dart';
import 'package:download/download.dart';
import 'package:download/download_platform_interface.dart';
import 'package:download/download_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDownloadPlatform
    with MockPlatformInterfaceMixin
    implements DownloadPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String> cancelDownload({required String downloadID}) {
    // TODO: implement cancelDownload
    throw UnimplementedError();
  }

  @override
  Future<String> createDownload(
      {required String urlString, required bool isConcurrent}) {
    // TODO: implement createDownload
    throw UnimplementedError();
  }

  @override
  Stream getDownloadListStream() {
    // TODO: implement getDownloadListStream
    throw UnimplementedError();
  }

  @override
  Stream getFinishedEventStream() {
    // TODO: implement getFinishedEventStream
    throw UnimplementedError();
  }

  @override
  Future<String> manualPauseDownload({required String downloadID}) {
    // TODO: implement manualPauseDownload
    throw UnimplementedError();
  }

  @override
  Future<String> pauseDownload({required String downloadID}) {
    // TODO: implement pauseDownload
    throw UnimplementedError();
  }

  @override
  Future<String> resumeDownload({required String downloadID}) {
    // TODO: implement resumeDownload
    throw UnimplementedError();
  }
}

void main() {
  final DownloadPlatform initialPlatform = DownloadPlatform.instance;

  test('$MethodChannelDownload is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDownload>());
  });

  test('getPlatformVersion', () async {
    Download downloadPlugin = Download();
    MockDownloadPlatform fakePlatform = MockDownloadPlatform();
    DownloadPlatform.instance = fakePlatform;

    expect(await downloadPlugin.getPlatformVersion(), '42');
  });
}
