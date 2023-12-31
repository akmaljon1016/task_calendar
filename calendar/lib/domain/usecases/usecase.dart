import 'package:calendar/core/network/result.dart';
import 'package:calendar/core/usecases/usecase.dart';
import 'package:calendar/data/model/combined_model.dart';
import 'package:calendar/domain/repositories/repository.dart';

class CalendarUseCase extends UseCase<CombinedModel, UseCaseParams> {
  final Repository repository;

  CalendarUseCase({required this.repository});

  @override
  Future<Result<CombinedModel, Exception>> call(UseCaseParams params) async {
    return await repository.loadColorsAndDays();
  }
}

class UseCaseParams {
  ///this created and putted empty if some thing to add to params
}
