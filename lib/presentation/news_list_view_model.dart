import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:kobkiat_it_assignment/core/base_view_model.dart';
import 'package:kobkiat_it_assignment/core/server_error.dart';
import 'package:kobkiat_it_assignment/domain/model/news.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

import '../domain/usecase/news_list_usecase.dart';

const List<String> topics = [
  "Latest",
  "Entertainment",
  "World",
  "Business",
  "Health",
  "Sport",
  "Science",
  "Technology",
];

@injectable
class NewsListViewModel extends BaseViewModel {
  final GetNewsListUseCase _getNewsListUseCase;

  NewsListViewModel(this._getNewsListUseCase);

  // Rx

  final BehaviorSubject<List<String>> _topicList =
      BehaviorSubject.seeded(topics);
  Stream<List<String>> get topicList => _topicList.stream;

  final BehaviorSubject<String> _topic = BehaviorSubject();
  Stream<String> get topic => _topic.stream;

  final BehaviorSubject<List<News>?> _newsList = BehaviorSubject();
  Stream<List<News>?> get newsList => _newsList.stream;

  final BehaviorSubject<List<News>> _savedList = BehaviorSubject.seeded([]);
  Stream<List<News>> get savedList => _savedList.stream;

  final PublishSubject<ServerError> _error = PublishSubject();
  Stream<ServerError> get error => _error.stream;

  // Method
  void onPageLoad() {
    onTopicChanged(topics.first);
  }

  void getNewsList(String topic) async {
    _newsList.add(null);
    final box = await Hive.openBox<News>(topic.toLowerCase());
    final result = await _getNewsListUseCase.execute(topic.toLowerCase());

    final newsList = result.when(
      success: (data) {
        box.clear();
        box.addAll(data);
        return data;
      },
      serverError: (error) {
        _error.add(error);
        return box.values.toList();
      },
      rateLimit: () {
        _error.add(const ServerError(
            message: "Limit exceeded, please try again later."));
        return box.values.toList();
      },
    );

    // Check whether fetched each fetched articles were already saved
    _newsList.add(newsList
        .map((e) => _savedList.value.contains(e.copyWith(isSaved: true))
            ? e.copyWith(isSaved: true)
            : e)
        .toList());
  }

  void onTopicChanged(String newTopic) {
    _topic.add(newTopic);
    getNewsList(newTopic);
  }

  void onThumbnailPressed(String url) async {
    await launchUrl(Uri.parse(url));
  }

  void onSave(News news) {
    List<News> newsList = List.of(_newsList.valueOrNull ?? []);
    final index = newsList.indexWhere((e) => e == news);

    final updatedNews = news.copyWith(isSaved: true);

    _savedList.add(_savedList.value..add(updatedNews));

    newsList[index] = updatedNews;
    _newsList.add(newsList);
  }

  void onUnsave(News news) {
    List<News> newsList = List.of(_newsList.value ?? []);
    final index = newsList.indexWhere((e) => e == news);

    final updatedNews = news.copyWith(isSaved: false);

    _savedList.add(_savedList.value..removeWhere((e) => e == news));

    newsList[index] = updatedNews;
    _newsList.add(newsList);
  }
}
