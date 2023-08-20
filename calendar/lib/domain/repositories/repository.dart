import 'package:calendar/core/network/result.dart';
import 'package:calendar/core/util/app_constants.dart';
import 'package:calendar/data/model/combined_model.dart';

abstract class Repository {
  Future<Result<CombinedModel, Exception>> loadColorsAndDays();
}
