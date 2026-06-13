import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:perpusku/core/domain/repositories/book_repository.dart';
import 'package:perpusku/core/domain/usecases/book_usecases.dart';
import 'package:perpusku/core/domain/usecases/sync_usecases.dart';
import 'package:perpusku/core/network/connectivity_service.dart';
import 'package:perpusku/data/datasources/local/offline_queue_local_datasource.dart';
import 'package:perpusku/data/datasources/remote/book_query.dart';
import 'package:perpusku/data/datasources/remote/book_storage_query.dart';
import 'package:perpusku/data/repositories/book_repository_impl.dart';
import 'package:perpusku/presentation/blocs/book/book_bloc.dart';
import 'package:perpusku/presentation/blocs/connectivity/connectivity_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  sl.registerLazySingleton<Logger>(() => Logger(
        printer: PrettyPrinter(methodCount: 2),
        level: Level.debug,
      ));

  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  sl.registerLazySingleton<SupabaseClient>(
    () => Supabase.instance.client,
  );

  sl.registerLazySingleton<ConnectivityService>(
    () => ConnectivityServiceImpl(sl()),
  );

  sl.registerLazySingleton(() => OfflineQueueLocalDataSource());

  sl.registerLazySingleton(() => BookQuery(sl()));
  sl.registerLazySingleton(() => BookStorageQuery(sl()));

  sl.registerLazySingleton<BookRepository>(
    () => BookRepositoryImpl(
      bookQuery: sl(),
      storageQuery: sl(),
      logger: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetBooksUseCase(sl()));
  sl.registerLazySingleton(() => GetBookByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreateBookUseCase(sl()));
  sl.registerLazySingleton(() => UpdateBookUseCase(sl()));
  sl.registerLazySingleton(() => DeleteBookUseCase(sl()));
  sl.registerLazySingleton(() => GetAvailableYearsUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => SyncPendingBooksUseCase(sl(), sl()));
  sl.registerLazySingleton(() => GetPendingCountUseCase(sl()));
  sl.registerLazySingleton(() => LoadPendingQueueUseCase(sl()));

  sl.registerFactory(() => BookBloc(
        getBooks: sl(),
        createBook: sl(),
        updateBook: sl(),
        deleteBook: sl(),
        getYears: sl(),
        getCategories: sl(),
        connectivity: sl(),
        offlineQueue: sl(),
        syncPending: sl(),
        getPendingCount: sl(),
      ));

  sl.registerFactory(() => ConnectivityBloc(sl()));
}