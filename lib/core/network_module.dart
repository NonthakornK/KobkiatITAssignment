import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../env/env.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio() {
    final dio = Dio()
      ..options = BaseOptions(
          baseUrl: "https://google-news13.p.rapidapi.com",
          headers: {
            "x-rapidapi-key": Env.apiKey,
            "x-rapidapi-host": "google-news13.p.rapidapi.com"
          },
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15))
      ..interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
      ));

    return dio;
  }
}
