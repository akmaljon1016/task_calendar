import 'package:calendar/core/network/result.dart';

abstract class UseCase<Type, Params> {
  Future<Result<Type, Exception>> call(Params params);
}
