import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DrawerMenuItem extends StatelessWidget {
  final bool showDivider;
  // final String iconPath;
  final String title;
  final VoidCallback? onTap;
  const DrawerMenuItem(
      {Key? key,
      required this.showDivider,
      // required this.iconPath,
      required this.title,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // SizedBox(
                //     height: 20, width: 20, child: SvgPicture.asset(iconPath)),
                SizedBox(
                  width: 30,
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: Color(0XFF676767),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            thickness: 1,
            height: 1,
            color: Color(0XFFF4F4F4),
          )
      ],
    );
  }
}
