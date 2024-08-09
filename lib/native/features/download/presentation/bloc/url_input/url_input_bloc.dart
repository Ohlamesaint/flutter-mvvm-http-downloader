import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'url_input_event.dart';
part 'url_input_state.dart';

class UrlInputBloc extends Bloc<UrlInputEvent, UrlInputState> {
  UrlInputBloc() : super(UrlInputInitiated()) {
    on<UrlInputChanged>(onUrlInputChanged);
    on<UrlSubmitted>(onUrlSubmitted);
  }

  onUrlInputChanged(UrlInputChanged event, Emitter emit) {
    if (event.url == '') {
      return emit(UrlInputNoText());
    } else {
      return emit(UrlInputHasText());
    }
  }

  onUrlSubmitted(UrlSubmitted event, Emitter emit) {
    if (event.url == '') {
      return emit(UrlInputNoText());
    } else {
      return emit(UrlInputInitiated());
    }
  }
}
