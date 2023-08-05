import 'dart:io';

import 'package:alfred_app/domain/local/session_store.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends InterceptorsWrapper {
  final SessionStore _sessionsStore;

  AuthInterceptor({required SessionStore sessionStore})
      : _sessionsStore = sessionStore;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final session = await _sessionsStore.getCurrentSession();
    if (session != null) {
      options.headers.addAll({
        HttpHeaders.authorizationHeader: 'Bearer ${session.jwt}',
      });
    }

    return handler.next(options);
  }
}
