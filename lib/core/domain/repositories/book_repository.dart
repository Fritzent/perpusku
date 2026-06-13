import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:perpusku/core/errors/failures.dart';
import '../entities/book.dart';
import '../entities/book_filter.dart';

abstract class BookRepository {
  Future<Either<Failure, PaginatedBooks>> getBooks(BookFilter filter);
  Future<Either<Failure, Book>> getBookById(String id);
  Future<Either<Failure, Book>> createBook(Book book, {File? coverImage});
  Future<Either<Failure, Book>> updateBook(Book book, {File? coverImage});
  Future<Either<Failure, Unit>> deleteBook(String id);
  Future<Either<Failure, List<int>>> getAvailableYears();
  Future<Either<Failure, List<String>>> getCategories();
}
