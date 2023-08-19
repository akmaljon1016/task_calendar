import 'package:calendar/core/network/network_info.dart';
import 'package:calendar/core/network/result.dart';
import 'package:calendar/data/datasources/local_datasource.dart';
import 'package:calendar/data/datasources/remote_datasource.dart';
import 'package:calendar/data/model/combined_model.dart';
import 'package:calendar/domain/repositories/repository.dart';

class RepositoryImpl extends Repository {
  final RemoteDataSourceImpl remoteDataSourceImpl;
  final LocalDataSourceImpl localDataSourceImpl;
  final NetworkInfo networkInfo;

  RepositoryImpl(
      {required this.remoteDataSourceImpl,
      required this.localDataSourceImpl,
      required this.networkInfo});

  @override
  Future<Result<CombinedModel, Exception>> loadColorsAndDays() async {
    if (await networkInfo.isConnected) {
      try {
        var response = await remoteDataSourceImpl.loadColorsAndDays();
        return Success(response);
      } on Exception catch (e) {
        return Failure(Exception(e));
      }
    } else {
      return Failure(Exception("Internet yo'q"));
    }
  }
}
