import 'package:perpusku/core/domain/entities/book.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../models/pending_operation.dart';

class OfflineQueueLocalDataSource {
  static const _key = 'offline_pending_ops';
  final _uuid = const Uuid();

  Future<List<PendingOperation>> loadQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((s) {
      try {
        return PendingOperation.fromJsonString(s);
      } catch (_) {
        return null;
      }
    }).whereType<PendingOperation>().toList();
  }

  Future<int> pendingCount() async {
    final queue = await loadQueue();
    return queue.length;
  }

  Future<void> enqueueCreate(Book book, {String? localCoverPath}) async {
    final op = PendingOperation(
      id: _uuid.v4(),
      type: PendingOperationType.create,
      book: book,
      localCoverPath: localCoverPath,
      queuedAt: DateTime.now(),
    );
    await _append(op);
  }

  Future<void> enqueueUpdate(Book book, {String? localCoverPath}) async {
    final queue = await loadQueue();
    final existingCreateIndex = queue.indexWhere(
      (op) =>
          op.book.id == book.id &&
          op.type == PendingOperationType.create,
    );

    if (existingCreateIndex != -1) {
      queue[existingCreateIndex] = PendingOperation(
        id: queue[existingCreateIndex].id,
        type: PendingOperationType.create,
        book: book,
        localCoverPath: localCoverPath ?? queue[existingCreateIndex].localCoverPath,
        queuedAt: queue[existingCreateIndex].queuedAt,
      );
      await _save(queue);
    } else {
      final existingUpdateIndex = queue.indexWhere(
        (op) =>
            op.book.id == book.id &&
            op.type == PendingOperationType.update,
      );
      if (existingUpdateIndex != -1) {
        queue[existingUpdateIndex] = PendingOperation(
          id: queue[existingUpdateIndex].id,
          type: PendingOperationType.update,
          book: book,
          localCoverPath: localCoverPath ?? queue[existingUpdateIndex].localCoverPath,
          queuedAt: queue[existingUpdateIndex].queuedAt,
        );
        await _save(queue);
      } else {
        final op = PendingOperation(
          id: _uuid.v4(),
          type: PendingOperationType.update,
          book: book,
          localCoverPath: localCoverPath,
          queuedAt: DateTime.now(),
        );
        await _append(op);
      }
    }
  }

  Future<void> dequeue(String operationId) async {
    final queue = await loadQueue();
    queue.removeWhere((op) => op.id == operationId);
    await _save(queue);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
  
  Future<void> _append(PendingOperation op) async {
    final queue = await loadQueue();
    queue.add(op);
    await _save(queue);
  }

  Future<void> _save(List<PendingOperation> queue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      queue.map((op) => op.toJsonString()).toList(),
    );
  }
}
