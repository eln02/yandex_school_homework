import 'dart:ui';
import 'package:flutter/material.dart';

class AppBlurWrapper extends StatefulWidget {
  final Widget child;

  const AppBlurWrapper({required this.child, super.key});

  @override
  State<AppBlurWrapper> createState() => _AppBlurWrapperState();
}

class _AppBlurWrapperState extends State<AppBlurWrapper>
    with WidgetsBindingObserver {
  bool _showBlur = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _showBlur =
          state == AppLifecycleState.inactive ||
          state == AppLifecycleState.paused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showBlur)
          Positioned.fill(
            child: Container(
              color: Colors.black.withAlpha(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
      ],
    );
  }
}
