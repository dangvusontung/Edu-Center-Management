import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:edu_center_management/services/api_service.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ApiService apiService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    apiService = ApiService();
    apiService._dio = mockDio;
  });

  group('ApiService', () {
    test('GET request successful', () async {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: {'message': 'Success'},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await apiService.get('/test');
      expect(result, {'message': 'Success'});
    });

    test('POST request successful', () async {
      when(mockDio.post(any, data: anyNamed('data'))).thenAnswer((_) async => Response(
            data: {'id': 1, 'message': 'Created'},
            statusCode: 201,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await apiService.post('/test', data: {'name': 'Test'});
      expect(result, {'id': 1, 'message': 'Created'});
    });

    test('GET request throws TimeoutException', () async {
      when(mockDio.get(any)).thenThrow(DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: ''),
      ));

      expect(() => apiService.get('/test'), throwsA(isA<TimeoutException>()));
    });

    test('POST request throws BadResponseException', () async {
      when(mockDio.post(any, data: anyNamed('data'))).thenThrow(DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        ),
        requestOptions: RequestOptions(path: ''),
      ));

      expect(() => apiService.post('/test', data: {'name': 'Test'}), throwsA(isA<BadResponseException>()));
    });
  });
}
