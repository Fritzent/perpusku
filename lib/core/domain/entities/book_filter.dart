import 'package:equatable/equatable.dart';

class BookFilter extends Equatable {
  final String? searchQuery;
  final int? year;
  final String? category;
  final int page;
  final int pageSize;

  const BookFilter({
    this.searchQuery,
    this.year,
    this.category,
    this.page = 1,
    this.pageSize = 10,
  });

  BookFilter copyWith({
    String? searchQuery,
    int? year,
    String? category,
    int? page,
    int? pageSize,
    bool clearSearch = false,
    bool clearYear = false,
    bool clearCategory = false,
  }) {
    return BookFilter(
      searchQuery: clearSearch ? null : searchQuery ?? this.searchQuery,
      year: clearYear ? null : year ?? this.year,
      category: clearCategory ? null : category ?? this.category,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  @override
  List<Object?> get props => [searchQuery, year, category, page, pageSize];
}

class PaginatedBooks {
  final List<dynamic> books;
  final int totalCount;
  final int currentPage;
  final int pageSize;

  const PaginatedBooks({
    required this.books,
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
  });

  int get totalPages => (totalCount / pageSize).ceil();
  bool get hasNextPage => currentPage < totalPages;
  bool get hasPreviousPage => currentPage > 1;
}
