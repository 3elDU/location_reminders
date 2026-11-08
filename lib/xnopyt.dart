import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class XnopytController extends ChangeNotifier {
  void xnopyt() {
    notifyListeners();
  }
}

Future<void> playXnopyt() async {
  print('xnopyt');

  await SoLoud.instance.init();
  final sound = await SoLoud.instance.loadAsset('assets/xnopyt.opus');

  SoLoud.instance.play(sound);

  sound.allInstancesFinished.first.then((_) {
    SoLoud.instance.disposeSource(sound);
  });
}

class Xnopyt extends StatefulWidget {
  const Xnopyt({super.key, required this.controller, required this.child});

  final XnopytController controller;
  final Widget child;

  @override
  State<Xnopyt> createState() => _XnopytState();
}

class _XnopytState extends State<Xnopyt> {
  double _target = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_startAnimation);
  }

  void _startAnimation() async {
    await playXnopyt();
    await Future.delayed(const Duration(milliseconds: 1200));

    setState(() {
      _target = 16.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: _target),
      duration: const Duration(milliseconds: 2000),
      curve: Curves.easeOutCubic,
      onEnd: () => SystemNavigator.pop(),
      builder: (_, value, child) => ImageFiltered(
        enabled: value > 0,
        imageFilter: ImageFilter.compose(
          outer: ImageFilter.erode(radiusX: value, radiusY: value),
          inner: ImageFilter.blur(sigmaX: value, sigmaY: value),
        ),
        child: child,
      ),
      child: widget.child,
    );
  }
}
