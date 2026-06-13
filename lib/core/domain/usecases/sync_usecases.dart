import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:perpusku/core/errors/failures.dart';
import 'package:perpusku/data/datasources/local/offline_queue_local_datasource.dart';
import 'package:perpusku/data/models/pending_operation.dart';
import '../repositories/book_repository.dart';

class SyncPendingBooksUseCase {
  final BookRepository _repository;
  final OfflineQueueLocalDataSource _queue;

  const SyncPendingBooksUseCase(this._repository, this._queue);
  Future<Either<Failure, int>> call() async {
    final ops = await _queue.loadQueue();
    if (ops.isEmpty) return const Right(0);

    int synced = 0;

    for (final op in ops) {
      final coverFile = op.localCoverPath != null
          ? File(op.localCoverPath!)
          : null;

      final validCover =
          coverFile != null && await coverFile.exists() ? coverFile : null;

      Either<Failure, dynamic> result;

      if (op.type == PendingOperationType.create) {
        result = await _repository.createBook(op.book, coverImage: validCover);
      } else {
        result = await _repository.updateBook(op.book, coverImage: validCover);
      }

      if (result.isLeft()) {
        return result.fold(
          (failure) => Left(
            ServerFailure(
              'Synced $synced/${ops.length}. '
              'Failed on "${op.book.title}": ${failure.message}',
            ),
          ),
          (_) => const Right(0),
        );
      }
      
      await _queue.dequeue(op.id);
      synced++;
    }

    return Right(synced);
  }
}

class GetPendingCountUseCase {
  final OfflineQueueLocalDataSource _queue;
  const GetPendingCountUseCase(this._queue);

  Future<int> call() => _queue.pendingCount();
}

class LoadPendingQueueUseCase {
  final OfflineQueueLocalDataSource _queue;
  const LoadPendingQueueUseCase(this._queue);

  Future<List<PendingOperation>> call() => _queue.loadQueue();
}
