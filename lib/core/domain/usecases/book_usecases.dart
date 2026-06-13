import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:perpusku/core/errors/failures.dart';
import '../entities/book.dart';
import '../entities/book_filter.dart';
import '../repositories/book_repository.dart';

class GetBooksUseCase {
  final BookRepository repository;
  const GetBooksUseCase(this.repository);

  Future<Either<Failure, PaginatedBooks>> call(BookFilter filter) =>
      repository.getBooks(filter);
}

class GetBookByIdUseCase {
  final BookRepository repository;
  const GetBookByIdUseCase(this.repository);

  Future<Either<Failure, Book>> call(String id) =>
      repository.getBookById(id);
}

class CreateBookUseCase {
  final BookRepository repository;
  const CreateBookUseCase(this.repository);

  Future<Either<Failure, Book>> call(Book book, {File? coverImage}) =>
      repository.createBook(book, coverImage: coverImage);
}

class UpdateBookUseCase {
  final BookRepository repository;
  const UpdateBookUseCase(this.repository);

  Future<Either<Failure, Book>> call(Book book, {File? coverImage}) =>
      repository.updateBook(book, coverImage: coverImage);
}

class DeleteBookUseCase {
  final BookRepository repository;
  const DeleteBookUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String id) =>
      repository.deleteBook(id);
}

class GetAvailableYearsUseCase {
  final BookRepository repository;
  const GetAvailableYearsUseCase(this.repository);

  Future<Either<Failure, List<int>>> call() =>
      repository.getAvailableYears();
}

class GetCategoriesUseCase {
  final BookRepository repository;
  const GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<String>>> call() =>
      repository.getCategories();
}
