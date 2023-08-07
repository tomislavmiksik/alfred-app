import 'package:alfred_app/domain/data/session.dart';
import 'package:alfred_app/domain/data/user.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class _AuthAPI {
  factory _AuthAPI(Dio dio) = __AuthAPI;

  @POST("/auth/local")
  Future<Session> _login(@Body() Map<String, dynamic> body);

  @POST("/auth/local/register")
  Future<Session> _register(@Body() Map<String, dynamic> body);

  @GET("/users/me")
  Future<User> _getCurrentUser();
}

class AuthAPI extends __AuthAPI {
  AuthAPI(Dio dio) : super(dio);

  Future<Session> login({
    required String email,
    required String password,
  }) {
    return _login({
      'identifier': email,
      'password': password,
    });
  }

  Future<Session> register({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
  }) {
    return _register({
      'email': email,
      'password': password,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
    });
  }

  Future<User> getCurrentUser() {
    return _getCurrentUser();
  }
}
