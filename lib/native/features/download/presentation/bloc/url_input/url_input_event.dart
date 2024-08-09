part of 'url_input_bloc.dart';

@immutable
sealed class UrlInputEvent {}

final class UrlInputChanged extends UrlInputEvent {
  final String url;

  UrlInputChanged(this.url);
}

final class UrlSubmitted extends UrlInputEvent {
  final String url;

  UrlSubmitted(this.url);
}
