import 'dart:typed_data';

import '../features.dart';

class MeditationWithDescription {
  int? id;
  String? title;
  String? description;

  Uint8List? playlistImage;
  DateTime? createdAt;

  List<MeditationWithDuration>? meditationWithDurationList;

  MeditationWithDescription({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.playlistImage,
    this.meditationWithDurationList,
  });

  MeditationWithDescription.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    title = json['title'];
    description = json['description'];
    playlistImage = json['playlist_image_path'];
    createdAt = json['created_at'];

    meditationWithDurationList = json['subtitle_list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['playlist_image_path'] = playlistImage;
    data['created_at'] = createdAt;
    data['subtitle_list'] = meditationWithDurationList;
    return data;
  }
}
