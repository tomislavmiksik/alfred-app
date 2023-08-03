import 'package:alfred_app/domain/remote/auth_api.dart';
import 'package:alfred_app/util/env.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _factoryProvider = Provider<APIFactory>(
  (ref) => APIFactory.provider(
    baseUrl: Env.apiUrl,
  ),
);

final dioProvider = Provider<Dio>(
  (ref) => ref.read(_factoryProvider).dio,
);

final authAPIProvider = Provider<AuthAPI>(
  (ref) => ref.read(_factoryProvider).authAPI,
);

class APIFactory {
  final Dio dio;

  late final AuthAPI authAPI = AuthAPI(dio);
  APIFactory._(this.dio);

  factory APIFactory.provider({
    // required AppSharedPreferences authStore,
    required String baseUrl,
  }) {
    final dio = Dio()..options = BaseOptions(baseUrl: baseUrl);
    return APIFactory._(dio);
  }
}
