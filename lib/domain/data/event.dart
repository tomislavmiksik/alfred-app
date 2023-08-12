import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
@HiveType(typeId: 4)
class Event with _$Event {
  const factory Event({
    @HiveField(0) required int id,
    @HiveField(1) required String title,
    @HiveField(2) String? description,
    @HiveField(3) required DateTime eventDate,
  }) = _Event;

  factory Event.fromJson(Map<String, Object?> json) => _$EventFromJson(json);
}
