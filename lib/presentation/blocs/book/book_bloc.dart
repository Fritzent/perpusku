import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perpusku/core/domain/entities/book_filter.dart';
import 'package:perpusku/core/domain/usecases/book_usecases.dart';
import 'package:perpusku/core/domain/usecases/sync_usecases.dart';
import 'package:perpusku/core/network/connectivity_service.dart';
import 'package:perpusku/data/datasources/local/offline_queue_local_datasource.dart';
import 'book_event.dart';
import 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final GetBooksUseCase _getBooks;
  final CreateBookUseCase _createBook;
  final UpdateBookUseCase _updateBook;
  final DeleteBookUseCase _deleteBook;
  final GetAvailableYearsUseCase _getYears;
  final GetCategoriesUseCase _getCategories;
  final ConnectivityService _connectivity;
  final OfflineQueueLocalDataSource _offlineQueue;
  final SyncPendingBooksUseCase _syncPending;
  final GetPendingCountUseCase _getPendingCount;

  BookBloc({
    required this._getBooks,
    required this._createBook,
    required this._updateBook,
    required this._deleteBook,
    required this._getYears,
    required this._getCategories,
    required this._connectivity,
    required this._offlineQueue,
    required this._syncPending,
    required this._getPendingCount,
  })  : super(const BookState()) {
    on<LoadBooksEvent>(_onLoad);
    on<RefreshBooksEvent>(_onRefresh);
    on<SearchBooksEvent>(_onSearch);
    on<FilterByYearEvent>(_onFilterYear);
    on<FilterByCategoryEvent>(_onFilterCategory);
    on<ChangePageEvent>(_onChangePage);
    on<CreateBookEvent>(_onCreate);
    on<UpdateBookEvent>(_onUpdate);
    on<DeleteBookEvent>(_onDelete);
    on<CheckPendingQueueEvent>(_onCheckQueue);
    on<SyncPendingBooksEvent>(_onSync);
  }

  Future<void> _onLoad(LoadBooksEvent event, Emitter<BookState> emit) async {
    emit(state.copyWith(status: BookStatus.loading, filter: event.filter));
    await _fetchBooks(event.filter, emit);
    await _loadMeta(emit);
    add(const CheckPendingQueueEvent());
  }

  Future<void> _onRefresh(
      RefreshBooksEvent event, Emitter<BookState> emit) async {
    emit(state.copyWith(status: BookStatus.loading));
    await _fetchBooks(state.filter, emit);
    add(const CheckPendingQueueEvent());
  }

  Future<void> _onSearch(
      SearchBooksEvent event, Emitter<BookState> emit) async {
    final newFilter = state.filter.copyWith(
      searchQuery: event.query.isEmpty ? null : event.query,
      page: 1,
      clearSearch: event.query.isEmpty,
    );
    emit(state.copyWith(status: BookStatus.loading, filter: newFilter));
    await _fetchBooks(newFilter, emit);
  }

  Future<void> _onFilterYear(
      FilterByYearEvent event, Emitter<BookState> emit) async {
    final newFilter = state.filter.copyWith(
      year: event.year,
      page: 1,
      clearYear: event.year == null,
    );
    emit(state.copyWith(status: BookStatus.loading, filter: newFilter));
    await _fetchBooks(newFilter, emit);
  }

  Future<void> _onFilterCategory(
      FilterByCategoryEvent event, Emitter<BookState> emit) async {
    final newFilter = state.filter.copyWith(
      category: event.category,
      page: 1,
      clearCategory: event.category == null,
    );
    emit(state.copyWith(status: BookStatus.loading, filter: newFilter));
    await _fetchBooks(newFilter, emit);
  }

  Future<void> _onChangePage(
      ChangePageEvent event, Emitter<BookState> emit) async {
    final newFilter = state.filter.copyWith(page: event.page);
    emit(state.copyWith(status: BookStatus.loading, filter: newFilter));
    await _fetchBooks(newFilter, emit);
  }

  Future<void> _onCreate(
      CreateBookEvent event, Emitter<BookState> emit) async {
    emit(state.copyWith(isMutating: true, clearError: true));

    final isOnline = await _connectivity.isConnected;

    if (!isOnline) {
      await _offlineQueue.enqueueCreate(
        event.book,
        localCoverPath: event.coverImage?.path,
      );
      final count = await _getPendingCount();
      emit(state.copyWith(
        isMutating: false,
        successMessage: 'savedOffline',
        pendingCount: count,
      ));
      return;
    }

    final result = await _createBook(event.book, coverImage: event.coverImage);
    result.fold(
      (failure) => emit(state.copyWith(
        isMutating: false,
        errorMessage: failure.message,
      )),
      (_) {
        emit(state.copyWith(
          isMutating: false,
          successMessage: 'bookSavedSuccess',
        ));
        add(const RefreshBooksEvent());
      },
    );
  }

  Future<void> _onUpdate(
      UpdateBookEvent event, Emitter<BookState> emit) async {
    emit(state.copyWith(isMutating: true, clearError: true));

    final isOnline = await _connectivity.isConnected;

    if (!isOnline) {
      await _offlineQueue.enqueueUpdate(
        event.book,
        localCoverPath: event.coverImage?.path,
      );
      final count = await _getPendingCount();
      emit(state.copyWith(
        isMutating: false,
        successMessage: 'savedOffline',
        pendingCount: count,
      ));
      return;
    }

    final result = await _updateBook(event.book, coverImage: event.coverImage);
    result.fold(
      (failure) => emit(state.copyWith(
        isMutating: false,
        errorMessage: failure.message,
      )),
      (_) {
        emit(state.copyWith(
          isMutating: false,
          successMessage: 'bookSavedSuccess',
        ));
        add(const RefreshBooksEvent());
      },
    );
  }

  Future<void> _onDelete(
      DeleteBookEvent event, Emitter<BookState> emit) async {
    emit(state.copyWith(isMutating: true, clearError: true));
    final result = await _deleteBook(event.bookId);
    result.fold(
      (failure) => emit(state.copyWith(
        isMutating: false,
        errorMessage: failure.message,
      )),
      (_) {
        emit(state.copyWith(
          isMutating: false,
          successMessage: 'bookRemovedSuccess',
          books: state.books.where((b) => b.id != event.bookId).toList(),
        ));
        add(const RefreshBooksEvent());
      },
    );
  }

  Future<void> _fetchBooks(
      BookFilter filter, Emitter<BookState> emit) async {
    final result = await _getBooks(filter);
    result.fold(
      (failure) => emit(state.copyWith(
        status: BookStatus.failure,
        errorMessage: failure.message,
      )),
      (paginated) => emit(state.copyWith(
        status: BookStatus.success,
        books: List.from(paginated.books),
        totalCount: paginated.totalCount,
        currentPage: paginated.currentPage,
        totalPages: paginated.totalPages,
        filter: filter,
        clearError: true,
      )),
    );
  }

  Future<void> _loadMeta(Emitter<BookState> emit) async {
    final yearsFuture = _getYears();
    final catsFuture = _getCategories();

    final yearsResult = await yearsFuture;
    final catsResult = await catsFuture;

    if (emit.isDone) return;

    emit(
      state.copyWith(
        availableYears: yearsResult.getOrElse(() => []),
        availableCategories: catsResult.getOrElse(() => []),
      ),
    );
  }

  Future<void> _onCheckQueue(
      CheckPendingQueueEvent event, Emitter<BookState> emit) async {
    final count = await _getPendingCount();
    emit(state.copyWith(pendingCount: count));
  }
  Future<void> _onSync(
      SyncPendingBooksEvent event, Emitter<BookState> emit) async {
    final isOnline = await _connectivity.isConnected;
    if (!isOnline) {
      emit(state.copyWith(syncMessage: 'syncFailedOffline'));
      return;
    }

    emit(state.copyWith(isSyncing: true, clearSync: true));

    final result = await _syncPending();

    result.fold(
      (failure) => emit(state.copyWith(
        isSyncing: false,
        syncMessage: 'syncFailed',
        pendingCount: state.pendingCount,
      )),
      (synced) {
        emit(state.copyWith(
          isSyncing: false,
          pendingCount: 0,
          syncMessage: 'syncSuccess',
        ));
        add(const RefreshBooksEvent());
      },
    );
  }
}
