import 'package:flutter_test/flutter_test.dart';
import 'package:push_app/theme/colors.dart';

void main() {
  test('accent color matches design spec', () {
    expect(accentColor.toARGB32(), 0xFFC9F24A);
  });
  test('bg color matches design spec', () {
    expect(bgColor.toARGB32(), 0xFF0E100D);
  });
}
