// ignore_for_file: use_build_context_synchronously

import 'package:boi_ache_web_view_app/web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double _scale = 0.0;

  void nextScreen() async {
    await Future.delayed(Duration(seconds: 2)).then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BoiAcheWebViewApp()),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _scale = 1;
      });
    });
    nextScreen();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _scale),
            duration: const Duration(seconds: 1),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Image.network(
              "https://boiache.com/_next/image?url=https%3A%2F%2Flogin.boiache.com%2Fassets%2Fimages%2Fsettings%2F1749975769_boiAche.png&w=256&q=75",
              width: 300.w,
              height: 200.h,
            ),
          ),
        ),
      ),
    );
  }
}
