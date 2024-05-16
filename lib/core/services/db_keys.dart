import 'package:flutter/material.dart';

@immutable
class DBKeys {
  const DBKeys._();

  ///DataBase Name
  static const String dbName = 'meditation_db';

  ///DataBase Table Name
  static const String dbUserTable = 'user_detail';
  static const String dbMeditationListTable = 'meditation_title_list';
  static const String dbMeditationSubListTable = 'meditation_subtitle_list';

  ///DataBase Column Name For UserTable
  static const String dbColumnId = 'id';
  static const String dbUserName = 'user_name';
  static const String dbUserAge = 'age';
  static const String dbUserGender = 'gender';
  static const String dbUserProfileImage = 'profile_image';

  ///DataBase Column Name For MeditationListTable
  static const String dbMeditationTitle = 'title';
  static const String dbMeditationDescription = 'description';
  static const String dbMeditationCreatedAt = 'created_at';

  ///DataBase Column Name For MeditationSubListTable
  static const String dbMeditationTitleId = 'title_list_id';
  static const String dbMeditationSubTitle = 'sub_title';
  static const String dbMeditationDuration = 'duration';
  static const String dbMeditationPlaylistImagePath = 'playlist_image_path';
}
