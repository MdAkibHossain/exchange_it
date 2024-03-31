import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  final double height;
  // final double elevation;
  // final bool finishScreen;
  // final bool isTitleCenter;
  // final IconData icon;

  CommonAppBar({
    required this.title,
    required this.height,
    // required this.elevation,

    // required this.finishScreen,
    // required this.isTitleCenter,
    // required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _appbar(context);
  }

  Widget _appbar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        textScaleFactor: 1.0,
        style: TextStyle(
            color: AppColors.color2C2D30,
            fontSize: 13.0.sp,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.ROBOTO),
      ),
      elevation: 0.0,
      backgroundColor: AppColors.white,
      leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.primaryColor,
          )),
    );
  }
}
