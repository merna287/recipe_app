class ApiErrorModel {
  final int? status;
  final String? message;
  final dynamic errors;

  const ApiErrorModel({
    this.status,
    this.message,
    this.errors,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    int? parseStatus(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    String? parseMessage(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is List && value.isNotEmpty) {
        return value.map((e) => e.toString()).join(', ');
      }
      return value.toString();
    }

    return ApiErrorModel(
      status: parseStatus(json['status'] ?? json['statusCode'] ?? json['code']),
      message: parseMessage(json['message'] ?? json['error']),
      errors: json['errors'],
    );
  }

  /// Safely extracts error details if available as a single string.
  String? getFormattedErrors() {
    if (errors == null) return null;
    if (errors is String) return errors as String;
    if (errors is List) return (errors as List).join(', ');
    if (errors is Map) {
      final entries = (errors as Map).entries.map((e) => '${e.key}: ${e.value}');
      return entries.join(', ');
    }
    return errors.toString();
  }
}
