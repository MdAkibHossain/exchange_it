import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/debug_utils.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';

class latest_exchanges extends StatefulWidget {
  const latest_exchanges({super.key});

  @override
  State<latest_exchanges> createState() => _latest_exchangesState();
}

class _latest_exchangesState extends State<latest_exchanges> {
  final history = FirebaseDatabase.instance.ref('Orders');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        headerText(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.5.h),
          child: Divider(
            thickness: 0.3.w,
          ),
        ),
        SizedBox(
          height: 33.0.h,
          child: FirebaseAnimatedList(
            query: history,
            reverse: true,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              if (snapshot.child("status").value.toString() == '') {}
              return Column(
                children: [
                  listCard(
                      sendItem: snapshot.child("sendItem").value.toString(),
                      receivedItem:
                          snapshot.child("receiveItem").value.toString(),
                      sendAmount: snapshot.child("sendAmount").value.toString(),
                      receivedAmount:
                          snapshot.child("receiveAmount").value.toString(),
                      dateTime: snapshot.child("createdAt").value.toString(),
                      status: snapshot.child("status").value.toString()),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget listCard(
      {required String sendItem,
      required String receivedItem,
      required String sendAmount,
      required String receivedAmount,
      required String dateTime,
      required String status}) {
    String? currencySend;
    String? currencyreceive;
    if (sendItem == "বিকাশ BDT" || sendItem == "নগদ BDT") {
      currencySend = "BDT";
    } else {
      currencySend = "USD";
    }
    if (receivedItem == "বিকাশ Personal BDT" ||
        receivedItem == "নগদ Personal BDT") {
      currencyreceive = "BDT";
    } else {
      currencyreceive = "USD";
    }
    String amountSend;
    String amountReceive;
    amountSend = "$sendAmount $currencySend";
    amountReceive = "$receivedAmount $currencyreceive";
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
      padding: EdgeInsets.symmetric(vertical: 1.0.h),
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color.fromARGB(255, 120, 117, 117), width: 1.0),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 1.0.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              titleText(sendItem),
              const SizedBox(
                child: Icon(Icons.sync_alt),
              ),
              titleText(receivedItem),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Amount send :"),
              defaultText(amountSend),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Amount receive :"),
              defaultText(amountReceive),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("DateTime :"),
              defaultText(
                  "${DateFormat.yMMMMd('en_US').format(DateTime.parse(dateTime))} ${DateFormat.jm().format(DateTime.parse(dateTime))}"),
            ],
          ),
          commonDivider(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              child: Text(
                "Status: ",
                textScaleFactor: 1.0,
                style: TextStyle(
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.ROBOTO),
              ),
            ),
            if (status == "Processing")
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppColors.googleBlue,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.timelapse_outlined,
                      color: AppColors.white,
                    ),
                    Text(
                      status,
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.POPPINS),
                    )
                  ],
                ),
              )
            else if (status == "Confirm")
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppColors.confirm,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check,
                      color: AppColors.white,
                    ),
                    Text(
                      "Confirm",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.POPPINS),
                    )
                  ],
                ),
              )
            else if (status == "Cancel")
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.cancel,
                      color: AppColors.white,
                    ),
                    Text(
                      "Cancel",
                      // textScaleFactor: 1.0,
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.POPPINS),
                    )
                  ],
                ),
              ),
          ]),
          SizedBox(height: 1.0.h),
        ],
      ),
    );
  }

  Widget commonDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.1.h),
      child: Divider(
        thickness: 0.3.w,
      ),
    );
  }

  Widget titleText(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.0.h),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textScaleFactor: 1.0,
        style: TextStyle(
            // color: AppColors.color2C2D30,
            color: AppColors.color525252,
            fontSize: 12.0.sp,
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.ROBOTO),
      ),
    );
  }

  Widget defaultText(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.0.h),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textScaleFactor: 1.0,
        style: TextStyle(
            // color: AppColors.color2C2D30,
            color: AppColors.color525252,
            fontSize: 11.0.sp,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.ROBOTO),
      ),
    );
  }

  Widget headerText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 8.0.h),
      decoration: BoxDecoration(
          border: Border.all(width: 0.7.w, color: AppColors.googleBlue),
          borderRadius: BorderRadius.circular(5)),
      child: SizedBox(
        child: Text(
          "Latest Exchanges",
          textScaleFactor: 1.0,
          style: TextStyle(
              color: Color.fromARGB(255, 147, 146, 146),
              fontSize: 18.0.sp,
              fontWeight: FontWeight.w800,
              fontFamily: AppFonts.ROBOTO),
        ),
      ),
    );
  }
}
