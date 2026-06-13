import 'package:perpusku/core/constant/app_constant.dart';
import 'package:perpusku/core/domain/entities/book_filter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookQuery {
  final SupabaseClient _client;

  BookQuery(this._client);

  SupabaseQueryBuilder get _table =>
      _client.from(AppConstants.booksTable);

  Future<List<Map<String, dynamic>>> fetchBooks(BookFilter filter) async {
    final from = (filter.page - 1) * filter.pageSize;
    final to = from + filter.pageSize - 1;

    var query = _table.select('*');

    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      query = query.or(
        'title.ilike.%${filter.searchQuery}%,author.ilike.%${filter.searchQuery}%',
      );
    }

    if (filter.year != null) {
      query = query.eq('year', filter.year!);
    }

    if (filter.category != null && filter.category!.isNotEmpty) {
      query = query.eq('category', filter.category!);
    }

    final response = await query
        .order('created_at', ascending: false)
        .range(from, to);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<int> countBooks(BookFilter filter) async {
    final response = await _applyFilters(
      _table.select('id'),
      filter,
    ).count(CountOption.exact);

    return response.count ?? 0;
  }

  dynamic _applyFilters(
    dynamic query,
    BookFilter filter,
  ) {
    if (filter.searchQuery?.isNotEmpty ?? false) {
      query = query.or(
        'title.ilike.%${filter.searchQuery}%,author.ilike.%${filter.searchQuery}%',
      );
    }

    if (filter.year != null) {
      query = query.eq('year', filter.year!);
    }

    if (filter.category?.isNotEmpty ?? false) {
      query = query.eq('category', filter.category!);
    }

    return query;
  }

  Future<Map<String, dynamic>?> fetchBookById(String id) async {
    final response = await _table
        .select('*')
        .eq('id', id)
        .maybeSingle();
    return response;
  }

  Future<Map<String, dynamic>> insertBook(
      Map<String, dynamic> data) async {
    final response = await _table
        .insert(data)
        .select()
        .single();
    return Map<String, dynamic>.from(response);
  }

  Future<Map<String, dynamic>> updateBook(
      String id, Map<String, dynamic> data) async {
    final response = await _table
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return Map<String, dynamic>.from(response);
  }

  Future<void> deleteBook(String id) async {
    await _table.delete().eq('id', id);
  }

  Future<List<int>> fetchDistinctYears() async {
    final response = await _table
        .select('year')
        .order('year', ascending: false);
    final years = (response as List)
        .map((e) => e['year'] as int)
        .toSet()
        .toList();
    return years;
  }

  Future<List<String>> fetchDistinctCategories() async {
    final response = await _table
        .select('category')
        .order('category');
    final cats = (response as List)
        .map((e) => e['category'] as String)
        .toSet()
        .toList();
    return cats;
  }
}
