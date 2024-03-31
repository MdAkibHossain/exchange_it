import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/model/page_arguments_model.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/common/common_app_bar.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../../../route_name.dart';
import '../../../home/data/post_model.dart';
import '../../../home/presentation/widgets/appbar.dart';

class ConfirmOrderScreen extends StatefulWidget {
  const ConfirmOrderScreen({super.key, required this.arguments});
  final PageRouteArguments arguments;

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  @override
  void didChangeDependencies() {
    final bkashAccRef = FirebaseDatabase.instance.ref('/activeAccount/bkash');
    final nagadAccRef = FirebaseDatabase.instance.ref('/activeAccount/nagad');
    super.didChangeDependencies();
    sendItem = widget.arguments.data.sendItem;
    receivedItem = widget.arguments.data.receiveItem;
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
    amountSend = "${widget.arguments.data.sendAmount} $currencySend";
    amountReceive = "${widget.arguments.data.receiveAmount} $currencyreceive";
    receiveDetail = widget.arguments.data.receiveAddress;
    contactPhoneNumber = widget.arguments.data.contactNumber;

    if (sendItem == "বিকাশ BDT") {
      bkashAccRef.child('number').onValue.listen((event) {
        activeAccount = event.snapshot.value.toString();
      });
      bkashAccRef.child('name').onValue.listen((event) {
        activeAccountName = event.snapshot.value.toString();
      });
      bkashAccRef.child('id').onValue.listen((event) {
        activeAccountId = event.snapshot.value.toString();
      });
    } else if (sendItem == "নগদ BDT") {
      nagadAccRef.child('number').onValue.listen((event) {
        activeAccount = event.snapshot.value.toString();
      });
      nagadAccRef.child('name').onValue.listen((event) {
        activeAccountName = event.snapshot.value.toString();
      });
      nagadAccRef.child('id').onValue.listen((event) {
        activeAccountId = event.snapshot.value.toString();
      });
    } else {
      // activeAccount = 'Our Binance PayID';
      // activeAccountId = '';
      // activeAccountName = '562534862';
      activeAccountName = 'Our Binance PayID';
      activeAccountId = '';
      activeAccount = '562534862';
    }
  }

  String? activeAccountName;
  String? activeAccountId;
  String? activeAccount;
  String? currencySend;
  String? currencyreceive;
  String? sendItem;
  String? receivedItem;
  String? amountSend;
  String? amountReceive;
  String? receiveDetail;
  String? contactPhoneNumber;
  String email = FirebaseAuth.instance.currentUser!.email.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CommonAppBarWithNotification(title: "Exchange It", height: 15.0.h),
      body: Column(
        //  mainAxisAlignment: MainAxisAlignment.center,
        children: [
          topSection(),
          SizedBox(height: 4.0.h),
          bottomSection(),
          SizedBox(height: 3.0.h),
          confirmOrderButton(),
        ],
      ),
    );
  }

  Widget confirmOrderButton() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.confirmTransactionScreen,
          arguments: PageRouteArguments(
            data: PostModel(
                contactNumber: contactPhoneNumber,
                receiveAddress: receiveDetail,
                receiveAmount: widget.arguments.data.receiveAmount,
                receiveItem: widget.arguments.data.receiveItem,
                sendAmount: widget.arguments.data.sendAmount,
                sendItem: widget.arguments.data.sendItem,
                activeAccount: activeAccount,
                activeAccountName: activeAccountName,
                activeAccountId: activeAccountId),
          ),
        );
      },
      child: Container(
        height: 5.0.h,
        margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
        //   padding: EdgeInsets.symmetric(vertical: 1.0.h),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.confirm, width: 1.0),
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            color: AppColors.confirm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check,
              color: AppColors.white,
            ),
            SizedBox(
              width: 1.0.w,
            ),
            Text(
              "Confirm Order",
              textScaleFactor: 1.0,
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 12.0.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.POPPINS),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Fee :"),
              if (widget.arguments.data.sendItem == "BinancePay USD")
                defaultText("0")
              else
                defaultText(
                    "${(widget.arguments.data.sendAmount * 0.0185).toStringAsFixed(2)} Tk"),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Total for payment :"),
              if (widget.arguments.data.sendItem == "BinancePay USD")
                defaultText(amountSend!)
              else
                defaultText(
                    "${(widget.arguments.data.sendAmount + (widget.arguments.data.sendAmount * 0.0185)).toStringAsFixed(2)} Tk"),
            ],
          ),
          SizedBox(height: 1.0.h),
        ],
      ),
    );
  }

  Widget topSection() {
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
              titleText(sendItem!),
              SizedBox(
                child: Icon(Icons.sync_alt),
              ),
              titleText(receivedItem!),
            ],
          ),
          commonDivider(),
          defaultText(
              "This exchange is done manually by an operator. \n Work time: 10 AM - 11 PM, GMT+6."),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Amount send :"),
              defaultText(amountSend!),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Amount receive :"),
              defaultText(amountReceive!),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (receivedItem == "বিকাশ Personal BDT")
                defaultText("বিকাশ Personal Number :")
              else if (receivedItem == "নগদ Personal BDT")
                defaultText("নগদ Personal Number :")
              else if (receivedItem == "BinancePay USD")
                defaultText("Binance Pay ID :"),
              defaultText(receiveDetail!),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Contact Phone Number :"),
              defaultText(contactPhoneNumber!),
            ],
          ),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Email :"),
              defaultText(email),
            ],
          ),
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
      margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.5.h),
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
      margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.5.h),
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
}
