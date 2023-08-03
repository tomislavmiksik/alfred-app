import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class _AuthAPI {
  factory _AuthAPI(Dio dio) = __AuthAPI;

  //todo: ovo je samo za testiranje, makni
  @POST("/auth/local")
  Future<Map<String, String>> _login(@Body() Map<String, dynamic> body);
}

class AuthAPI extends __AuthAPI {
  AuthAPI(Dio dio) : super(dio);

  Future<Map<String, String>> login({
    required String email,
    required String password,
  }) {
    return _login({'identifier': email, 'password': password});
  }
}
