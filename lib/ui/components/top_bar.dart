import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class TopBar extends StatefulWidget {
  final AssetsAudioPlayer player;
  const TopBar({Key key, @required this.player}) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool isPlaying = false;
  double value = 0.0;
  Duration _duration = Duration();
  double _position = 0.0;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    widget.player.currentPosition.listen((event) {
      setState(() {
        value = event.inSeconds.toDouble();
        _position -= value;
      });
    });
    widget.player.current.listen((event) {
      setState(() {
        _duration = event.audio.duration;
        _position = event.audio.duration.inSeconds.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _handleOnPressed,
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: _animationController,
              color: Colors.white,
            ),
          ),
          Slider(
              // min: 0.0,
              max: _duration.inSeconds.toDouble(),
              inactiveColor: Colors.white,
              value: value,
              onChanged: (value) {
                setState(() {
                  this.value = value;
                  widget.player.seek(Duration(seconds: value.toInt()));
                });
              }),
          Text(
            _duration.toString().split('.')[0],
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }

  void _handleOnPressed() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        widget.player.pause();
        _animationController.reverse();
      } else {
        widget.player.play();
        _animationController.forward();
      }
    });
  }
}
