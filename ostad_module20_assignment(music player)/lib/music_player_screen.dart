import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ostad_module20_assignment_musicplayer/song_model.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final AudioPlayer _audioplayer = AudioPlayer();
  final List<Song> _PlayList = [
    //  Song(
    //   songName: "",
    //   artistName: "",
    //   songUrl: "",
    //   durationSecond: 0,
    // ),
    Song(
        songName: "3-second synth melody",
        artistName: "Sample MP3",
        songUrl: "https://samplelib.com/lib/preview/mp3/sample-3s.mp3",
        durationSecond: 3),
    Song(
        songName: "6-second synth melodySong 2",
        artistName: "Sample MP3",
        songUrl: "https://samplelib.com/lib/preview/mp3/sample-6s.mp3",
        durationSecond: 6),
    Song(
        songName: "9-second melody using background drums",
        artistName: "Sample MP3",
        songUrl: "https://samplelib.com/lib/preview/mp3/sample-9s.mp3",
        durationSecond: 9),
    Song(
        songName: "12-second melody using flute and whole drum ensemble",
        artistName: "Sample MP3",
        songUrl: "https://samplelib.com/lib/preview/mp3/sample-12s.mp3",
        durationSecond: 12),
    Song(
        songName: "15 seconds of awesome music without using drums",
        artistName: "Sample MP3",
        songUrl: "https://samplelib.com/lib/preview/mp3/sample-15s.mp3",
        durationSecond: 15),


  ];
  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    // TODO: implement initState
    _listenToPlayer();
    _playSong(_currentIndex);
    super.initState();
  }

  Future<void> _playSong(int index) async {
    _currentIndex = index;
    final song = _PlayList[index];

    setState(() {
      _position = Duration.zero;

      //_duration = Duration(seconds: song.durationSecond);
    });
    await _audioplayer.stop();
    await _audioplayer.play(UrlSource(_PlayList[index].songUrl));
  }


  Future<void> _next() async {
    final int next = (_currentIndex + 1) % _PlayList.length;
    await _playSong(next);
  }

  Future<void> _previous() async {
    final int previous = (_currentIndex - 1 + _PlayList.length) %
        _PlayList.length;
    await _playSong(previous);
  }


  void _listenToPlayer() {
    _audioplayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _audioplayer.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });

      _audioplayer.onPlayerStateChanged.listen((state) {
        setState(() => _isPlaying = state == PlayerState.playing);
      });

      _audioplayer.onPlayerComplete.listen((_) => _next());

  }




  Future<void> _togglePlayer() async {
    if (_isPlaying) {
      await _audioplayer.pause();
    } else {
      await _audioplayer.resume();
    }
  }

  String _formatDuration(Duration duration) {
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds.remainder(60);
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {

    final Song song = _PlayList[_currentIndex];
    final double maxSecond=max(_duration.inSeconds.toDouble(),1);
    final double currentSecond=_position.inSeconds.toDouble().clamp(0, maxSecond);



    return Scaffold(
      appBar: AppBar(
          title: const Text(
              'Music Player')
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(song.songName),
                    Text(song.artistName),
                    Slider(
                        min:0,
                        max:maxSecond,
                        value: currentSecond, onChanged: (value) async {
                          final position=Duration(seconds: value.toInt());
                          await _audioplayer.seek(position);
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(
                        _formatDuration(_position),
                      ), Text(_formatDuration(_duration))],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: _previous,
                          icon: Icon(Icons.skip_previous),
                        ),
                        IconButton(onPressed:_togglePlayer, icon: Icon(_isPlaying?Icons.pause:Icons.play_arrow)),
                        IconButton(onPressed: _next, icon: Icon(Icons.skip_next)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _PlayList.length,

                itemBuilder: (context, index) {
                  final Song song=_PlayList[index];
                  final bool isCurrent=index ==_currentIndex;
                  return ListTile(
                    title: Text(song.songName),
                    subtitle: Text(song.artistName),
                    trailing: Icon(isCurrent &&_isPlaying?Icons.pause:Icons.play_arrow),
                  leading: CircleAvatar(child: Text("${index+1}")),
                    onTap: () => _playSong(index),
                    selected: isCurrent,
                  );
                },
              ),
            ),
          ],
        ),

      ),
    );
  }

}


