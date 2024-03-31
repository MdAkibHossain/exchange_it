import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/model/page_arguments_model.dart';
import 'package:flutter_application_1/core/utils/debug_utils.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/common/custom_text_form_field.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../../../route_name.dart';
import '../../../home/presentation/widgets/appbar.dart';

class ConfirmTransactionScreen extends StatefulWidget {
  const ConfirmTransactionScreen({super.key, required this.arguments});
  final PageRouteArguments arguments;

  @override
  State<ConfirmTransactionScreen> createState() =>
      _ConfirmTransactionScreenState();
}

class _ConfirmTransactionScreenState extends State<ConfirmTransactionScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.arguments.data.sendItem == "বিকাশ BDT") {
      ourDetails = "Our বিকাশ Personal No Details.";
      ourReceiveItem = "বিকাশ Send Money :";
      currencySend = "BDT";
    } else if (widget.arguments.data.sendItem == "নগদ BDT") {
      //    ourDetails = "Our নগদ Details.";
      // ourReceiveItem = "নগদ Personal No.(Send Money) :";
      ourDetails = "Our নগদ Personal No Details.";
      ourReceiveItem = "নগদ Send Money :";
      currencySend = "BDT";
    } else if (widget.arguments.data.sendItem == "BinancePay USD") {
      ourDetails = "Our Binance Details.";
      ourReceiveItem = "Binance PayID:";
      currencySend = "USD";
    }
    if (widget.arguments.data.receiveItem == "বিকাশ BDT") {
      currencyReceived = "BDT";
    } else if (widget.arguments.data.receiveItem == "নগদ BDT") {
      currencyReceived = "BDT";
    } else if (widget.arguments.data.receiveItem == "BinancePay USD") {
      currencyReceived = "USD";
    }
    ourReceiveAddress = widget.arguments.data.receiveAddress;

    String amo = widget.arguments.data.sendAmount.toString();
    amountSend = "$amo $currencySend";

    String amoR = widget.arguments.data.receiveAmount.toString();
    amountReceived = "$amoR $currencyReceived";

    logView(widget.arguments.data.receiveAmount.toString());

    if (widget.arguments.data.sendItem != "BinancePay USD") {
      revenueInBDT = (double.parse(amo) * 0.0185);
    }
    logView(revenueInBDT.toString());
  }

  String email = FirebaseAuth.instance.currentUser!.email.toString();
  String? currencySend;
  String? currencyReceived;
  String? ourDetails;
  String? ourReceiveItem;
  String? ourReceiveAddress;
  String? amountSend;
  String? amountReceived;
  TextEditingController transactionNumberController = TextEditingController();
  double revenueInBDT = 0;

  final firebaseDatabaseRef = FirebaseDatabase.instance.ref("Orders");

  bool invalid = false;
  // bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CommonAppBarWithNotification(title: "Exchange It", height: 15.0.h),
      body: SingleChildScrollView(
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.center,
          children: [
            topSection(),
            SizedBox(height: 4.0.h),
            if (widget.arguments.data.sendItem == "BinancePay USD")
              titleText("Binance Order ID.")
            else
              titleText("Enter transaction number."),
            SizedBox(height: 1.0.h),
            textField(),
            SizedBox(height: 3.0.h),
            confirmOrderButton(),
          ],
        ),
      ),
    );
  }

  Widget confirmOrderButton() {
    return InkWell(
      onTap: () {
        String id = DateTime.now().millisecondsSinceEpoch.toString();
        FocusScope.of(context).unfocus();
        setState(() {
          invalid = false;
          //  isLoading = true;
        });
        if (transactionNumberController.text.isNotEmpty) {
          firebaseDatabaseRef.child(id).set({
            'id': id,
            'email': email,
            'sendItem': widget.arguments.data.sendItem,
            'receiveItem': widget.arguments.data.receiveItem,
            'sendAmount':
                // amountSend,
                widget.arguments.data.sendAmount,
            'receiveAmount':
                //amountReceived,
                widget.arguments.data.receiveAmount,
            'receiveAddress': widget.arguments.data.receiveAddress,
            'contactNumber': widget.arguments.data.contactNumber,
            'transactionNumber': widget.arguments.data.transactionNumber,
            'status': 'Processing',
            'createdAt': DateTime.now().toIso8601String(),
            'transactionNumber': transactionNumberController.text,
            'revenueInBDT': revenueInBDT,
            'activeAccountDetails': {
              'accountName': widget.arguments.data.activeAccountName,
              'accountNumber': widget.arguments.data.activeAccount,
              'accountId': widget.arguments.data.activeAccountId,
            }
          }).then((value) {
            // setState(() {
            //   isLoading = false;
            // });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Your order has been placed!"),
              duration: Duration(seconds: 2),
              backgroundColor: AppColors.confirm,
            ));
            // final sellRef =
            //     FirebaseDatabase.instance.ref('dollarRate/dollarSellingRate');
            // final buyRef =
            //     FirebaseDatabase.instance.ref('dollarRate/dollarBuyingRate');
            // double? dollarBuyingRate;
            // double? dollarSellingRate;
            // sellRef.onValue.listen((event) {
            //   dollarSellingRate = double.parse(event.snapshot.value.toString());
            //   buyRef.onValue.listen((event) {
            //     dollarBuyingRate =
            //         double.parse(event.snapshot.value.toString());
            //     Navigator.pushReplacementNamed(
            //         context, RouteName.myHistoryScreen,
            //         arguments: PageRouteArguments(
            //             datas: [dollarBuyingRate, dollarSellingRate]));
            //   });
            // });
            Navigator.pushReplacementNamed(context, RouteName.myHistoryScreen);
          });
        } else {
          setState(() {
            invalid = true;
          });
        }
      },
      child: Container(
        height: 5.0.h,
        margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
        //padding: EdgeInsets.symmetric(vertical: 1.0.h),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.googleBlue, width: 1.0),
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            color: AppColors.googleBlue),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Icon(
            //   Icons.check,
            //   color: AppColors.white,
            // ),
            // SizedBox(
            //   width: 1.0.w,
            // ),
            Text(
              "Confirm Transaction",
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

  Widget textField() {
    return Container(
      height: 6.0.h,
      margin: EdgeInsets.only(left: 4.0.w, right: 4.0.w),
      padding: EdgeInsets.only(left: 2.0.w, right: 2.0.w),
      decoration: BoxDecoration(
        border: Border.all(
            color: invalid ? AppColors.red : Color.fromARGB(255, 120, 117, 117),
            width: 1.0),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: custom_text_form_field(
        controller: transactionNumberController,
        textInputType: TextInputType.text,
        onChange: (p0) {
          if (transactionNumberController.text.isNotEmpty) {
            setState(() {
              invalid = false;
            });
          }
        },
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
          titleText("Data about transfer"),
          commonDivider(),
          defaultText(
              "This exchange is done manually by an operator. \n Work time: 10 AM - 11 PM, GMT+6."),
          commonDivider(),
          //defaultText(""),
          SizedBox(height: 1.5.h),
          commonDivider(),
          defaultText(ourDetails!),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText(ourReceiveItem!),
              // Expanded(
              //     child:
              //  if (widget.arguments.data.sendItem == "BinancePay USD")
              //  defaultText(widget.arguments.data.n.toString()),
              defaultText(widget.arguments.data.activeAccount.toString()),
              //),
            ],
          ),
          commonDivider(),
          //  defaultText(""),
          SizedBox(height: 1.5.h),
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Payment amount :"),
              if (widget.arguments.data.sendItem == "BinancePay USD")
                defaultText(amountSend.toString())
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
      child: SelectableText(
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
