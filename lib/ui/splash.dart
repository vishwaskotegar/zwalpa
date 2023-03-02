import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {
        flag = true;
      });
    });
  }

  bool flag = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff3E1B6E), Color(0xff000000)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: size.width,
              ),
              Positioned(
                left: size.width * 0.45,
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: const BoxDecoration(),
                  // clipBehavior: Clip.none,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedPositioned(
                          left: flag ? 0 : -size.width * 0.5,
                          // left: 0,
                          duration: const Duration(seconds: 1),
                          child: Text(
                            "Zwalpa",
                            style: Theme.of(context).textTheme.headline2,
                          )),
                    ],
                  ),
                ),
              ),
              AnimatedPositioned(
                // height: size.height,
                // left: size.width * 0.1,
                left: flag ? size.width * 0.1 : size.width * 0.35,
                duration: const Duration(seconds: 1),
                child: Image.asset("images/Icon.png"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
