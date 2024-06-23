import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

ThemeMode getThemeMode(String data) {
  if (data.isEmpty) {
    return ThemeMode.light;
  }
  return ThemeMode.dark;
}

ThemeMode changeThemeMode() {
  final check = localStorage.getItem('theme') ?? '';
  if (check.isEmpty) {
    localStorage.setItem('theme', 'dark');
    return ThemeMode.dark;
  }
  localStorage.setItem('theme', '');
  return ThemeMode.light;
}
