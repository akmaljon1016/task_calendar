part of 'calendar_bloc.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();
}

class CalendarInitial extends CalendarState {
  @override
  List<Object> get props => [];
}

class CalendarLoading extends CalendarState {
  @override
  List<Object> get props => [];
}

class CalendarSuccess extends CalendarState {
  final CombinedModel combinedModel;

  const CalendarSuccess({required this.combinedModel});

  @override
  List<Object> get props => [combinedModel];
}

class CalendarFailure extends CalendarState {
  final String message;

  const CalendarFailure({required this.message});

  @override
  List<Object> get props => [message];
}
