import 'package:alfred_app/domain/remote/responses/parse_strapi.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_list.freezed.dart';
part 'remote_list.g.dart';

@freezed
class Meta with _$Meta {
  const factory Meta() = _Meta;

  factory Meta.fromJson(Map<String, Object?> json) => _$MetaFromJson(json);
}

@Freezed(genericArgumentFactories: true)
class RemoteList<T> with _$RemoteList {
  const factory RemoteList({
    required List<T> data,
    required Meta meta,
  }) = _RemoteList;

  factory RemoteList.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$RemoteListFromJson(parseStrapiList(json), fromJsonT);
}
