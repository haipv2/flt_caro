import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:ticcar5/src/common/common.dart';
import 'package:ticcar5/src/utils/shared_preferences_utils.dart';

class Speaker extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final AudioCache audioCache;

  Speaker(this.audioPlayer, this.audioCache);

  @override
  _SpeakerState createState() => _SpeakerState();
}

class _SpeakerState extends State<Speaker> {
  String _speakerOn = 'assets/images/speaker_on.png';
  String _speakerOff = 'assets/images/speaker_off.png';
  bool hasSound;

  @override
  void initState() {
    buildChid();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String imagePath;

  String buildChid() {
    SharedPreferencesUtils.getBool(SETTING_SOUND).then((value) {
      setState(() {
        if (value == true) {
          imagePath = _speakerOn;
          hasSound=true;
        } else {
          imagePath = _speakerOff;
          hasSound=false;
        }
      });
    });
    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _toggleSound, child: Tab(icon: Image.asset(imagePath??_speakerOn)));
  }

  void _toggleSound() {
    setState(() {
      if (hasSound) {
        hasSound = false;
        imagePath = _speakerOff;
        stop();
      } else {
        hasSound = true;
        imagePath = _speakerOn;
        start();
      }
    });
  }

  start() async {
    widget.audioCache.loop('sound.mp3');
    await SharedPreferencesUtils.setBool(SETTING_SOUND, true);
  }

  stop() async {
    widget.audioPlayer.stop();
    await SharedPreferencesUtils.setBool(SETTING_SOUND, false);
  }
}
