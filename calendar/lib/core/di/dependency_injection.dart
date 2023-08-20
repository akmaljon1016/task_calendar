import 'package:calendar/core/network/app_interceptor.dart';
import 'package:calendar/core/network/network_info.dart';
import 'package:calendar/core/util/api_constants.dart';
import 'package:calendar/data/datasources/remote_datasource.dart';
import 'package:calendar/data/repositories/repository_impl.dart';
import 'package:calendar/domain/repositories/repository.dart';
import 'package:calendar/domain/usecases/usecase.dart';
import 'package:calendar/presentation/bloc/calendar_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final di = GetIt.instance;

Future<void> init() async {

  BaseOptions options = new BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: Duration(milliseconds: 15000),
    receiveTimeout: Duration(milliseconds: 15000),
  );
  final Dio dio = Dio(options);
  dio.interceptors.add(AppInterceptor());
  di.registerLazySingleton<Dio>(() => dio);

  /// Network Info
  di.registerLazySingleton(() => InternetConnectionChecker());
  di.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(di()));

  di.registerLazySingleton(
      () => RemoteDataSourceImpl(dio: di(), networkInfo: di()));

  di.registerLazySingleton<Repository>(() => RepositoryImpl(
      remoteDataSourceImpl: di(),
      networkInfo: di()));
  di.registerLazySingleton(() => CalendarUseCase(repository: di()));
  di.registerFactory(() => CalendarBloc(calendarUseCase: di()));
}
