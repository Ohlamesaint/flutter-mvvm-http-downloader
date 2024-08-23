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
