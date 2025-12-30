import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_sczuw/utils/time_formatter.dart';

void main() {
  group('formatPostponeDuration', () {
    test('formats minutes correctly', () {
      expect(formatPostponeDuration(300), '5m'); // 5 minutes
      expect(formatPostponeDuration(600), '10m'); // 10 minutes
      expect(formatPostponeDuration(1800), '30m'); // 30 minutes
    });

    test('formats hours correctly', () {
      expect(formatPostponeDuration(3600), '1h'); // 1 hour
      expect(formatPostponeDuration(7200), '2h'); // 2 hours
    });

    test('formats seconds as fallback', () {
      expect(formatPostponeDuration(30), '30s'); // 30 seconds
      expect(formatPostponeDuration(59), '59s'); // 59 seconds
    });

    test('handles edge cases', () {
      expect(formatPostponeDuration(60), '1m'); // exactly 1 minute
      expect(formatPostponeDuration(3599), '3599s'); // 59:59, not hour
    });
  });
}