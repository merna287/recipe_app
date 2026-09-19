import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../constants/api_constants.dart';

void configureDio(Dio dio) {
  if (dio.httpClientAdapter is! IOHttpClientAdapter) {
    return;
  }

  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client = HttpClient();
    client.connectionTimeout = ApiConstants.connectTimeout;

    client.connectionFactory = (uri, host, port) async {
      final effectivePort = port ?? (uri.scheme == 'https' ? 443 : 80);
      final addresses = await InternetAddress.lookup(
        uri.host,
        type: InternetAddressType.IPv4,
      );
      final address = addresses.first;

      if (uri.scheme == 'https') {
        return SecureSocket.startConnect(address, effectivePort);
      }

      return Socket.startConnect(address, effectivePort);
    };

    return client;
  };
}
