import 'package:injectable/injectable.dart';

import '../../data/model/news_list_response.dart';
import '../model/news.dart';

@injectable
class NewsListMapper {
  List<News> map(List<NewsResponse>? response) {
    return response
            ?.map(
              (e) => News(
                title: e.title,
                snippet: e.snippet,
                timestamp: e.timestamp,
                newsUrl: e.newsUrl,
                thumbnailUrl: e.images?.thumbnail,
                isSaved: false,
              ),
            )
            .toList() ??
        [];
  }
}
