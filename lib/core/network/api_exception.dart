import 'package:dio/dio.dart';

class ApiException {
  static String handle(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';

      case DioExceptionType.receiveTimeout:
        return 'Server response timeout';

      case DioExceptionType.sendTimeout:
        return 'Request timeout';

      case DioExceptionType.connectionError:
        return 'No internet connection';

      case DioExceptionType.badResponse:
        return _handleStatusCode(e.response?.statusCode);

      case DioExceptionType.cancel:
        return 'Request cancelled';

      default:
        return 'Unexpected error occurred';
    }
  }

  static String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';

      case 401:
        return 'Unauthorized';

      case 403:
        return 'Forbidden';

      case 404:
        return 'Data not found';

      case 500:
        return 'Internal server error';

      default:
        return 'Something went wrong';
    }
  }
}