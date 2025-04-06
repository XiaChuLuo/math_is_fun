import 'package:audioplayers/audioplayers.dart';

class MusicController {
  static final MusicController _instance = MusicController._internal();
  factory MusicController() => _instance;

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = true;
  bool _initialized = false;

  MusicController._internal();

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Ensure player is set up properly for persistent loop
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setSourceAsset('audio/background_music.mp3');
    await _player.resume();
    _isPlaying = true;

    // Optional: Handle audio interruptions
    _player.onPlayerComplete.listen((event) async {
      if (_isPlaying) {
        await _player.resume();
      }
    });
  }

  Future<void> toggleMusic() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.resume();
    }
    _isPlaying = !_isPlaying;
  }

  bool get isPlaying => _isPlaying;
}
