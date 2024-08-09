import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'error_dialog_event.dart';
part 'error_dialog_state.dart';

class ErrorDialogBloc extends Bloc<ErrorDialogEvent, ErrorDialogState> {
  ErrorDialogBloc() : super(ErrorDialogClosed()) {
    on<ErrorOccur>(_onErrorOccur);
    on<DismissError>(_onDismissError);
  }

  _onErrorOccur(ErrorOccur event, Emitter<ErrorDialogState> emit) {
    final String errorMessage = event.errorMessage;
    emit(ErrorDialogOpened(errorMessage: errorMessage));
  }

  _onDismissError(DismissError event, Emitter<ErrorDialogState> emit) {}
}
