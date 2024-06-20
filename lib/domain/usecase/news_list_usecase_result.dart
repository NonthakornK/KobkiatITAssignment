import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kobkiat_it_assignment/core/server_error.dart';
import 'package:kobkiat_it_assignment/domain/model/news.dart';

part 'news_list_usecase_result.freezed.dart';

@freezed
class NewsListUseCaseResult with _$NewsListUseCaseResult {
  const factory NewsListUseCaseResult.success(List<News> response) = _$Success;

  const factory NewsListUseCaseResult.serverError(ServerError error) =
      _$ServerError;

  const factory NewsListUseCaseResult.rateLimit() = _$RateLimit;
}
