// ignore_for_file: avoid_print, lines_longer_than_80_chars

import 'dart:convert';
import 'package:beakpeek/Module/bird.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BirdSearch extends StatefulWidget {
  const BirdSearch({super.key});

  @override
  State<BirdSearch> createState() => _BirdSearchState();
}

class _BirdSearchState extends State<BirdSearch> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text(
        'hello',
      ),
    );
  }
}
