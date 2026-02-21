import 'package:flutter_test/flutter_test.dart';
import 'package:webant_gallery/main.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    await tester.pumpWidget(const WebAntGalleryApp());
  });
}
