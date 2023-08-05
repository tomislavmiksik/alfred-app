Map<String, dynamic> parseStrapiList(Map<String, dynamic> json) {
  final list = json['data'].map((item) => parseStrapiData(item)).toList();

  return {
    ...json,
    'data': list,
  };
}

Map<String, dynamic> parseStrapiItem(Map<String, dynamic> json) {
  final item = json['data'];

  return {
    ...json,
    'data': parseStrapiData(item),
  };
}

Map<String, dynamic> parseStrapiData(Map<String, Object?> json) {
  final attributes = json['attributes'] as Map;

  final flatten = attributes.map<String, dynamic>((key, value) {
    if (value is Map && value.containsKey('data')) {
      final data = value['data'];
      if (data == null) {
        return MapEntry(key, null);
      } else if (data is List) {
        return MapEntry(
            key, data.map((item) => parseStrapiData(item)).toList());
      } else if (data is Map<String, dynamic>) {
        return MapEntry(key, parseStrapiData(data));
      }
    }
    return MapEntry(key, value);
  });

  return {
    'id': json['id'] as int,
    ...flatten,
  };
}

Map<String, dynamic> mapToStrapiBody(Map<String, Object?> json) {
  final id = json['id'] as int?;

  final attributes = <String, dynamic>{};
  json.forEach((key, value) {
    if (value is List) {
      attributes[key] = {
        'data': value.map((item) {
          return {'data': mapToStrapiBody(item)};
        }).toList(),
      };
    } else if (value is Map<String, dynamic>) {
      attributes[key] = {
        'data': mapToStrapiBody(value),
      };
    } else if (key != 'id') {
      attributes[key] = value;
    }
  });

  return {
    if (id != null) 'id': id,
    'attributes': attributes,
  };
}

// List<String> mapSortToStrapiQuery(List<Sort> sort) {
//   return sort.map((sort) {
//     return '${sort.key}:${sort.order.toServerString()}';
//   }).toList();
// }
//
// Map<String, dynamic> mapPaginationToStrapiQuery(Pagination pagination) {
//   return {'page': pagination.page, 'pageSize': pagination.pageSize};
// }
//
// List photosAndFilesFromAssets(List<Asset> assets) {
//   final List<MediaFilePartial> photos = [];
//   final files = <String, File>{};
//   assets.forEachIndexed((i, asset) {
//     final order = i + 1;
//
//     final mediaFile = asset.when(remote: (value) {
//       return MediaFilePartial(
//         order: order,
//         id: value.id,
//         visibility: value.visibility,
//       );
//     }, local: (value) {
//       return MediaFilePartial(
//         order: order,
//         file: const APIFilePartial(),
//         visibility: MediaFileVisibility.public,
//       );
//     });
//     photos.add(mediaFile);
//
//     final file = asset.whenOrNull(local: (value) => value);
//     if (file != null) {
//       final key = 'files.attributes.photos.data[$i].data.attributes.file';
//       files[key] = file;
//     }
//   });
//   return [photos, files];
// }
