import 'package:calendar/core/network/result.dart';
import 'package:calendar/core/util/app_constants.dart';

abstract class UseCase<Type, Params> {
  Future<Result<Type, Exception>> call(Params params);
}
