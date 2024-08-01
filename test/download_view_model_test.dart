import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:perfect_corp_homework/features/download/model/download_model.dart';
import 'package:perfect_corp_homework/features/download/view_model/download_view_model.dart';

void main() {
  // Pretest
  late DownloadViewModel downloadViewModel;
  int listenerCallCount = 0;

  setUp(() {
    listenerCallCount = 0;
    downloadViewModel = DownloadViewModel()
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  group('DownloadViewModel -', () {
    test('''
        GIVEN download view model class 
        WHEN it is instantiated 
        THEN state should be in init state
        ''', () {
      // Arrange
      // Act

      // Assert
      expect(downloadViewModel.showErrorDialog, false);
      expect(downloadViewModel.dialogErrorMessage, '');
      expect(downloadViewModel.url, '');
      expect(downloadViewModel.needInput, false);
      expect(downloadViewModel.downloads, <DownloadModel>[]);
    });

    group('closeErrorDialog function', () {
      test('''
      GIVEN download view model class
      WHEN closeErrorDialog function is called
      THEN ths shorErrorDialog property should be set to false and lister should be notified
    ''', () {
        // Act
        downloadViewModel.closeErrorDialog();
        // Assert
        expect(downloadViewModel.showErrorDialog, false);
        expect(listenerCallCount, 1);
      });
    });

    group('urlInputChanged function', () {
      test('''
          GIVEN download view model class 
          WHEN urlInputChanged function is called and the input value is not empty 
          THEN the url should be change to the input, the need input warning should be hidden, and the lister should be notified
          ''', () {
        // Arrange
        const input = 'test';
        // Act
        downloadViewModel.urlInputChanged(input);
        final val = downloadViewModel.url;
        // Assert
        expect(val, 'test'); // the url should be change to the input
        expect(downloadViewModel.needInput,
            false); // the need input warning should be hidden
        expect(listenerCallCount, 1); // the lister should be notified
      });

      test('''
          GIVEN download view model class 
          WHEN urlInputChanged function is called and the input value is empty 
          THEN the url should be change to the input, the need input warning should be hidden, and the lister should be notified
          ''', () {
        // Arrange
        const input = 'test';
        // Act
        downloadViewModel.urlInputChanged(input);
        final val = downloadViewModel.url;
        // Assert
        expect(val, 'test'); // the url should be change to the input
        expect(downloadViewModel.needInput,
            false); // the need input warning should be hidden
        expect(listenerCallCount, 1); // the lister should be notified
      });
    });

    group('showNeedInput function', () {
      test('''
      GIVEN DownloadViewModel class
      WHEN showNeedInput function is called
      THEN the needInput flag should be set and the listeners should be notified
      ''', () {
        // Act
        downloadViewModel.showNeedInput();
        // Assert
        expect(downloadViewModel.needInput, true);
        expect(listenerCallCount, 1);
      });
    });
  });
}
