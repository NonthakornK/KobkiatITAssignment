import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_error.freezed.dart';

@freezed
class ServerError with _$ServerError implements Exception {
  const factory ServerError({
    int? code,
    String? message,
  }) = _ServerError;
}
