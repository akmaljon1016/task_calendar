import 'package:calendar/core/di/dependency_injection.dart';
import 'package:calendar/core/network/network_info.dart';
import 'package:calendar/core/util/api_constants.dart';
import 'package:calendar/data/model/combined_model.dart';
import 'package:calendar/data/model/day_color.dart';
import 'package:calendar/data/model/day_model.dart';
import 'package:dio/dio.dart';

abstract class RemoteDataSource {
  Future<CombinedModel> loadColorsAndDays();
}

class RemoteDataSourceImpl extends RemoteDataSource {
  final Dio dio;
  final NetworkInfo networkInfo;

  RemoteDataSourceImpl({required this.dio, required this.networkInfo});

  @override
  Future<CombinedModel> loadColorsAndDays() async {
    if (await networkInfo.isConnected) {
      try {
        var responseDays = await dio.get(baseUrl + dayApiPath);
        var responseColors = await dio.get(baseUrl + colorApiPath);
        if (responseDays.statusCode == 200 &&
            responseColors.statusCode == 200) {
          DayModel dayModel = DayModel.fromJson(responseDays.data);
          List<DayColor> dayColors = dayColorListFromJson(responseColors.data);
          CombinedModel combinedModel =
              CombinedModel(dayModel: dayModel, dayColors: dayColors);
          return combinedModel;
        } else {
          throw Exception("Server Error");
        }
      } on DioException catch (e) {
        throw Exception(e);
      }
    } else {
      throw Exception("Internet yo'q");
    }
  }
}
