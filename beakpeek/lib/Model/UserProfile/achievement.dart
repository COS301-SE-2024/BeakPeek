import 'dart:convert';

class Achievement {
  factory Achievement.fromJson(String source) =>
      Achievement.fromMap(json.decode(source));

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
        id: map['id'],
        name: map['name'],
        xp: map['xp'],
        description: map['description'],
        icon: map['icon']);
  }
  Achievement(
      {this.id = 0,
      this.name = '',
      this.xp = 0,
      this.description = '',
      this.icon = ''});

  int id;
  String name;
  int xp;
  String description;
  String icon;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'xp': xp,
      'description': description,
      'icon': icon
    };
  }

  String toJson() => json.encode(toMap());
}
