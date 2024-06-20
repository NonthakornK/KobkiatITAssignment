import 'package:flutter/material.dart';
import 'package:kobkiat_it_assignment/core/base_state.dart';
import 'package:kobkiat_it_assignment/core/state_awareness_view_model.dart';
import 'package:kobkiat_it_assignment/presentation/news_list_view_model.dart';
import 'package:rxdart/rxdart.dart';

import '../domain/model/news.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  static const routeName = "/";

  @override
  State<StatefulWidget> createState() => _NewListPageState();
}

class _NewListPageState extends BaseState<NewsListPage>
    with StateAwarenessViewModel<NewsListViewModel, NewsListPage> {
  late final NewsListViewModel _viewModel = viewModel();
  String _topic = '';
  int _navigationIndex = 0;
  int _newsIndex = 0;

  @override
  void initState() {
    super.initState();
    _viewModel.onPageLoad();
    _subscribeToViewModel();
  }

  void _subscribeToViewModel() {
    _viewModel.topic.listen((topic) {
      setState(() {
        _topic = topic;
      });
    }).addTo(compositeSubscription);

    _viewModel.error.listen((error) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Error",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 12),
                  child: Text(error.message ??
                      "Something went wrong, please try again"),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[300],
                          foregroundColor: Colors.white
                        ),
                        onPressed: Navigator.of(context).pop,
                        child: const Text("Ok"),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }).addTo(compositeSubscription);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navigationIndex,
        onDestinationSelected: (value) {
          setState(() {
            _navigationIndex = value;
            _newsIndex = 0;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outlined),
            label: 'Saved',
          ),
        ],
      ),
      body: SafeArea(
        child: switch (_navigationIndex) {
          0 => _buildHome(),
          1 => _buildSaved(),
          _ => const SizedBox(),
        },
      ),
    );
  }

  Widget _buildHome() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMenuBar(),
            )
          ],
        ),
        Expanded(
          child: StreamBuilder<List<News>?>(
            stream: _viewModel.newsList,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final newsList = snapshot.data!;
              if (newsList.isEmpty) {
                return Center(
                  child: Text(
                    "The list is empty",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                );
              }
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: _newsIndex > 0,
                      replacement: SizedBox.fromSize(
                        size: const Size.square(48),
                      ),
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (_newsIndex > 0) {
                                _newsIndex--;
                              }
                            });
                          },
                          icon: const Icon(Icons.arrow_back_rounded)),
                    ),
                    Flexible(child: _buildCard(newsList[_newsIndex])),
                    Visibility(
                      visible: _newsIndex < newsList.length - 1,
                      replacement: SizedBox.fromSize(
                        size: const Size.square(48),
                      ),
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (_newsIndex < newsList.length - 1) {
                                _newsIndex++;
                              }
                            });
                          },
                          icon: const Icon(Icons.arrow_forward_rounded)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSaved() {
    return StreamBuilder<List<News>>(
        stream: _viewModel.savedList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final savedList = snapshot.data!;
          if (savedList.isEmpty) {
            return Center(
              child: Text(
                "The list is empty",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            );
          }
          return ListView(
            children: savedList
                .map((e) =>
                    Align(alignment: Alignment.center, child: _buildCard(e)))
                .toList(),
          );
        });
  }

  Widget _buildMenuBar() {
    return StreamBuilder<List<String>>(
      stream: _viewModel.topicList,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        }
        return MenuBar(
          children: [
            SubmenuButton(
              trailingIcon: const Icon(Icons.arrow_drop_down),
              menuChildren: snapshot.data!
                  .map((e) => MenuItemButton(
                        onPressed: () => _viewModel.onTopicChanged(e),
                        child: Text(e),
                      ))
                  .toList(),
              child: Text(_topic),
            )
          ],
        );
      },
    );
  }

  Widget _buildCard(News news) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => _viewModel.onThumbnailPressed(news.newsUrl),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                child: Image.network(
                  news.thumbnailUrl ?? '',
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      width: 280,
                      height: 168,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 280,
                    height: 168,
                    color: Colors.black26,
                    child: Center(
                        child: Text(
                      "No Image",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white),
                    )),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        news.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          news.snippet,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        "Timestamp: ${news.timestamp}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  if (news.isSaved) {
                    _viewModel.onUnsave(news);
                  } else {
                    _viewModel.onSave(news);
                  }
                },
                icon: Icon(
                  Icons.bookmark,
                  color: news.isSaved ? Colors.deepPurpleAccent : Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
