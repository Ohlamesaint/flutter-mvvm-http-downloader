part of 'error_dialog_bloc.dart';

@immutable
sealed class ErrorDialogState {}

final class ErrorDialogClosed extends ErrorDialogState {}

final class ErrorDialogOpened extends ErrorDialogState {
  final String errorMessage;

  ErrorDialogOpened({required this.errorMessage});
}
