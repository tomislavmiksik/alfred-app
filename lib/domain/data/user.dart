import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
@HiveType(typeId: 1)
class User with _$User {
  const factory User({
    @HiveField(0) required int id,
    @HiveField(1) required String email,
    @HiveField(2) String? firstName,
    @HiveField(3) String? lastName,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
