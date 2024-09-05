// ignore_for_file: avoid_print, library_private_types_in_public_api

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
  String? fileUrl; // This will be set after fetching from the API
  bool isLoading = true; // Track if data is being fetched

  @override
  void initState() {
    super.initState();
    fetchBirdSoundUrl();
  }

  void preloadAudio() async {
    if (fileUrl != null) {
      await _audioPlayer.setSourceUrl(fileUrl!);
      // This preloads the audio file so it's ready when the user presses play.
    }
  }

  Future<void> fetchBirdSoundUrl() async {
    final String query = '${widget.commonSpecies} ${widget.commonGroup}';
    final response = await http.get(
      Uri.parse('https://xeno-canto.org/api/2/recordings?query=$query+q:A'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['recordings'] != null && data['recordings'].isNotEmpty) {
        setState(() {
          // Set the file URL from the first recording result
          fileUrl = '${data['recordings'][0]['file']}';
          isLoading = false;
        });
        preloadAudio();
      } else {
        setState(() {
          isLoading = false;
        });
        print('No recordings found for this bird.');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load bird sound');
    }
  }

  void togglePlayPause() async {
    if (fileUrl == null) {
      return; // Do nothing if there's no valid file URL
    }

    if (isPlaying) {
      // If sound is playing, stop it
      await _audioPlayer.stop();
    } else {
      // If sound is not playing, play it
      await _audioPlayer.play(UrlSource(fileUrl!));
    }
    // Toggle play/pause state
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : IconButton(
            icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
            onPressed: fileUrl != null
                ? togglePlayPause
                : null, // Disable button if no file URL
          );
  }
}
