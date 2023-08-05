import 'package:alfred_app/domain/local/session_store.dart';
import 'package:alfred_app/domain/remote/auth_api.dart';
import 'package:alfred_app/domain/remote/interceptors/auth_interceptor.dart';
import 'package:alfred_app/domain/remote/tasks_api.dart';
import 'package:alfred_app/providers/di/store_providers.dart';
import 'package:alfred_app/util/env.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _factoryProvider = Provider<APIFactory>(
  (ref) => APIFactory.provider(
    baseUrl: Env.apiUrl,
    sessionStore: ref.read(sessionsStoreProvider),
  ),
);

final dioProvider = Provider<Dio>(
  (ref) => ref.read(_factoryProvider).dio,
);

final authAPIProvider = Provider<AuthAPI>(
  (ref) => ref.read(_factoryProvider).authAPI,
);

final tasksAPIProvider = Provider<TasksAPI>(
  (ref) => ref.read(_factoryProvider).tasksAPI,
);

class APIFactory {
  final Dio dio;

  late final AuthAPI authAPI = AuthAPI(dio);
  late final TasksAPI tasksAPI = TasksAPI(dio);

  APIFactory._(this.dio);

  factory APIFactory.provider({
    required SessionStore sessionStore,
    required String baseUrl,
  }) {
    final dio = Dio()..options = BaseOptions(baseUrl: baseUrl);
    dio.interceptors.add(AuthInterceptor(sessionStore: sessionStore));
    return APIFactory._(dio);
  }
}
