import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:calendar/core/network/result.dart';
import 'package:calendar/data/model/combined_model.dart';
import 'package:calendar/domain/usecases/usecase.dart';
import 'package:equatable/equatable.dart';

part 'calendar_event.dart';

part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CalendarUseCase calendarUseCase;

  CalendarBloc({required this.calendarUseCase}) : super(CalendarInitial()) {
    on<LoadCalendarEvent>(loadCalendar);
  }

  FutureOr<void> loadCalendar(
      LoadCalendarEvent event, Emitter<CalendarState> emit) async {
    emit(CalendarLoading());
    final result = await calendarUseCase(UseCaseParams());
    final value = switch (result) {
      Success(value: final combined) =>
        emit(CalendarSuccess(combinedModel: combined)),
      Failure(exception: final exception) => {
          if (exception is CalendarException)
            {emit(CalendarFailure(message: exception.message))}
          else if (exception is NoInternetException)
            {emit(CalendarFailure(message: exception.message))}
        }
    };
  }
}
