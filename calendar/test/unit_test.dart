import 'dart:convert';

import 'package:calendar/core/network/network_info.dart';
import 'package:calendar/core/network/result.dart';
import 'package:calendar/data/datasources/remote_datasource.dart';
import 'package:calendar/data/model/combined_model.dart';
import 'package:calendar/data/model/day_model.dart';
import 'package:calendar/data/repositories/repository_impl.dart';
import 'package:calendar/domain/repositories/repository.dart';
import 'package:calendar/domain/usecases/usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/mockito.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late RemoteDataSourceImpl remoteDataSourceImpl;
  late Dio mockDioClient;
  late NetworkInfo networkInfo;
  late CalendarUseCase calendarUseCase;
  late MockRepository mockRepository;
  late RepositoryImpl repositoryImpl;
  final combined_model = CombinedModel(dayModel: DayModel(), dayColors: []);
  setUp(() {
    mockDioClient = Dio();
    networkInfo = NetworkInfoImpl(InternetConnectionChecker());
    remoteDataSourceImpl =
        RemoteDataSourceImpl(dio: mockDioClient, networkInfo: networkInfo);
    mockRepository = MockRepository();
    repositoryImpl = RepositoryImpl(
        remoteDataSourceImpl: remoteDataSourceImpl, networkInfo: networkInfo);
    calendarUseCase = CalendarUseCase(repository: mockRepository);
  });
  test("load days and colors", () async {
    final item = await remoteDataSourceImpl.loadColorsAndDays();
    expect(item.runtimeType,
        CombinedModel(dayModel: DayModel(), dayColors: []).runtimeType);
  });
}
