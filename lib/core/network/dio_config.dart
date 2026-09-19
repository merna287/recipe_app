import 'package:dio/dio.dart';

import 'dio_config_io.dart' if (dart.library.html) 'dio_config_stub.dart' as platform;

void configureDio(Dio dio) => platform.configureDio(dio);
