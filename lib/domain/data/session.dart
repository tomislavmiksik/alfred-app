import 'package:alfred_app/domain/data/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@HiveType(typeId: 0)
@freezed
class Session with _$Session {
  const factory Session({
    @HiveField(0) required String jwt,
    @HiveField(1) required User user,
  }) = _Session;

  factory Session.fromJson(Map<String, Object?> json) =>
      _$SessionFromJson(json);
}
