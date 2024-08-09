// import 'dart:math';
//
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:perfect_corp_homework/api/service_result.dart';
// import 'package:perfect_corp_homework/features/download/model/download_entity.dart.dart';
// import 'package:perfect_corp_homework/features/download/view_model/download_view_model.dart';
//
// class MockDownloadModel extends Mock implements download_entity.dart {}
//
// void main() async {
//   // Pretest
//   late DownloadViewModel downloadViewModel;
//   int listenerCallCount = 0;
//
//   setUp(() {
//     listenerCallCount = 0;
//     downloadViewModel = DownloadViewModel()
//       ..addListener(() {
//         listenerCallCount += 1;
//       });
//   });
//
//   group('DownloadViewModel -', () {
//     group('init', () {
//       test('''
//         GIVEN download view model class
//         WHEN it is instantiated
//         THEN state should be in init state
//         ''', () {
//         // Arrange
//         // Act
//
//         // Assert
//         expect(downloadViewModel.showErrorDialog, false);
//         expect(downloadViewModel.dialogErrorMessage, '');
//         expect(downloadViewModel.url, '');
//         expect(downloadViewModel.needInput, false);
//         expect(downloadViewModel.downloads, <download_entity.dart>[]);
//       });
//     });
//
//     group('UI State', () {
//       group('closeErrorDialog function', () {
//         test('''
//       GIVEN download view model class
//       WHEN closeErrorDialog function is called
//       THEN ths shorErrorDialog property should be set to false and lister should be notified
//     ''', () {
//           // Act
//           downloadViewModel.closeErrorDialog();
//           // Assert
//           expect(downloadViewModel.showErrorDialog, false);
//           expect(listenerCallCount, 1);
//         });
//       });
//       group('urlInputChanged function', () {
//         test('''
//           GIVEN download view model class
//           WHEN urlInputChanged function is called and the input value is not empty
//           THEN the url should be change to the input, the need input warning should be hidden, and the lister should be notified
//           ''', () {
//           // Arrange
//           const input = 'test';
//           // Act
//           downloadViewModel.urlInputChanged(input);
//           final val = downloadViewModel.url;
//           // Assert
//           expect(val, 'test'); // the url should be change to the input
//           expect(downloadViewModel.needInput,
//               false); // the need input warning should be hidden
//           expect(listenerCallCount, 1); // the lister should be notified
//         });
//
//         test('''
//           GIVEN download view model class
//           WHEN urlInputChanged function is called and the input value is empty
//           THEN the url should be change to the input, the need input warning should be hidden, and the lister should be notified
//           ''', () {
//           // Arrange
//           const input = 'test';
//           // Act
//           downloadViewModel.urlInputChanged(input);
//           final val = downloadViewModel.url;
//           // Assert
//           expect(val, 'test'); // the url should be change to the input
//           expect(downloadViewModel.needInput,
//               false); // the need input warning should be hidden
//           expect(listenerCallCount, 1); // the lister should be notified
//         });
//       });
//       group('showNeedInput function', () {
//         test('''
//       GIVEN DownloadViewModel class
//       WHEN showNeedInput function is called
//       THEN the needInput flag should be set and the listeners should be notified
//       ''', () {
//           // Act
//           downloadViewModel.showNeedInput();
//           // Assert
//           expect(downloadViewModel.needInput, true);
//           expect(listenerCallCount, 1);
//         });
//       });
//     });
//
//     group('Screen On/Off', () {
//       group('pauseAllDownload function', () {
//         test('''
//       GIVEN DownloadViewModel class
//       WHEN pauseAllDownload function is called
//       THEN all the subscription in the DownloadViewModel in loading status should be in paused state
//       ''', () async {
//           // Arrange
//
//           MockDownloadModel loadingModel = MockDownloadModel();
//           MockDownloadModel manualPausedModel = MockDownloadModel();
//           MockDownloadModel pausedModel = MockDownloadModel();
//
//           stream.listen((e) async => print(await e));
//           loadingModel.stream = stream;
//           manualPausedModel.stream = stream;
//           pausedModel.stream = stream;
//           callback(List<int> numList) {
//             return numList;
//           }
//
//           print(stream);
//
//           loadingModel.subscription = stream.listen(callback);
//           manualPausedModel.subscription = stream.listen(callback);
//           pausedModel.subscription = stream.listen(callback);
//           manualPausedModel.subscription.pause();
//           manualPausedModel.status = ServiceStatus.manualPaused;
//           pausedModel.subscription.pause();
//           pausedModel.status = ServiceStatus.paused;
//           // Act
//           downloadViewModel.downloads = [
//             loadingModel,
//             manualPausedModel,
//             pausedModel
//           ];
//
//           downloadViewModel.pauseAllDownload();
//           final val = downloadViewModel.downloads;
//           // Assert
//           for (var download in val) {
//             expect(download.subscription.isPaused, true);
//           }
//           expect(val[0].status, ServiceStatus.paused);
//           expect(val[1].status, ServiceStatus.paused);
//           expect(val[2].status, ServiceStatus.manualPaused);
//         });
//       });
//     });
//   });
// }
