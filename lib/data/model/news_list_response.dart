import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_list_response.g.dart';
part 'news_list_response.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class NewsListResponse with _$NewsListResponse {
  const factory NewsListResponse({
    String? status,
    List<NewsResponse>? items,
  }) = _NewsListResponse;

  factory NewsListResponse.fromJson(Map<String, Object?> json) =>
      _$NewsListResponseFromJson(json);
}

@freezed
class NewsResponse with _$NewsResponse {
  const factory NewsResponse({
    required String title,
    required String snippet,
    required String publisher,
    required String timestamp,
    required String newsUrl,
    ImageResponse? images,
    required bool hasSubnews,
    List<SubNewsResponse>? subnews,
  }) = _NewsResponse;

  factory NewsResponse.fromJson(Map<String, Object?> json) =>
      _$NewsResponseFromJson(json);
}

@freezed
class SubNewsResponse with _$SubNewsResponse {
  const factory SubNewsResponse({
    required String title,
    required String snippet,
    required String publisher,
    required String timestamp,
    required String newsUrl,
    ImageResponse? images,
  }) = _SubNewsResponse;

  factory SubNewsResponse.fromJson(Map<String, Object?> json) =>
      _$SubNewsResponseFromJson(json);
}

@freezed
class ImageResponse with _$ImageResponse {
  const factory ImageResponse({
    required String thumbnail,
    required String thumbnailProxied,
  }) = _ImageResponse;

  factory ImageResponse.fromJson(Map<String, Object?> json) =>
      _$ImageResponseFromJson(json);
}
