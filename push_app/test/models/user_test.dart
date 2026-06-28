import 'package:flutter_test/flutter_test.dart';
import 'package:push_app/models/user.dart';

void main() {
  group('UserModel', () {
    test('seed returns correct name and streak', () {
      final u = UserModel.seed;
      expect(u.name, 'Leo Martins');
      expect(u.streak, 12);
      expect(u.bestStreak, 18);
    });

    test('levelNumber is 1-based', () {
      expect(UserModel.seed.levelNumber, 1); // rookie = index 0 → level 1
    });

    test('copyWith preserves unmodified fields', () {
      final original = UserModel.seed;
      final updated = original.copyWith(streak: 13);
      expect(updated.streak, 13);
      expect(updated.name, original.name);
    });
  });
}
