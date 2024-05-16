import '../../../core/core.dart';
import '../../features.dart';

class HomeRepositories {
  final BaseCRUDDataBaseServices baseCRUDDataBaseServices =
      NetWorkDataBaseService();

  Future<List<MeditationWithDescription>> getMeditationList() async {
    List<MeditationWithDescription> meditationWithDescriptionList = [];
    List<Map<String, dynamic>> response =
        await baseCRUDDataBaseServices.getData('meditation_title_list');
    // log(response.toString());
    if (response.isEmpty) {
      return [];
    } else {
      for (var res in response) {
        var meditationWithDescription = MeditationWithDescription();
        meditationWithDescription.id = res['id'];
        meditationWithDescription.title = res['title'];
        meditationWithDescription.description = res['description'];
        meditationWithDescription.playlistImage =
            res[DBKeys.dbMeditationPlaylistImagePath];
        meditationWithDescriptionList.add(meditationWithDescription);
      }
      return meditationWithDescriptionList;
    }
  }

  Future<dynamic> deleteMeditationList(dynamic id) async {
    await baseCRUDDataBaseServices.deleteDataById('meditation_title_list', id);
  }
}
