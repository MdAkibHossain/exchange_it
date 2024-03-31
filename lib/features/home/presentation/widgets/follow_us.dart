import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/app_assets.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';

class follow_us_widget extends StatelessWidget {
  const follow_us_widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            child: Text(
              "Follow us on",
              textScaleFactor: 1.0,
              style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.ROBOTO),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.0.h),
            child: Divider(
              thickness: 0.3.w,
            ),
          ),
          SizedBox(height: 0.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 4.0.h,
                width: 4.0.h,
                child: SvgPicture.asset(
                  AppAssets.whatsapp,
                  //  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 4.0.w),
              SizedBox(
                height: 4.0.h,
                width: 4.0.h,
                child: SvgPicture.asset(
                  AppAssets.facebook,
                  //  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 4.0.w),
              SizedBox(
                height: 4.0.h,
                width: 4.0.h,
                child: SvgPicture.asset(
                  AppAssets.youtube,
                  //  fit: BoxFit.cover,
                ),
              )
            ],
          ),
          SizedBox(height: 1.0.h),
        ],
      ),
    );
  }
}
