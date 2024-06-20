import 'package:injectable/injectable.dart';
import 'package:kobkiat_it_assignment/core/server_error.dart';

import '../../data/repository/news_repository.dart';
import 'news_list_usecase_result.dart';

abstract class GetNewsListUseCase {
  Future<NewsListUseCaseResult> execute(String topic);
}

@Injectable(as: GetNewsListUseCase)
class GetNewsListUseCaseImpl implements GetNewsListUseCase {
  final NewsRepository _newsRepository;

  GetNewsListUseCaseImpl(this._newsRepository);

  @override
  Future<NewsListUseCaseResult> execute(String topic) async {
    try {
      final result = await _newsRepository.getNewsList(topic);
      return NewsListUseCaseResult.success(result);
    } on ServerError catch (e) {
      switch (e.code) {
        case 429:
          return const NewsListUseCaseResult.rateLimit();
        default:
          return NewsListUseCaseResult.serverError(e);
      }
    }
  }
}
