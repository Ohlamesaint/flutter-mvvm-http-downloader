import 'package:flutter_test/flutter_test.dart';
import 'package:perfect_corp_homework/features/download/view/components/bottom_navigation_button_view.dart';

void main() {
  testWidgets(
      "GIVEN screen in downloader page WHEN bottom navigation button is clicked THEN navigates to history page",
      (tester) async {
    // Arrange
    await tester.pumpWidget(const BottomNavigationButtonView());
    // Act

    // Assert
  });
}
