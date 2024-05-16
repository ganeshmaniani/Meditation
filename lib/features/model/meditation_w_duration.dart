

class MeditationWithDuration {
  int? id;
  int? titleListId;
  String? subTitle;
  String? duration;

  DateTime? createdAt;

  MeditationWithDuration(
      {this.subTitle,
      this.duration,
      this.id,
      this.createdAt,
      this.titleListId,
      });
}
