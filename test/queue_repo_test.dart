import 'package:flutter_test/flutter_test.dart';
import 'package:semesterproject/providers/queue_repo.dart';

void main() {
  test('QueueRepo can be constructed', () {
    final repo = QueueRepo();
    expect(repo, isNotNull);
  });

  // NOTE: Integration tests that interact with Firestore should be placed
  // in a separate integration test file and run against the emulator.
}
