import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio() {
    _dio.options.baseUrl = 'https://api.example.com'; // Replace with your API base URL
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
  }

  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  void _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException('Connection timed out');
      case DioExceptionType.badResponse:
        throw BadResponseException('Bad response: ${e.response?.statusCode}');
      case DioExceptionType.cancel:
        throw RequestCancelledException('Request cancelled');
      default:
        throw NetworkException('Network error occurred');
    }
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
}

class BadResponseException implements Exception {
  final String message;
  BadResponseException(this.message);
}

class RequestCancelledException implements Exception {
  final String message;
  RequestCancelledException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}
