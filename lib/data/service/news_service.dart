import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../model/news_list_response.dart';

part 'news_service.g.dart';

@singleton
@RestApi()
abstract class NewsService {
  @factoryMethod
  factory NewsService(Dio dio) => _NewsService(dio);

  @GET('/{topic}')
  Future<HttpResponse<NewsListResponse>> getNewsList(
      @Path() String topic, @Query('lr') String languageRegion);
}
