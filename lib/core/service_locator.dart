import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:fluttershop/core/config/app_config.dart';
import 'package:fluttershop/features/product/data/datasources/product_remote_data_source.dart';
import 'package:fluttershop/features/product/data/repositories/product_repository_impl.dart';
import 'package:fluttershop/features/product/domain/repositories/product_repository.dart';
import 'package:fluttershop/features/product/domain/usecases/get_products_usecase.dart';
import 'package:fluttershop/features/product/domain/usecases/toggle_favorite_usecase.dart';
import 'package:fluttershop/features/product/domain/usecases/get_product_details_usecase.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // External
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => Dio(BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      )));

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => GetProductDetailsUseCase(sl()));
}
