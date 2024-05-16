import 'dart:developer';

import '../../../core/core.dart';
import '../../features.dart';

class AddMeditationRepository {
  final BaseCRUDDataBaseServices baseCRUDDataBaseServices =
      NetWorkDataBaseService();

  Future<dynamic> addMeditationTask(
      MeditationWithDescription meditationWithDescription) async {
    // ByteData imageData =
    //     await rootBundle.load(meditationWithDescription.playlistImage!);
    // Uint8List playlistImage = imageData.buffer.asUint8List();
    Map<String, dynamic> data = {
      'title': meditationWithDescription.title,
      'description': meditationWithDescription.description,
      DBKeys.dbMeditationPlaylistImagePath:
          meditationWithDescription.playlistImage,
      'created_at': meditationWithDescription.createdAt.toString(),
    };
    await baseCRUDDataBaseServices.insertData('meditation_title_list', data);
    log(data.toString());

    List<Map<String, dynamic>> responseTable =
        await baseCRUDDataBaseServices.getData('meditation_title_list');
    var id;
    if (responseTable.isEmpty) {
      responseTable = [];
    } else {
      for (var res in responseTable) {
        if (meditationWithDescription.title == res['title']) {
          id = res['id'];
        }
      }
      log("ID:${id.toString()}");
      for (var i in meditationWithDescription.meditationWithDurationList!) {
        Map<String, dynamic> data = {
          'title_list_id': id,
          'sub_title': i.subTitle,
          'duration': i.duration.toString(),
          'created_at': i.createdAt.toString(),
        };
        log("AddMeditationData${data.toString()}");
        await baseCRUDDataBaseServices.insertData(
            "meditation_subtitle_list", data);
      }
    }
  }
}
