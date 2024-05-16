import 'dart:developer';

import '../../../core/core.dart';
import '../../features.dart';

class MeditationDetailsRepositories {
  final BaseCRUDDataBaseServices baseCRUDDataBaseServices =
      NetWorkDataBaseService();

  Future<List<MeditationWithDuration>> getSubtitleList(dynamic id) async {
    List<MeditationWithDuration> meditationWithDurationList = [];
    List<Map<String, dynamic>> response = await baseCRUDDataBaseServices
        .getDataById('meditation_subtitle_list', id);
    log("meditation_subtitle_list${response.toString()}");
    if (response.isEmpty) {
      return [];
    } else {
      for (var res in response) {
        MeditationWithDuration meditationWithDuration =
            MeditationWithDuration();
        meditationWithDuration.id = res['id'];
        meditationWithDuration.titleListId = res['title_list_id'];
        meditationWithDuration.subTitle = res['sub_title'];
        meditationWithDuration.duration = res['duration'].toString();
        meditationWithDurationList.add(meditationWithDuration);
      }
      return meditationWithDurationList;
    }
  }
}
