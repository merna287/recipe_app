import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_profile_model.dart';

/// Contract for fetching profile data remotely via HTTP/REST.
abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl(this._dio);

  @override
  Future<UserProfileModel> getProfile() async {
    try {
      final response = await _dio.get(
        ApiConstants.meEndpoint,
      );

      final json = ApiClient.parseJsonMap(response.data);
      if (response.statusCode == 200 && json != null) {
        return UserProfileModel.fromJson(json);
      }

      throw ServerException(
        message: 'Failed to fetch user profile (status ${response.statusCode}).',
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
}
