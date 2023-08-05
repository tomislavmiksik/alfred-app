import 'package:alfred_app/domain/remote/responses/parse_strapi.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_item.freezed.dart';
part 'remote_item.g.dart';

@Freezed(genericArgumentFactories: true)
class RemoteItem<T> with _$RemoteItem {
  const factory RemoteItem({
    required T data,
  }) = _RemoteItem;

  factory RemoteItem.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$RemoteItemFromJson(parseStrapiItem(json), fromJsonT);
}
