import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/login_response_model.dart';
import '../models/register_response_model.dart';

abstract class AuthRemoteDataSource {
  /// Calls POST /auth/login on DummyJSON and returns parsed [LoginResponseModel].
  /// Throws [ServerException] or [NetworkException] on failure.
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  });

  Future<RegisterResponseModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        data: {
          'username': username.trim(),
          'password': password.trim(),
        },
        options: Options(
          extra: {'requiresAuth': false},
        ),
      );

      final json = ApiClient.parseJsonMap(response.data);
      if (response.statusCode == 200 && json != null) {
        return LoginResponseModel.fromJson(json);
      }

      throw ServerException(
        message: 'Unexpected login response (status ${response.statusCode}).',
        statusCode: response.statusCode,
      );
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  @override
  Future<RegisterResponseModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.registerEndpoint,
        data: <String, String>{
          'firstName': firstName.trim(),
          'lastName': lastName.trim(),
          'email': email.trim(),
          'username': username.trim(),
          'password': password.trim(),
        },
        options: Options(
          extra: {'requiresAuth': false},
        ),
      );

      final statusCode = response.statusCode;
      final isSuccess = statusCode == 200 || statusCode == 201;
      final json = ApiClient.parseJsonMap(response.data);
      if (isSuccess && json != null) {
        return RegisterResponseModel.fromJson(json);
      }

      throw ServerException(
        message: 'Unexpected register response (status $statusCode).',
        statusCode: statusCode,
      );
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ApiClient.handleError(e);
    }
  }
}
