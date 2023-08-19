import 'package:calendar/core/network/result.dart';
import 'package:calendar/data/model/combined_model.dart';

abstract class Repository {
  Future<Result<CombinedModel, Exception>> loadColorsAndDays();
}
