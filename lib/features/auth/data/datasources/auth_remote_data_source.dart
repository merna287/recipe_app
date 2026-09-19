import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  /// Calls POST /auth/login on DummyJSON and returns parsed [LoginResponseModel].
  /// Throws [ServerException] or [NetworkException] on failure.
  Future<LoginResponseModel> login({
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

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ApiClient.handleError(
          'Failed to authenticate with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw ApiClient.handleError(e);
    }
  }
}
