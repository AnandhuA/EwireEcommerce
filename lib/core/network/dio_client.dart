import 'package:dio/dio.dart';
import 'package:ewire_ecommerce/core/network/api_urls.dart';

class DioClient {
  static final DioClient _instance = DioClient._();

  factory DioClient() => _instance;

  DioClient._();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiUrls.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    ),
  );
}