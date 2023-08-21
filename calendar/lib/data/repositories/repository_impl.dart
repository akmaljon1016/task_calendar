import 'package:calendar/core/network/network_info.dart';
import 'package:calendar/core/network/result.dart';
import 'package:calendar/core/util/app_constants.dart';
import 'package:calendar/data/datasources/remote_datasource.dart';
import 'package:calendar/data/model/combined_model.dart';
import 'package:calendar/domain/repositories/repository.dart';

class RepositoryImpl extends Repository {
  final RemoteDataSourceImpl remoteDataSourceImpl;
  final NetworkInfo networkInfo;

  RepositoryImpl(
      {required this.remoteDataSourceImpl,
      required this.networkInfo});

  @override
  Future<Result<CombinedModel, Exception>> loadColorsAndDays() async {
    if (await networkInfo.isConnected) {
      try {
        var response = await remoteDataSourceImpl.loadColorsAndDays();
        return Success(response);
      } on CalendarException catch (e) {
        return Failure(CalendarException(message: e.message));
      }
    } else {
      return Failure(NoInternetException(message: noInternetError));
    }
  }
}
