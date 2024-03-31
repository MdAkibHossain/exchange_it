import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/model/page_arguments_model.dart';
import 'package:flutter_application_1/core/utils/debug_utils.dart';
import 'package:flutter_application_1/features/home/data/post_model.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/common/custom_text_form_field.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../../../route_name.dart';
import '../../../home/presentation/widgets/appbar.dart';

class DetailsInputScreen extends StatefulWidget {
  const DetailsInputScreen({super.key, required this.arguments});
  final PageRouteArguments arguments;

  @override
  State<DetailsInputScreen> createState() => _DetailsInputScreenState();
}

class _DetailsInputScreenState extends State<DetailsInputScreen> {
  TextEditingController receiveAddressController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  bool invalid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CommonAppBarWithNotification(title: "Exchange It", height: 15.0.h),
      body: Column(
        //  mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          topsection(),
          if (widget.arguments.data.receiveItem == "BinancePay USD")
            defaultText("Binance Pay ID EX: 1987*****")
          else if (widget.arguments.data.receiveItem == "বিকাশ Personal BDT")
            defaultText("বিকাশ Personal Number")
          else if (widget.arguments.data.receiveItem == "নগদ Personal BDT")
            defaultText("নগদ Personal Number"),
          textField(receiveAddressController),
          defaultText("Contact Phone Number."),
          textField(contactNumberController),
          SizedBox(height: 6.0.h),
          processExchangeButton()
        ],
      ),
    );
  }

  Widget topsection() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
          alignment: Alignment.centerLeft,
          child: Text(
            "Additional information",
            textScaleFactor: 1.0,
            style: TextStyle(
                color: AppColors.color2C2D30,
                fontSize: 15.0.sp,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.ROBOTO),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0.w),
          child: Divider(
            thickness: 0.3.w,
          ),
        ),
      ],
    );
  }

  Widget processExchangeButton() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.googleBlue),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      icon: Container(
        margin: EdgeInsets.only(left: 5.0.w),
        child: const Icon(Icons.currency_exchange),
      ),
      label: Container(
        margin: EdgeInsets.only(right: 5.0.w, top: 1.5.h, bottom: 1.5.h),
        child: Text(
          "Process Exchange",
          textScaleFactor: 1.0,
          style: TextStyle(
              color: AppColors.white,
              fontSize: 14.0.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.ROBOTO),
        ),
      ),
      onPressed: () {
        if (receiveAddressController.text.isNotEmpty &&
            contactNumberController.text.isNotEmpty) {
          setState(() {
            invalid = false;
          });
          FocusScope.of(context).unfocus();
          logView(contactNumberController.text);
          logView(receiveAddressController.text);
          logView(widget.arguments.data.receiveAmount.toString());
          logView(widget.arguments.data.receiveItem);
          logView(widget.arguments.data.sendAmount.toString());
          logView(widget.arguments.data.sendItem);
          Navigator.pushNamed(
            context,
            RouteName.confirmOrderScreen,
            arguments: PageRouteArguments(
              data: PostModel(
                  contactNumber: contactNumberController.text,
                  receiveAddress: receiveAddressController.text,
                  receiveAmount: widget.arguments.data.receiveAmount,
                  receiveItem: widget.arguments.data.receiveItem,
                  sendAmount: widget.arguments.data.sendAmount,
                  sendItem: widget.arguments.data.sendItem),
            ),
          );
        } else {
          setState(() {
            invalid = true;
          });
        }
      },
    );
  }

  Widget defaultText(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textScaleFactor: 1.0,
        style: TextStyle(
            color: AppColors.color2C2D30,
            fontSize: 11.0.sp,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.ROBOTO),
      ),
    );
  }

  Widget textField(TextEditingController controller) {
    return Container(
      height: 6.0.h,
      margin: EdgeInsets.only(left: 4.0.w, right: 4.0.w),
      padding: EdgeInsets.only(left: 2.0.w, right: 2.0.w),
      decoration: BoxDecoration(
        border: Border.all(
            color: invalid
                ? AppColors.red
                : const Color.fromARGB(255, 120, 117, 117),
            width: 1.0),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: custom_text_form_field(
        controller: controller,
        textInputType: TextInputType.number,
      ),
    );
  }
}
