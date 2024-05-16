import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/core.dart';

class AuthRepositories {
  final BaseCRUDDataBaseServices baseCRUDDataBaseService =
      NetWorkDataBaseService();

  Future<void> insertUser(String userName, String age, String gender,
      Uint8List profileImage) async {
        
    Map<String, dynamic> data = {
      DBKeys.dbUserName: userName,
      DBKeys.dbUserAge: age,
      DBKeys.dbUserGender: gender,
      DBKeys.dbUserProfileImage: profileImage
    };

    await baseCRUDDataBaseService.insertData('user_detail', data);
  }

  Future<Map<String, dynamic>> getUser() async {
    final List<Map<String, dynamic>> response =
        await baseCRUDDataBaseService.getData('user_detail');
    // log(response.toString());

    if (response.isNotEmpty) {
      final Map<String, dynamic> userData = response.first;

      final int userId = userData['id'];
      final String userName = userData['user_name'];
      final String age = userData['age'];
      final gender = userData['gender'];
      final Uint8List profileImage = userData['profile_image'];
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setInt('user_id', userId);

      return {
        'id': userId,
        'user_name': userName,
        'age': age,
        'gender': gender,
        "profile_image": profileImage
      };
    } else {
      return {};
    }
  }
}
