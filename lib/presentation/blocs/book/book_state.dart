import 'package:equatable/equatable.dart';
import 'package:perpusku/core/domain/entities/book.dart';
import 'package:perpusku/core/domain/entities/book_filter.dart';

enum BookStatus { initial, loading, success, failure, mutating }

class BookState extends Equatable {
  final BookStatus status;
  final List<Book> books;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final BookFilter filter;
  final String? errorMessage;
  final bool isMutating;
  final String? successMessage;
  final List<int> availableYears;
  final List<String> availableCategories;
  final int pendingCount; 
  final bool isSyncing;     
  final String? syncMessage;

  const BookState({
    this.status = BookStatus.initial,
    this.books = const [],
    this.totalCount = 0,
    this.currentPage = 1,
    this.totalPages = 1,
    this.filter = const BookFilter(),
    this.errorMessage,
    this.isMutating = false,
    this.successMessage,
    this.availableYears = const [],
    this.availableCategories = const [],
    this.pendingCount = 0,
    this.isSyncing = false,
    this.syncMessage,
  });

  bool get isEmpty => status == BookStatus.success && books.isEmpty;
  bool get isLoading => status == BookStatus.loading;
  bool get hasError => status == BookStatus.failure;
  bool get hasPending => pendingCount > 0;

  BookState copyWith({
    BookStatus? status,
    List<Book>? books,
    int? totalCount,
    int? currentPage,
    int? totalPages,
    BookFilter? filter,
    String? errorMessage,
    bool? isMutating,
    String? successMessage,
    List<int>? availableYears,
    List<String>? availableCategories,
    int? pendingCount,
    bool? isSyncing,
    String? syncMessage,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearSync = false,
  }) {
    return BookState(
      status: status ?? this.status,
      books: books ?? this.books,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      filter: filter ?? this.filter,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isMutating: isMutating ?? this.isMutating,
      successMessage:
          clearSuccess ? null : successMessage ?? this.successMessage,
      availableYears: availableYears ?? this.availableYears,
      availableCategories: availableCategories ?? this.availableCategories,
      pendingCount: pendingCount ?? this.pendingCount,
      isSyncing: isSyncing ?? this.isSyncing,
      syncMessage: clearSync ? null : syncMessage ?? this.syncMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        books,
        totalCount,
        currentPage,
        totalPages,
        filter,
        errorMessage,
        isMutating,
        successMessage,
        availableYears,
        availableCategories,
        pendingCount,
        isSyncing,
        syncMessage,
      ];
}
