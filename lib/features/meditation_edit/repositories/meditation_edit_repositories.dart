import '../../../core/core.dart';

class EditRepositories {
  final BaseCRUDDataBaseServices baseCRUDDataBaseServices =
      NetWorkDataBaseService();

  Future<void> editInTitle(Map<String, dynamic> data) async {
    dynamic response = await baseCRUDDataBaseServices.updateDataById(
        'meditation_title_list', data);
    // log(response.toString());
  }

  Future<void> editInSubtitle(Map<String, dynamic> data) async {
    dynamic response = await baseCRUDDataBaseServices.updateDataById(
        'meditation_subtitle_list', data);
    // log(response.toString());
  }
}
