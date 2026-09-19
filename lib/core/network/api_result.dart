import 'api_error_handler.dart';

sealed class ApiResult<T> {
  const ApiResult();
}

class Success<T> extends ApiResult<T> {
  final T data;

  const Success(this.data);
}

class Error<T> extends ApiResult<T> {
  final ApiErrorHandler error;

  const Error(this.error);
}
