import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:perpusku/core/domain/entities/book.dart';
import 'package:perpusku/core/domain/entities/book_filter.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object?> get props => [];
}

class LoadBooksEvent extends BookEvent {
  final BookFilter filter;
  const LoadBooksEvent({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class RefreshBooksEvent extends BookEvent {
  const RefreshBooksEvent();
}

class SearchBooksEvent extends BookEvent {
  final String query;
  const SearchBooksEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterByYearEvent extends BookEvent {
  final int? year;
  const FilterByYearEvent(this.year);

  @override
  List<Object?> get props => [year];
}

class FilterByCategoryEvent extends BookEvent {
  final String? category;
  const FilterByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class ChangePageEvent extends BookEvent {
  final int page;
  const ChangePageEvent(this.page);

  @override
  List<Object?> get props => [page];
}

class CreateBookEvent extends BookEvent {
  final Book book;
  final File? coverImage;
  const CreateBookEvent({required this.book, this.coverImage});

  @override
  List<Object?> get props => [book, coverImage];
}

class UpdateBookEvent extends BookEvent {
  final Book book;
  final File? coverImage;
  const UpdateBookEvent({required this.book, this.coverImage});

  @override
  List<Object?> get props => [book, coverImage];
}

class DeleteBookEvent extends BookEvent {
  final String bookId;
  const DeleteBookEvent(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class CheckPendingQueueEvent extends BookEvent {
  const CheckPendingQueueEvent();
}

class SyncPendingBooksEvent extends BookEvent {
  const SyncPendingBooksEvent();
}
