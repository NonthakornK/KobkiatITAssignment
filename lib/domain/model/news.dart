import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'news.freezed.dart';
part 'news.g.dart';

@freezed
@HiveType(typeId: 0)
class News with _$News {
  const factory News({
    @HiveField(0) required String title,
    @HiveField(1) required String snippet,
    @HiveField(2) required String timestamp,
    @HiveField(3) required String newsUrl,
    @HiveField(4) String? thumbnailUrl,
    @HiveField(5) required bool isSaved,
  }) = _News;
}
