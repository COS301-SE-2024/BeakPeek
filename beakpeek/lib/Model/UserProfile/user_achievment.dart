import 'dart:convert';

class UserAchievement {
  factory UserAchievement.fromJson(String source) =>
      UserAchievement.fromMap(json.decode(source));

  factory UserAchievement.fromMap(Map<String, dynamic> map) {
    return UserAchievement(id: map['id'], progress: map['progress']);
  }
  UserAchievement({this.id = 0, this.progress = 0.0});

  int id;
  double progress;

  Map<String, dynamic> toMap() {
    return {'id': id, 'progress': progress};
  }

  String toJson() => json.encode(toMap());
}
