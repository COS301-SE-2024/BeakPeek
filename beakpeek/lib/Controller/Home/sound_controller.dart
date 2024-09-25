// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:beakpeek/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BirdSoundPlayer extends StatefulWidget {
  const BirdSoundPlayer(
      {super.key, required this.commonGroup, required this.commonSpecies});

  final String commonGroup;
  final String commonSpecies;

  @override
  _BirdSoundPlayerState createState() => _BirdSoundPlayerState();
}

class _BirdSoundPlayerState extends State<BirdSoundPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String? fileUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBirdSoundUrl();
  }

  void preloadAudio() async {
    if (fileUrl != null) {
      await _audioPlayer.setSourceUrl(fileUrl!);
    }
  }

  Future<void> fetchBirdSoundUrl() async {
    final String query = '${widget.commonSpecies} ${widget.commonGroup}';
    try {
      final response = await http.get(
        Uri.parse('https://xeno-canto.org/api/2/recordings?query=$query+q:A'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['recordings'] != null && data['recordings'].isNotEmpty) {
          setState(() {
            fileUrl = '${data['recordings'][0]['file']}';
            isLoading = false;
          });
          preloadAudio();
        } else {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          print('No recordings found for this bird.');
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        print('Failed to load bird sound: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print('Error fetching bird sound: $e');
    }
  }

  void togglePlayPause() async {
    if (fileUrl == null) {
      return;
    }

    try {
      if (isPlaying) {
        await _audioPlayer.stop();
      } else {
        await _audioPlayer.play(UrlSource(fileUrl!));
      }

      if (mounted) {
        setState(() {
          isPlaying = !isPlaying;
        });
      }
    } catch (e) {
      print('Error during playback: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(
              color: AppColors.primaryColor(context),
              strokeWidth: 2.0,
            ),
          )
        : IconButton(
            icon: Icon(
              isPlaying ? Icons.stop : Icons.play_arrow,
              color: AppColors.tertiaryColor(context),
            ),
            onPressed: fileUrl != null ? togglePlayPause : null,
          );
  }
}
