import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:perpusku/core/domain/entities/book.dart';
import 'package:perpusku/core/domain/entities/book_filter.dart';
import 'package:perpusku/core/domain/repositories/book_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/remote/book_query.dart';
import '../datasources/remote/book_storage_query.dart';
import '../models/book_model.dart';

class BookRepositoryImpl implements BookRepository {
  final BookQuery _bookQuery;
  final BookStorageQuery _storageQuery;
  final Logger _logger;

  BookRepositoryImpl({
    required BookQuery bookQuery,
    required BookStorageQuery storageQuery,
    required Logger logger,
  })  : _bookQuery = bookQuery,
        _storageQuery = storageQuery,
        _logger = logger;

  @override
  Future<Either<Failure, PaginatedBooks>> getBooks(BookFilter filter) async {
    try {
      final results = await Future.wait([
        _bookQuery.fetchBooks(filter),
        _bookQuery.countBooks(filter),
      ]);

      final rows = results[0] as List<Map<String, dynamic>>;
      final total = results[1] as int;
      final books = rows.map(BookModel.fromJson).toList();

      return Right(PaginatedBooks(
        books: books,
        totalCount: total,
        currentPage: filter.page,
        pageSize: filter.pageSize,
      ));
    } on Exception catch (e, st) {
      _logger.e('getBooks failed', error: e, stackTrace: st);
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, Book>> getBookById(String id) async {
    try {
      final row = await _bookQuery.fetchBookById(id);
      if (row == null) return const Left(NotFoundFailure('Book not found'));
      return Right(BookModel.fromJson(row));
    } on Exception catch (e, st) {
      _logger.e('getBookById failed', error: e, stackTrace: st);
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, Book>> createBook(
    Book book, {
    File? coverImage,
  }) async {
    try {
      String? coverUrl;
      if (coverImage != null) {
        coverUrl = await _storageQuery.uploadCover(coverImage);
      }

      final model = BookModel.fromEntity(
        coverUrl != null ? book.copyWith(coverUrl: coverUrl) : book,
      );

      final row = await _bookQuery.insertBook(model.toInsertJson());
      return Right(BookModel.fromJson(row));
    } on Exception catch (e, st) {
      _logger.e('createBook failed', error: e, stackTrace: st);
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, Book>> updateBook(
    Book book, {
    File? coverImage,
  }) async {
    try {
      String? coverUrl = book.coverUrl;

      if (coverImage != null) {
        coverUrl = await _storageQuery.uploadCover(
          coverImage,
          existingPath: book.coverUrl,
        );
      }

      final model = BookModel.fromEntity(
        coverUrl != null ? book.copyWith(coverUrl: coverUrl) : book,
      );

      final row = await _bookQuery.updateBook(book.id, model.toUpdateJson());
      return Right(BookModel.fromJson(row));
    } on Exception catch (e, st) {
      _logger.e('updateBook failed', error: e, stackTrace: st);
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteBook(String id) async {
    try {
      final row = await _bookQuery.fetchBookById(id);
      if (row != null && row['cover_url'] != null) {
        await _storageQuery.deleteCover(row['cover_url'] as String);
      }
      await _bookQuery.deleteBook(id);
      return const Right(unit);
    } on Exception catch (e, st) {
      _logger.e('deleteBook failed', error: e, stackTrace: st);
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, List<int>>> getAvailableYears() async {
    try {
      final years = await _bookQuery.fetchDistinctYears();
      return Right(years);
    } on Exception catch (e, st) {
      _logger.e('getAvailableYears failed', error: e, stackTrace: st);
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final cats = await _bookQuery.fetchDistinctCategories();
      return Right(cats);
    } on Exception catch (e, st) {
      _logger.e('getCategories failed', error: e, stackTrace: st);
      return Left(_mapException(e));
    }
  }

  Failure _mapException(Exception e) {
    if (e is StorageException) return StorageFailure(e.message);
    if (e is NotFoundException) return NotFoundFailure(e.message);
    if (e is NetworkException) return NetworkFailure(e.message);
    return ServerFailure(e.toString());
  }
}
