import 'dart:convert';

import 'package:dynamic_icons/dynamic_icons.dart';
import 'package:flutter/material.dart';

class Achievement {
  factory Achievement.fromJson(String source) =>
      Achievement.fromMap(json.decode(source));

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
        id: map['id'],
        name: map['name'],
        xp: map['xp'],
        description: map['description'],
        icon: map['icon'] ?? '',
        category: map['category'] ?? '',
        progress: map['progress'] ?? 0.0,
        iconname: map['iconname'] ?? '');
  }
  Achievement(
      {this.id = -1,
      this.name = '',
      this.xp = 0,
      this.description = '',
      this.icon = '',
      this.category = '',
      this.progress = 0.0,
      this.iconname = ''});

  int id;
  String name;
  int xp;
  String description;
  String icon;
  String category;
  double progress;
  String iconname;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'xp': xp,
      'description': description,
      'icon': icon,
      'category': category,
      'progress': progress,
      'iconname': iconname
    };
  }

  String toJson() => json.encode(toMap());

  Widget getIcon(double size, Color color) {
    final Widget? displayIcon =
        DynamicIcons.getIconFromName(iconname, size: size, color: color);
    if (iconname.isNotEmpty && displayIcon != null) {
      return displayIcon;
    }
    return ImageIcon(
      Image.memory(
        base64Decode(icon),
      ).image,
      size: size,
      color: color,
    );
  }
}
