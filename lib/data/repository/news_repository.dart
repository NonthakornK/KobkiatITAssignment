import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:kobkiat_it_assignment/core/server_error.dart';
import 'package:kobkiat_it_assignment/domain/model/news.dart';

import '../../domain/mapper/news_list_mapper.dart';
import '../service/news_service.dart';

abstract class NewsRepository {
  Future<List<News>> getNewsList(String topic);
}

@Singleton(as: NewsRepository)
class NewsRepositoryImpl extends NewsRepository {
  final NewsService _newsService;
  final NewsListMapper _newsListMapper;

  NewsRepositoryImpl(
    this._newsService,
    this._newsListMapper,
  );

  @override
  Future<List<News>> getNewsList(String topic) async {
    try {
      final response = await _newsService.getNewsList(topic, "en-US");
      final newsList = _newsListMapper.map(response.data.items);
      return newsList;
    } on DioException catch (e) {
      throw ServerError(
        code: e.response?.statusCode,
        message: e.response?.statusMessage,
      );
    }
  }
}
