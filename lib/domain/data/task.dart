import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
@HiveType(typeId: 2)
class Task with _$Task {
  const factory Task({
    @HiveField(0) required int id,
    @HiveField(1) required String title,
    @HiveField(2) required bool completed,
    @HiveField(3) required DateTime completeBy,
  }) = _Task;

  factory Task.fromJson(Map<String, Object?> json) => _$TaskFromJson(json);
}
