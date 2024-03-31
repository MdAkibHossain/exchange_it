import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/model/page_arguments_model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../../../core/utils/debug_utils.dart';
import '../../../../route_name.dart';

class LogoInitialization extends StatefulWidget {
  const LogoInitialization({super.key});
  static const routeName = '/logoInitialization';

  @override
  State<LogoInitialization> createState() => _LogoInitializationState();
}

class _LogoInitializationState extends State<LogoInitialization> {
  @override
  void initState() {
    sellRef.onValue.listen((event) {
      dollarSellingRate = double.parse(event.snapshot.value.toString());
      buyRef.onValue.listen((event) {
        dollarBuyingRate = double.parse(event.snapshot.value.toString());
        __navigatetoUserAuth();
      });
    });

    super.initState();
  }

  final sellRef = FirebaseDatabase.instance.ref('dollarRate/dollarSellingRate');
  final buyRef = FirebaseDatabase.instance.ref('dollarRate/dollarBuyingRate');

  double? dollarBuyingRate;
  double? dollarSellingRate;
  Future<void> __navigatetoUserAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(
      milliseconds: 1000,
    )).then((value) {
      var isSkip = prefs.getString('isSkip');
      if (isSkip != null) {
        Navigator.pushNamed(context, RouteName.home,
            arguments: PageRouteArguments(
                datas: [dollarBuyingRate, dollarSellingRate]));
      } else if (isSkip == null) {
        // Navigator.pushNamed(context, RouteName.splashScreen,
        //     arguments: PageRouteArguments(
        //         datas: [dollarBuyingRate, dollarSellingRate]));
        Navigator.pushNamed(context, RouteName.home,
            arguments: PageRouteArguments(
                datas: [dollarBuyingRate, dollarSellingRate]));
      }
    });
  }

  late int dollarBuyRate;
  late int dollarSellRate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: Center(
        child: Container(
          // height: 46,
          width: double.infinity,
          child:
              // Text("Exchange It",
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 20.sp,
              //         fontFamily: AppFonts.ROBOTO,
              //         fontWeight: FontWeight.w700)),
              Image.asset("assets/images/banner.png", fit: BoxFit.cover),
          //  SvgPicture.asset(
          //   AppAssets.youtube,
          //   color: AppColors.white,
          // ),
        ),
        // Text(
        //   "Loading....",
        //   style: TextStyle(
        //       color: AppColors.color2C2D30,
        //       fontSize: 22.0.sp,
        //       fontWeight: FontWeight.w700,
        //       fontFamily: AppFonts.ROBOTO),
        // ),
      )
          // Center(
          //   child: SvgPicture.asset(
          //     "assets/images/Amar_Shohor_Logo.svg",
          //     //  fit: BoxFit.cover,
          //   ),
          // ),
          ),
    );
  }
}
