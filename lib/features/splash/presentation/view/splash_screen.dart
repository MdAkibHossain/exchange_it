import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/services/firebase_services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/model/page_arguments_model.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../route_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.arguments});
  final PageRouteArguments arguments;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int activeIndex = 0;
  //double? value;
  final images = [
    // "assets/images/splash_screen_image.svg",
    //"assets/images/Amar_Shohor_Logo.svg"
    ""
  ];
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _imageSection(),
          SizedBox(height: 4.0.h),
          Padding(
            padding: EdgeInsets.only(left: 4.0.w),
            child: Container(
              alignment: Alignment.topLeft,
              child: const Text(
                "Welcome to",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 4.0.w),
            child: Container(
              alignment: Alignment.topLeft,
              child: const Text(
                "Exchange It",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 3.0.h),
          InkWell(
            onTap: () async {
              setState(() {
                isLoading = true;
              });
              bool isSignedIn = await FirebaseServices().signInWithGoogle();
              final prefs = await SharedPreferences.getInstance();

              if (isSignedIn) {
                prefs.setString("isSkip", "isSkip");
                Navigator.pushNamed(
                  context,
                  RouteName.home,
                  arguments: PageRouteArguments(
                    datas: [
                      widget.arguments.datas![0],
                      widget.arguments.datas![1]
                    ],
                  ),
                );
                setState(() {
                  isLoading = false;
                });
              } else {
                setState(() {
                  isLoading = false;
                });
              }
            },
            child: Container(
              height: 7.0.h,
              margin: EdgeInsets.only(left: 4.0.w, right: 4.0.w, bottom: 2.0.h),
              padding:
                  const EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2),
              decoration: const BoxDecoration(
                  color: AppColors.googleBlue,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          "Get Started",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 13.sp,
                            //  fontWeight: FontWeight.w500
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageSection() {
    return CarouselSlider.builder(
      options: CarouselOptions(
        initialPage: 0,
        height: 40.0.h,
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          setState(() {
            activeIndex = index;
          });
        },
        enableInfiniteScroll: false,
      ),
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        final image = images[index];
        return itemBuilder(image: image);
      },
    );
  }
}

class itemBuilder extends StatelessWidget {
  const itemBuilder({
    Key? key,
    required this.image,
  }) : super(key: key);

  final String image;
  //final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //  margin: EdgeInsets.symmetric(horizontal: 2.0.w),
      child: Image.asset("assets/images/banner.png", fit: BoxFit.cover),
    );
  }
}
