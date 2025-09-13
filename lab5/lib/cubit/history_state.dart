// history_state.dart
part of 'history_cubit.dart';

@immutable
abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<Map<String, dynamic>> calculations;

  HistoryLoaded(this.calculations);
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}
