import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/recipe_model.dart';

/// Contract for fetching recipe data remotely via HTTP/REST.
abstract class RecipeRemoteDataSource {
  Future<List<RecipeModel>> getRecipes({int limit = 30, int skip = 0});
  Future<List<RecipeModel>> searchRecipes(String query);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final Dio _dio;

  RecipeRemoteDataSourceImpl(this._dio);

  @override
  Future<List<RecipeModel>> getRecipes({int limit = 30, int skip = 0}) async {
    try {
      final response = await _dio.get(
        ApiConstants.recipesEndpoint,
        queryParameters: {
          'limit': limit,
          'skip': skip,
        },
      );

      final json = ApiClient.parseJsonMap(response.data);
      if (response.statusCode == 200 && json != null) {
        final list = json['recipes'] as List<dynamic>? ?? [];
        return list
            .map((item) => RecipeModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      throw ServerException(
        message: 'Failed to load recipes (status ${response.statusCode}).',
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
  Future<List<RecipeModel>> searchRecipes(String query) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.recipesEndpoint}/search',
        queryParameters: {
          'q': query.trim(),
        },
      );

      final json = ApiClient.parseJsonMap(response.data);
      if (response.statusCode == 200 && json != null) {
        final list = json['recipes'] as List<dynamic>? ?? [];
        return list
            .map((item) => RecipeModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      throw ServerException(
        message: 'Failed to search recipes (status ${response.statusCode}).',
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
