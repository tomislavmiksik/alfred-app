import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'journal_entry.freezed.dart';
part 'journal_entry.g.dart';

@freezed
@HiveType(typeId: 3)
class JournalEntry with _$JournalEntry {
  const factory JournalEntry({
    @HiveField(0) required int id,
    @HiveField(1) required String title,
    @HiveField(2) required String description,
    @HiveField(3) required DateTime date,
    @HiveField(4) DateTime? createdAt,
  }) = _JournalEntry;

  factory JournalEntry.fromJson(Map<String, Object?> json) =>
      _$JournalEntryFromJson(json);
}
