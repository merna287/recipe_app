import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/core/errors/exceptions.dart';
import 'package:recipe_app/core/network/api_client.dart';

void main() {
  test('handleError extracts message from JSON string badResponse body', () {
    final error = DioException(
      requestOptions: RequestOptions(path: '/auth/login'),
      response: Response(
        requestOptions: RequestOptions(path: '/auth/login'),
        statusCode: 400,
        data: '{"message":"Invalid credentials"}',
      ),
      type: DioExceptionType.badResponse,
    );

    final result = ApiClient.handleError(error);

    expect(result, isA<ServerException>());
    expect((result as ServerException).message, 'Invalid credentials');
    expect(result.statusCode, 400);
  });

  test('parseJsonMap parses JSON string success body', () {
    const body = '{"id":1,"username":"emilys"}';
    final map = ApiClient.parseJsonMap(body);

    expect(map, isNotNull);
    expect(map!['username'], 'emilys');
  });

  test('handleError rethrows existing ServerException', () {
    const original = ServerException(message: 'Invalid credentials', statusCode: 400);
    final result = ApiClient.handleError(original);

    expect(identical(result, original), isTrue);
  });
}
