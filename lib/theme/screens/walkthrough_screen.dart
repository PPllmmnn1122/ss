import 'dart:core';
import 'package:flutter/material.dart';
import 'package:my_special_needs_app/screens/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';
import '../components/heading_text_component.dart';
import '../utils/colors.dart';
import '../utils/walkthrough_list.dart';

class Walkthrough extends StatefulWidget {
  const Walkthrough({super.key});

  @override
  State<Walkthrough> createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Walkthrough> {
  List<WalkThroughModelClass> walkThroughLists = walkThroughList();
  PageController? pageController;
  int index = 0;

  void navigateToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    pageController = PageController(initialPage: 0);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: context.width(),
              height: context.height() / 2 + 48,
              padding: const EdgeInsets.only(
                  left: 32, right: 32, top: 64, bottom: 128),
              decoration: BoxDecoration(
                color: primarycolor,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(200)),
              ),
            ),
            PageView.builder(
              controller: pageController,
              onPageChanged: (value) {
                index = value.toInt();
                setState(() {});
              },
              itemCount: walkThroughLists.length,
              itemBuilder: (context, index) {
                return WalkthroughWidget(data: walkThroughLists[index]);
              },
            ),
            Positioned(
              bottom: 16,
              right: 16,
              left: 16,
              child: Row(
                children: [
                  TextButton(
                    onPressed: navigateToLogin,
                    child: Text("تخطي", style: boldTextStyle()),
                  ),
                  DotIndicator(
                    pageController: pageController!,
                    pages: walkThroughLists,
                    indicatorColor: primarycolor,
                  ),
                  const Spacer(),
                  AnimatedCrossFade(
                    firstChild: Container(
                      decoration: boxDecorationDefault(
                          shape: BoxShape.circle, color: primarycolor),
                      child: IconButton(
                        onPressed: () {
                          if (index == walkThroughLists.length - 1) {
                            navigateToLogin(); // If on the last page, navigate to login
                          } else {
                            pageController?.nextPage(
                                duration: const Duration(seconds: 1),
                                curve: Curves.decelerate);
                          }
                        },
                        icon: const Icon(Icons.arrow_forward_ios_rounded,
                            color: Colors.white),
                      ),
                    ),
                    secondChild: GestureDetector(
                      onTap: navigateToLogin,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: boxDecorationDefault(color: primarycolor),
                        child: Text('ابدأ الآن',
                            style: boldTextStyle(color: Colors.white)),
                      ),
                    ),
                    crossFadeState: index == walkThroughLists.length - 1
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: 200.milliseconds,
                    firstCurve: Curves.easeInOut,
                    secondCurve: Curves.easeInOut,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
