part of 'url_input_bloc.dart';

@immutable
sealed class UrlInputState {}

final class UrlInputInitiated extends UrlInputState {}

final class UrlInputNoText extends UrlInputState {}

final class UrlInputHasText extends UrlInputState {}
