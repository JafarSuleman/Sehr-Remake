import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatefulWidget {
  final String animationPath;
  final double width;
  final double height;

  const LoadingWidget({
    Key? key,
    required this.animationPath,
    this.width = 200,
    this.height = 200,
  }) : super(key: key);

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        widget.animationPath,
        width: widget.width,
        height: widget.height,
        fit: BoxFit.contain,
        controller: _controller,
        onLoaded: (composition) {
          // Configure the AnimationController with the duration of the animation
          _controller
            ..duration = composition.duration
            ..repeat();
        },
      ),
    );
  }
}

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


Widget loadingSpinkit(Color color,[double size = 40.0]) {
  return SpinKitCircle(
   color: color,
   size: size,
    duration: const Duration(milliseconds: 2400),
        );
}
