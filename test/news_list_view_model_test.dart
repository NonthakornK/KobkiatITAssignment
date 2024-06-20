import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kobkiat_it_assignment/core/server_error.dart';
import 'package:kobkiat_it_assignment/domain/model/news.dart';
import 'package:kobkiat_it_assignment/domain/usecase/news_list_usecase.dart';
import 'package:kobkiat_it_assignment/domain/usecase/news_list_usecase_result.dart';
import 'package:kobkiat_it_assignment/presentation/news_list_view_model.dart';
import 'package:mocktail/mocktail.dart';

class _MockHiveInterface extends Mock implements HiveInterface {}

class _MockHiveBox extends Mock implements Box {}

class _MockGetNewsListUseCase extends Mock implements GetNewsListUseCase {}

void initHive() {
  var path = Directory.current.path;
  Hive.init('$path/test');
}

const news = News(
  title: "title",
  snippet: "snippet",
  timestamp: "timestamp",
  newsUrl: "newsUrl",
  thumbnailUrl: "thumbnailUrl",
  isSaved: false,
);

const savedNews = News(
  title: "title",
  snippet: "snippet",
  timestamp: "timestamp",
  newsUrl: "newsUrl",
  thumbnailUrl: "thumbnailUrl",
  isSaved: true,
);

void main() {
  initHive();
  final mockHiveInterface = _MockHiveInterface();
  final mockHiveBox = _MockHiveBox();
  final mockGetNewsListUseCase = _MockGetNewsListUseCase();

  late NewsListViewModel viewModel;

  setUpAll(() {
    viewModel = NewsListViewModel(mockGetNewsListUseCase);
  });

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    when(() => mockHiveInterface.openBox(any()))
        .thenAnswer((_) async => mockHiveBox);
  });

  test("on page load", () async {
    when(() => mockGetNewsListUseCase.execute(any()))
        .thenAnswer((_) async => const NewsListUseCaseResult.success([news]));

    viewModel.onPageLoad();

    await expectLater(viewModel.topic, emits("Latest"));
    await expectLater(
        viewModel.newsList,
        emitsInOrder([
          null,
          [news]
        ]));
  });

  test("on save", () async {
    viewModel.onSave(news);

    await expectLater(viewModel.savedList, emits([savedNews]));
    await expectLater(viewModel.newsList, emits([savedNews]));
  });

  test("on unsave", () async {
    viewModel.onUnsave(savedNews);

    await expectLater(viewModel.savedList, emits([]));
    await expectLater(viewModel.newsList, emits([news]));
  });

  test("on fetch, rate limit", () async {
    when(() => mockGetNewsListUseCase.execute(any()))
        .thenAnswer((_) async => const NewsListUseCaseResult.rateLimit());

    viewModel.getNewsList('');

    await expectLater(
        viewModel.error,
        emits(const ServerError(
            message: "Limit exceeded, please try again later.")));
  });

  test("on fetch, server error", () async {
    when(() => mockGetNewsListUseCase.execute(any())).thenAnswer((_) async =>
        const NewsListUseCaseResult.serverError(
            ServerError(code: 500, message: "Server error")));

    viewModel.getNewsList('');

    await expectLater(viewModel.error,
        emits(const ServerError(code: 500, message: "Server error")));
  });
}
