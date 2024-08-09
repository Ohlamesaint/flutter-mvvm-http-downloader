part of 'error_dialog_bloc.dart';

// force to exhaust the switch cases
@immutable
sealed class ErrorDialogEvent {}

// avoid inheritance
final class ErrorOccur extends ErrorDialogEvent {
  final String errorMessage;

  ErrorOccur(this.errorMessage);
}

// avoid inheritance
final class DismissError extends ErrorDialogEvent {}
