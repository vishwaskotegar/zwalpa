import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingTwo extends StatefulWidget {
  const OnboardingTwo({super.key});

  @override
  State<OnboardingTwo> createState() => _OnboardingTwoState();
}

class _OnboardingTwoState extends State<OnboardingTwo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 700)).then((value) {
      setState(() {
        flag = true;
      });
    });
  }

  bool flag = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        width: size.width,
        decoration: const BoxDecoration(color: Colors.black),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                "Music>",
                style: textTheme.headline4!.copyWith(color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Your voice matters",
                style: textTheme.headline4!
                    .copyWith(color: const Color(0xff9535DC)),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: size.width * 0.7,
                child: Text(
                    "Amplify your thoughts and connect to the Kannada community with voice.",
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium),
              ),
              Flexible(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    AnimatedPositioned(
                      curve: Curves.easeOut,
                      duration: const Duration(seconds: 1),
                      top: flag ? size.height * 0.1 : -size.height * 0.1,
                      // top: 0,
                      child: Transform.scale(
                        scale: 1,
                        child: SvgPicture.asset(
                          "images/left Rectangle 10.svg",
                        ),
                      ),
                    ),
                    AnimatedScale(
                      curve: Curves.elasticOut,
                      duration: const Duration(seconds: 1),
                      scale: flag ? 1 : 0.5,
                      child: SizedBox(
                        height: size.height * 0.7,
                        child: Image.asset(
                          "images/image 9.png",
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
