import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/model/page_arguments_model.dart';
import 'package:flutter_application_1/core/utils/debug_utils.dart';
import 'package:flutter_application_1/features/home/data/post_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/core/common/drawer/common_drawer.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/common/custom_text_form_field.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../../../route_name.dart';
import '../widgets/appbar.dart';
import '../widgets/common_history_widget.dart';
import '../widgets/follow_us.dart';
import '../widgets/latest_exchanges.dart';

enum Status { buyDollar, sellDollar, exchangeDollar, exchangeBDT }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.arguments});
  final PageRouteArguments? arguments;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    final appVersion = FirebaseDatabase.instance.ref('appVersion/userApp');
    appVersion.onValue.listen((event) {
      appVersionCode = event.snapshot.value.toString();
      logView(appVersionCode.toString());
      if (staticVersionCode != appVersionCode) {
        updateDialog(context);
      }
    });
    super.didChangeDependencies();
    dollarSellingRate = widget.arguments!.datas![1];
    logView(dollarSellingRate.toString());
    dollarBuyingRate = widget.arguments!.datas![0];
    logView(dollarBuyingRate.toString());
    sendController = TextEditingController(text: dollarBuyingRate.toString());
    exchangeRateValue = "$dollarBuyingRate BDT = 1 USD";
  }

  var sendDropDownValue = "বিকাশ BDT";
  var receiveDropDownValue = "BinancePay USD";
  List<String> sendList = ["বিকাশ BDT", "নগদ BDT", "BinancePay USD"];
  List<String> receiveList = [
    "BinancePay USD",
    "বিকাশ Personal BDT",
    "নগদ Personal BDT"
  ];

  String? exchangeRateValue;
  double? dollarBuyingRate;
  double? dollarSellingRate;
  TextEditingController sendController = TextEditingController();
  TextEditingController receiveController = TextEditingController(text: "1");
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var status = Status.buyDollar;
  bool invalidValue = false;
  double? sendAmount;
  double? receiveAmount;

  String appVersionCode = '';
  String staticVersionCode = "1.0.10";
  Future<bool> updateDialog(BuildContext context) async {
    return (await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Update Available!'),
            content: Text('Please update the app.'),
            actions: [
              TextButton(
                //    onPressed: () => Navigator.of(context).pop(true),
                child: Text('Update'),

                onPressed: () async {
                  if (Platform.isAndroid) {
                    await launchUrl(
                        Uri.parse(
                            'https://drive.google.com/drive/folders/1WqsO8117F4Q7TpgYLIRqSxAu34ePg3DW?usp=sharing'),
                        mode: LaunchMode.externalApplication);
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<bool> CommonOnWillPop(BuildContext context) async {
//Future OnWillPop(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                //    onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),

                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (staticVersionCode != appVersionCode) {
          updateDialog(context);
        }
        return CommonOnWillPop(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CommonAppBarWithNotification(
          showNotificationIcon: false,
          height: 15.0.h,
          title: "Exchange It",
          leading: GestureDetector(
            onTap: () {
              if (staticVersionCode != appVersionCode) {
                updateDialog(context);
              }
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: SvgPicture.asset(
                AppAssets.featherMenuIcon,
                // height: 16,
                color: Colors.white,
              ),
            ),
          ),
          // leading: Text("hello"),
        ),
        drawer: CommonDrawer(),
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "দ্রুত অর্ডার সম্পর্ণ করতে যোগাযোগ করুন। ",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: AppColors.color2C2D30,
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: AppFonts.ROBOTO),
                      ),
                      InkWell(
                        onTap: () async {
                          await launchUrl(
                              Uri.parse('https://t.me/exchangeit12'),
                              mode: LaunchMode.externalApplication);
                        },
                        child: Text(
                          "Telegram us!",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: AppColors.color2C2D30,
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppFonts.ROBOTO),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      await launchUrl(Uri.parse('https://t.me/exchangeit12'),
                          mode: LaunchMode.externalApplication);
                    },
                    child: SizedBox(
                      height: 5.0.h,
                      width: 5.0.h,
                      child: SvgPicture.asset(
                        AppAssets.whatsapp,
                        //  fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.0.h),
              senditems(),
              SizedBox(height: 2.0.h),
              receiveditems(),
              SizedBox(height: 2.0.h),
              exchangeButton(),
              SizedBox(height: 4.0.h),
              latest_exchanges(),
              //   CommonHistoryWidget(),
              follow_us_widget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget exchangeButton() {
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
          "Exchange",
          textScaleFactor: 1.0,
          style: TextStyle(
              color: AppColors.white,
              fontSize: 14.0.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.ROBOTO),
        ),
      ),
      onPressed: () {
        // FocusScope.of(context).unfocus();
        if (staticVersionCode != appVersionCode) {
          updateDialog(context);
        }
        if (status == Status.buyDollar ||
            status == Status.exchangeBDT ||
            sendController.text.isEmpty) {
          if (double.parse(sendController.text.toString()) > 499) {
            logView("Good to go");
            setState(() {
              invalidValue = false;
            });
            Navigator.pushNamed(
              context,
              RouteName.detailsInputScreen,
              arguments: PageRouteArguments(
                data: PostModel(
                  sendItem: sendDropDownValue,
                  receiveItem: receiveDropDownValue,
                  sendAmount: sendAmount,
                  receiveAmount: receiveAmount,
                ),
              ),
            );
          } else {
            logView("Min 500 BDT");
            setState(() {
              invalidValue = true;
            });
          }
        } else if (status == Status.sellDollar ||
            status == Status.exchangeDollar ||
            sendController.text.isEmpty) {
          if (double.parse(sendController.text.toString()) > 4.99) {
            logView("Good to go");
            setState(() {
              invalidValue = false;
            });
            Navigator.pushNamed(
              context,
              RouteName.detailsInputScreen,
              arguments: PageRouteArguments(
                data: PostModel(
                  sendItem: sendDropDownValue,
                  receiveItem: receiveDropDownValue,
                  sendAmount: sendAmount,
                  receiveAmount: receiveAmount,
                ),
              ),
            );
          } else {
            logView("Min 5 USD");
            setState(() {
              invalidValue = true;
            });
          }
        }
      },
    );
  }

  Widget receiveditems() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        defaultText("Receive (To)"),
        selectReceiveItem(),
        SizedBox(height: 2.0.h),
        textField(
          controller: receiveController,
          isEnable: false,
          onChnage: (p0) {},
          color: const Color.fromARGB(255, 120, 117, 117),
        ),
        SizedBox(height: 2.0.h),
        // reserve()
      ],
    );
  }

  Widget senditems() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        defaultText("Send (From)"),
        selectSendItem(),
        SizedBox(height: 2.0.h),
        textField(
          controller: sendController,
          isEnable: true,
          onChnage: (p0) {
            sendAmount = double.parse(sendController.text.toString());
            ////
            if (status == Status.buyDollar ||
                status == Status.exchangeBDT ||
                sendController.text.isEmpty) {
              if (double.parse(sendController.text.toString()) > 499) {
                logView("Good to go");
                setState(() {
                  invalidValue = false;
                });
              } else {
                logView("Min 500 BDT");
                setState(() {
                  invalidValue = true;
                });
              }
            } else if (status == Status.sellDollar ||
                status == Status.exchangeDollar ||
                sendController.text.isEmpty) {
              if (double.parse(sendController.text.toString()) > 4.99) {
                logView("Good to go");
                setState(() {
                  invalidValue = false;
                });
              } else {
                logView("Min 5 USD");
                setState(() {
                  invalidValue = true;
                });
              }
            }

            /////
            if (status == Status.buyDollar) {
              receiveController.text =
                  (sendAmount! / dollarBuyingRate!).toStringAsFixed(2);
              receiveAmount = double.parse(receiveController.text);
            } else if (status == Status.sellDollar) {
              receiveController.text =
                  (sendAmount! * dollarSellingRate!).toStringAsFixed(2);
              receiveAmount = double.parse(receiveController.text);
            } else if (status == Status.exchangeDollar) {
              receiveController.text = (sendAmount! * .9).toStringAsFixed(2);
              receiveAmount = double.parse(receiveController.text);
            } else if (status == Status.exchangeBDT) {
              receiveController.text = (sendAmount! * .95).toStringAsFixed(2);
              receiveAmount = double.parse(receiveController.text);
            }
            logView(receiveController.text);
          },
          color: invalidValue
              ? AppColors.red
              : const Color.fromARGB(255, 120, 117, 117),
        ),
        invalidValue
            ? Container(
                margin: EdgeInsets.only(left: 5.0.w, top: 0.5.h),
                child: Row(
                  children: [
                    Text(
                      "*",
                      style: TextStyle(
                          color: AppColors.colorDD0000,
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.ROBOTO),
                    ),
                    SizedBox(width: 0.2.w),
                    Text(
                      status == Status.buyDollar || status == Status.exchangeBDT
                          ? "Minimum 500 BDT"
                          : "Minimum 5 USD",
                      style: TextStyle(
                          color: AppColors.colorDD0000,
                          fontSize: 11.0.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.ROBOTO),
                    ),
                  ],
                ))
            : SizedBox(),
        SizedBox(height: 3.0.h),
        exchangeRate()
      ],
    );
  }

  Widget reserve() {
    return Container(
      height: 6.0.h,
      width: 91.0.w,
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 4.0.w, right: 4.0.w),
      padding: EdgeInsets.only(left: 4.0.w, right: 2.0.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 120, 117, 117),
          width: 1.0,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          Text(
            "Reserve: ",
            style: TextStyle(
                color: AppColors.color2C2D30,
                fontSize: 11.0.sp,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.ROBOTO),
          ),
          Text(
            "153705.52 USD",
            style: TextStyle(
                color: AppColors.color2C2D30,
                fontSize: 11.0.sp,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.ROBOTO),
          ),
        ],
      ),
    );
  }

  Widget exchangeRate() {
    return Container(
      height: 6.0.h,
      width: 91.0.w,
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 4.0.w, right: 4.0.w),
      padding: EdgeInsets.only(left: 4.0.w, right: 2.0.w),
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color.fromARGB(255, 120, 117, 117), width: 1.0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          Text(
            "Exchange rate: ",
            style: TextStyle(
                color: AppColors.color2C2D30,
                fontSize: 11.0.sp,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.ROBOTO),
          ),
          Text(
            //  "117 BDT =",
            exchangeRateValue!,
            style: TextStyle(
                color: AppColors.color2C2D30,
                fontSize: 11.0.sp,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.ROBOTO),
          ),
          // Text(
          //   "1 USD",
          //   style: TextStyle(
          //       color: AppColors.color2C2D30,
          //       fontSize: 11.0.sp,
          //       fontWeight: FontWeight.w500,
          //       fontFamily: AppFonts.ROBOTO),
          // ),
        ],
      ),
    );
  }

  Widget textField({
    required TextEditingController controller,
    required bool isEnable,
    required Function(String) onChnage,
    required Color color,
  }) {
    return Container(
      height: 6.0.h,
      margin: EdgeInsets.only(left: 4.0.w, right: 4.0.w),
      padding: EdgeInsets.only(left: 2.0.w, right: 2.0.w),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.0),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: custom_text_form_field(
        //  hdoubleText: "Enter Amount",
        controller: controller,
        isEnable: isEnable,
        onChange: onChnage,
        textInputType: TextInputType.number,
      ),
    );
  }

  Widget defaultText(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 4.0.w, bottom: 1.0.h),
      child: SizedBox(
        child: Text(
          text,
          textScaleFactor: 1.0,
          style: TextStyle(
              color: AppColors.color2C2D30,
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.ROBOTO),
        ),
      ),
    );
  }

  Widget selectSendItem() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 4.0.w),
      child: Container(
        height: 6.0.h,
        decoration: BoxDecoration(
          // color: AppColors.borderColor,
          border:
              Border.all(color: Color.fromARGB(255, 120, 117, 117), width: 1.0),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        padding: EdgeInsets.only(left: 4.0.w, right: 2.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 85.0.w,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  alignment: Alignment.topCenter,
                  value: sendDropDownValue,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.black,
                    size: 2.5.h,
                  ),
                  //    elevation: 16,
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[800]),
                  onChanged: (String? newValue) {
                    setState(() {
                      sendDropDownValue = newValue!;
                    });
                    setState(() {
                      invalidValue = false;
                      if (sendDropDownValue == "বিকাশ BDT" &&
                          receiveDropDownValue == "বিকাশ Personal BDT") {
                        exchangeRateValue = "1 BDT = 0.95 BDT";
                        status = Status.exchangeBDT;
                        sendController = TextEditingController(text: "1");
                        receiveController = TextEditingController(text: "0.95");
                      } else if (sendDropDownValue == "বিকাশ BDT" &&
                          receiveDropDownValue == "নগদ Personal BDT") {
                        exchangeRateValue = "1 BDT = 0.95 BDT";
                        status = Status.exchangeBDT;
                        sendController = TextEditingController(text: "1");
                        receiveController = TextEditingController(text: "0.95");
                      } else if (sendDropDownValue == "বিকাশ BDT" &&
                          receiveDropDownValue == "BinancePay USD") {
                        exchangeRateValue = "$dollarBuyingRate BDT = 1 USD";
                        status = Status.buyDollar;
                        sendController = TextEditingController(
                            text: dollarBuyingRate.toString());
                        receiveController = TextEditingController(text: "1");
                      } //
                      else if (sendDropDownValue == "নগদ BDT" &&
                          receiveDropDownValue == "বিকাশ Personal BDT") {
                        exchangeRateValue = "1 BDT = 0.95 BDT";
                        status = Status.exchangeBDT;
                        sendController = TextEditingController(text: "1");
                        receiveController = TextEditingController(text: "0.95");
                      } else if (sendDropDownValue == "নগদ BDT" &&
                          receiveDropDownValue == "নগদ Personal BDT") {
                        exchangeRateValue = "1 BDT = 0.95 BDT";
                        status = Status.exchangeBDT;
                        sendController = TextEditingController(text: "1");
                        receiveController = TextEditingController(text: "0.95");
                      } else if (sendDropDownValue == "নগদ BDT" &&
                          receiveDropDownValue == "BinancePay USD") {
                        exchangeRateValue = "$dollarBuyingRate BDT = 1 USD";
                        status = Status.buyDollar;
                        sendController = TextEditingController(
                            text: dollarBuyingRate.toString());
                        receiveController = TextEditingController(text: "1");
                      }
                      //
                      else if (sendDropDownValue == "BinancePay USD" &&
                          receiveDropDownValue == "বিকাশ Personal BDT") {
                        exchangeRateValue = "1 USD = $dollarSellingRate BDT";
                        status = Status.sellDollar;
                        sendController = TextEditingController(text: "1");
                        receiveController = TextEditingController(
                            text: dollarSellingRate.toString());
                      } else if (sendDropDownValue == "BinancePay USD" &&
                          receiveDropDownValue == "নগদ Personal BDT") {
                        exchangeRateValue = "1 USD = $dollarSellingRate BDT";
                        status = Status.sellDollar;
                        sendController = TextEditingController(text: "1");
                        receiveController = TextEditingController(
                            text: dollarSellingRate.toString());
                      } else if (sendDropDownValue == "BinancePay USD" &&
                          receiveDropDownValue == "BinancePay USD") {
                        exchangeRateValue = "1 USD = 0.9 USD";
                        status = Status.exchangeDollar;
                        sendController = TextEditingController(text: "1");
                        receiveController = TextEditingController(text: "0.9");
                      }
                    });
                  },
                  items: sendList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Padding(
                        padding: EdgeInsets.only(left: 0.0.w),
                        child: Text(
                          items,
                          style: TextStyle(
                              fontSize: 11.sp, fontWeight: FontWeight.w400),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget selectReceiveItem() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 4.0.w),
      child: Container(
        height: 6.0.h,
        decoration: BoxDecoration(
          // color: AppColors.borderColor,
          border:
              Border.all(color: Color.fromARGB(255, 120, 117, 117), width: 1.0),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        padding: EdgeInsets.only(left: 4.0.w, right: 2.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 85.0.w,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  alignment: Alignment.topCenter,
                  value: receiveDropDownValue,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.black,
                    size: 2.5.h,
                  ),
                  //    elevation: 16,
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[800]),
                  onChanged: (String? newValue) {
                    setState(() {
                      receiveDropDownValue = newValue!;
                    });
                    setState(
                      () {
                        invalidValue = false;
                        if (sendDropDownValue == "বিকাশ BDT" &&
                            receiveDropDownValue == "বিকাশ Personal BDT") {
                          exchangeRateValue = "1 BDT = 0.95 BDT";
                          status = Status.exchangeBDT;
                          sendController = TextEditingController(text: "1");
                          receiveController =
                              TextEditingController(text: "0.95");
                        } else if (sendDropDownValue == "বিকাশ BDT" &&
                            receiveDropDownValue == "নগদ Personal BDT") {
                          exchangeRateValue = "1 BDT = 0.95 BDT";
                          status = Status.exchangeBDT;
                          sendController = TextEditingController(text: "1");
                          receiveController =
                              TextEditingController(text: "0.95");
                        } else if (sendDropDownValue == "বিকাশ BDT" &&
                            receiveDropDownValue == "BinancePay USD") {
                          exchangeRateValue = "$dollarBuyingRate BDT = 1 USD";
                          status = Status.buyDollar;
                          sendController = TextEditingController(
                              text: dollarBuyingRate.toString());
                          receiveController = TextEditingController(text: "1");
                        } //
                        else if (sendDropDownValue == "নগদ BDT" &&
                            receiveDropDownValue == "বিকাশ Personal BDT") {
                          exchangeRateValue = "1 BDT = 0.95 BDT";
                          status = Status.exchangeBDT;
                          sendController = TextEditingController(text: "1");
                          receiveController =
                              TextEditingController(text: "0.95");
                        } else if (sendDropDownValue == "নগদ BDT" &&
                            receiveDropDownValue == "নগদ Personal BDT") {
                          exchangeRateValue = "1 BDT = 0.95 BDT";
                          status = Status.exchangeBDT;
                          sendController = TextEditingController(text: "1");
                          receiveController =
                              TextEditingController(text: "0.95");
                        } else if (sendDropDownValue == "নগদ BDT" &&
                            receiveDropDownValue == "BinancePay USD") {
                          exchangeRateValue = "$dollarBuyingRate BDT = 1 USD";
                          status = Status.buyDollar;
                          sendController = TextEditingController(
                              text: dollarBuyingRate.toString());
                          receiveController = TextEditingController(text: "1");
                        }
                        //
                        else if (sendDropDownValue == "BinancePay USD" &&
                            receiveDropDownValue == "বিকাশ Personal BDT") {
                          exchangeRateValue = "1 USD = $dollarSellingRate BDT";
                          status = Status.sellDollar;
                          sendController = TextEditingController(text: "1");
                          receiveController = TextEditingController(
                              text: dollarSellingRate.toString());
                        } else if (sendDropDownValue == "BinancePay USD" &&
                            receiveDropDownValue == "নগদ Personal BDT") {
                          exchangeRateValue = "1 USD = $dollarSellingRate BDT";
                          status = Status.sellDollar;
                          sendController = TextEditingController(text: "1");
                          receiveController = TextEditingController(
                              text: dollarSellingRate.toString());
                        } else if (sendDropDownValue == "BinancePay USD" &&
                            receiveDropDownValue == "BinancePay USD") {
                          exchangeRateValue = "1 USD = 0.9 USD";
                          status = Status.exchangeDollar;
                          sendController = TextEditingController(text: "1");
                          receiveController =
                              TextEditingController(text: "0.9");
                        }
                      },
                    );
                  },
                  items: receiveList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Padding(
                        padding: EdgeInsets.only(left: 0.0.w),
                        child: Text(
                          items,
                          style: TextStyle(
                              fontSize: 11.sp, fontWeight: FontWeight.w400),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}











// import 'dart:ui';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:limtech_erp/controller/homeController.dart';
// import 'package:limtech_erp/helper/constrains.dart';
// import 'package:limtech_erp/helper/custom_app_bar.dart';
// import 'package:limtech_erp/models/routeArguments.dart';
// import 'package:limtech_erp/view/deshboard/reusable/dbinfo.dart';
// import 'package:limtech_erp/view/drawerPages.dart';
// import 'package:limtech_erp/view/mahmudul.dart';
// import 'package:limtech_erp/view/storeListScreen.dart';
// import 'package:mvc_pattern/mvc_pattern.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../helper/snackBar.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _HomeScreen();
//   }
// }

// class _HomeScreen extends StateMVC<HomeScreen> {
//   GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
//   HomeController _con;

//   _HomeScreen() : super(HomeController()) {
//     _con = controller;
//   }
//   Future<void> updateDialog(BuildContext context) async {
//     await showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Update New Version!'),
//           content: Text('A new version is available.'),
//           actions: [
//             // TextButton(
//             //   onPressed: () {
//             //     Navigator.of(context).pop();
//             //   },
//             //   child: Text('Cancel'),
//             // ),
//             TextButton(
//               onPressed: () async {
//                 await launchUrl(
//                     Uri.parse(
//                         'https://play.google.com/store/apps/details?id=com.limerickbd.limtech_erp'),
//                     mode: LaunchMode.externalApplication);
//               },
//               child: Text('Update'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<String> checkVersion(BuildContext context) async {
//     final String checkOutUrl = '${Constants.BASEURL}version';
//     var dioClient = Dio();
//     // dioClient.options.headers['authorization'] = "Bearer " + token;
//     dioClient.options.headers['Accept'] = {"application/json"};
//     dioClient.options.headers['content-Type'] = 'application/json';

//     try {
//       final response = await dioClient.get(checkOutUrl);
//       debugPrint('postStoreClosedAPI: ' + response.data.toString());
//       if (response.statusCode == 200) {
//         if (staticVersionCode != response.data['version']) {
//           updateDialog(context);
//         }
//       } else {
//         debugPrint('postStoreClosedAPI Error1: ' + response.data.toString());
//         throwFailure(response.statusCode, context);
//       }
//     } on DioError catch (e) {
//       debugPrint('Dio postStoreClosedAPI Error: ' + e.response.toString());
//       if (e.response.statusCode == 400) {
//         showErrorSnackBar(e.response.data["message"], context);
//       } else {
//         throwFailure(e.response.statusCode, context);
//       }
//     }
//   }

//   @override
//   void initState() {
//     _con.checkPermission();
//     _con.getUserLocation();

//     _con.isAttend();
//     // _con.todayStoreData();
//     _con.getCartList();
//     checkVersion(context);
//     super.initState();
//   }

//   String appVersionCode = '';
//   String staticVersionCode = "1.1.1";

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => _con.showAlertDialog(context),
//       child: SafeArea(
//         child: Scaffold(
//           appBar: CustomAppBar(
//             height: 50,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 InkWell(
//                     onTap: () {
//                       if (_con.scaffoldKey.currentState.isDrawerOpen == false) {
//                         _con.scaffoldKey.currentState.openDrawer();
//                       } else {
//                         _con.scaffoldKey.currentState.openEndDrawer();
//                       }
//                     },
//                     child: Icon(
//                       Icons.menu,
//                       size: 28,
//                       color: Colors.white,
//                     )),
//                 SizedBox(
//                   width: 8,
//                 ),
//                 Row(
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => DashboardScreenNew()),
//                         );
//                       },
//                       child: Text(
//                         "Dashboard",
//                         style: GoogleFonts.roboto(
//                             textStyle: Theme.of(context).textTheme.headline4,
//                             fontSize: 25,
//                             // fontWeight: FontWeight.w700,
//                             color: Colors.white),
//                       ),
//                     )
//                     // Text(
//                     //   "Dashboard",
//                     //   style: GoogleFonts.roboto(
//                     //       textStyle: Theme.of(context).textTheme.headline4,
//                     //       fontSize: 25,
//                     //       // fontWeight: FontWeight.w700,
//                     //       color: Colors.white),
//                     // ),
//                   ],
//                 ),
//                 SizedBox(
//                   width: 8,
//                 ),
//                 InkWell(
//                     onTap: () {
//                       _con.getCartList();
//                     },
//                     child: Icon(
//                       Icons.home_outlined,
//                       size: 28,
//                       color: Colors.white,
//                     )),
//               ],
//             ),
//           ),
//           body: Scaffold(
//             key: _con.scaffoldKey,
//             drawer: DrawerPages(),
//             body: !_con.loadingState
//                 ? Container(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(top: 0.0, left: 0, right: 0),
//                           child: Container(
//                             color: Color.fromARGB(255, 216, 213, 213)
//                                 .withOpacity(0.8),
//                             child: Padding(
//                               padding: EdgeInsets.only(
//                                   left: 10.0, right: 10.0, top: 20, bottom: 20),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     children: [
//                                       DbOptions('Store List', Icons.store, () {
//                                         Navigator.of(context)
//                                             .pushNamed('/StoreListScreen');
//                                       }),
//                                       SizedBox(height: 3),
//                                       DbOptions(
//                                           'Target Acheivement', Icons.circle,
//                                           () async {
//                                         SharedPreferences pref =
//                                             await SharedPreferences
//                                                 .getInstance();
//                                         String role =
//                                             pref.getString(Constants.ROLE);
//                                         if (role == "SR") {
//                                           Navigator.of(context).pushNamed(
//                                               '/TargetAchievementScreen',
//                                               arguments: RouteArgument(
//                                                   id: pref
//                                                       .getInt(Constants.ID)));
//                                         } else {
//                                           Navigator.of(context).pushNamed(
//                                               '/RoleWiseUserScreen',
//                                               arguments: RouteArgument(id: 1));
//                                         }
//                                       }),
//                                     ],
//                                   ),
//                                   Column(
//                                     children: [
//                                       // DbOptions('Custom Report',
//                                       //     Icons.dashboard_customize, () {
//                                       //   Navigator.of(context).pushNamed(
//                                       //       '/WebViewScreen',
//                                       //       arguments: RouteArgument(
//                                       //           title:
//                                       //               "http://api.acplbd.com/custom/custom_report"));
//                                       // }),
//                                       // SizedBox(height: 3),
//                                       DbOptions('Order List', Icons.list_alt,
//                                           () async {
//                                         SharedPreferences pref =
//                                             await SharedPreferences
//                                                 .getInstance();
//                                         String role =
//                                             pref.getString(Constants.ROLE);
//                                         if (role == "SR") {
//                                           Navigator.of(context).pushNamed(
//                                               '/OrderListScreen',
//                                               arguments: RouteArgument(
//                                                   id: pref
//                                                       .getInt(Constants.ID)));
//                                         } else {
//                                           Navigator.of(context).pushNamed(
//                                               '/RoleWiseUserScreen',
//                                               arguments: RouteArgument(id: 2));
//                                         }
//                                       }),
//                                       DbOptions('Daily Order', Icons.book, () {
//                                         Navigator.of(context)
//                                             .pushNamed('/TodayOrderScreen');
//                                       }),
//                                     ],
//                                   ),
//                                   Column(
//                                     children: [
//                                       DbOptions('Add Store',
//                                           Icons.home_repair_service, () {
//                                         Navigator.of(context)
//                                             .pushNamed('/StoreCreateScreen');
//                                       }),
//                                       // SizedBox(height: 3),
//                                       DbOptions(
//                                         'Reports',
//                                         Icons.report,
//                                         () async {
//                                           SharedPreferences pref =
//                                               await SharedPreferences
//                                                   .getInstance();
//                                           String role =
//                                               pref.getString(Constants.ROLE);
//                                           int id = pref.getInt(Constants.ID);
//                                           if (role == "SR") {
//                                             if (id != null) {
//                                               Navigator.pushNamed(context,
//                                                   "/ReportDetailsScreen",
//                                                   arguments:
//                                                       RouteArgument(id: id));
//                                             }
//                                             // //Navigator.of(context).pop();
//                                             // showErrorSnackBar("You can't access any report as you are a seals representative.",context);
//                                           } else {
//                                             Navigator.of(context)
//                                                 .pushNamed('/ReportScreen');
//                                           }
//                                           //Navigator.of(context).pushNamed('/Donate');
//                                         },
//                                       )
//                                     ],
//                                   ),

//                                   // Column(
//                                   //   children: [
//                                   //     // SizedBox(height: ,),
//                                   //     DbOptions('Add Store',
//                                   //         Icons.home_repair_service, () {
//                                   //       Navigator.of(context)
//                                   //           .pushNamed('/StoreCreateScreen');
//                                   //     }),
//                                   //     SizedBox(height: 3),
//                                   //     DbOptions('Route plan', Icons.navigation,
//                                   //         () async {
//                                   //       SharedPreferences pref =
//                                   //           await SharedPreferences
//                                   //               .getInstance();
//                                   //       String role =
//                                   //           pref.getString(Constants.ROLE);
//                                   //       if (role == "SR") {
//                                   //         Navigator.of(context).pushNamed(
//                                   //             '/SrRoutePlanListScreen');
//                                   //       } else {
//                                   //         Navigator.of(context).pushNamed(
//                                   //             '/OtherRoutePlanListScreen');
//                                   //       }
//                                   //     }),
//                                   //     SizedBox(
//                                   //       height: 30,
//                                   //     ),
//                                   //   ],
//                                   // ),

//                                   Column(
//                                     children: [
//                                       // SizedBox(height: 3),
//                                       DbOptions('Route plan', Icons.navigation,
//                                           () async {
//                                         SharedPreferences pref =
//                                             await SharedPreferences
//                                                 .getInstance();
//                                         String role =
//                                             pref.getString(Constants.ROLE);
//                                         if (role == "SR") {
//                                           Navigator.of(context).pushNamed(
//                                               '/SrRoutePlanListScreen');
//                                         } else {
//                                           Navigator.of(context).pushNamed(
//                                               '/OtherRoutePlanListScreen');
//                                         }
//                                       }),
//                                       DbOptions('Check Out',
//                                           Icons.shopping_cart_checkout, () {
//                                         _con.checkOut();
//                                         // print("object");
//                                         // Navigator.of(context)
//                                         //     .pushNamed('/StoreCreateScreen');
//                                       }),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                         _con.isAttendanceGiven
//                             ? InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     // _con.getUserCurrentLocation();
//                                   });
//                                 },
//                                 child: Container(
//                                     alignment: Alignment.topCenter,
//                                     color: Color(0XFF355BA7),
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(
//                                           left: 4.0,
//                                           right: 4,
//                                           top: 4,
//                                           bottom: 10),
//                                       child: Text(
//                                         "Today's Store",
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             fontSize: 18, color: Colors.white),
//                                       ),
//                                     )),
//                               )
//                             : InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     _con.getUserCurrentLocation();
//                                   });
//                                 },
//                                 child: Container(
//                                     alignment: Alignment.topCenter,
//                                     color: Color(0XFF355BA7),
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(
//                                           left: 4.0,
//                                           right: 4,
//                                           top: 4,
//                                           bottom: 10),
//                                       child: Text(
//                                         'Provide Attendance',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             fontSize: 18, color: Colors.white),
//                                       ),
//                                     )),
//                               ),
//                         SizedBox(
//                           height: 10,
//                         ),

//                         // _con.todaysStoreDataModel != null &&
//                         //         _con.todaysStoreDataModel.todaysStores.length >
//                         //             0
//                         //     ? _con.todayStores.length > 0
//                         //         ? Text("1st")
//                         //         : Text("2nd")
//                         //     : Text("3rd"),

//                         _con.todayStores.length > 0
//                             ? Flexible(
//                                 fit: FlexFit.loose,
//                                 child: GridView.builder(
//                                     itemCount: _con.todayStores.length,
//                                     scrollDirection: Axis.vertical,
//                                     shrinkWrap: true,
//                                     physics: AlwaysScrollableScrollPhysics(),
//                                     gridDelegate:
//                                         SliverGridDelegateWithFixedCrossAxisCount(
//                                       childAspectRatio: 4,
//                                       crossAxisCount: 1,
//                                     ),
//                                     itemBuilder: (context, index) {
//                                       return InkWell(
//                                         onTap: () async {
//                                           bool networkConnection =
//                                               await _con.connectivity();
//                                           bool isOnline =
//                                               await _con.hasNetwork();
//                                           if (networkConnection) {
//                                             if (isOnline) {
//                                               _con.storeListCalculation(
//                                                   double.parse(_con.todayStores
//                                                       .elementAt(index)
//                                                       .lat),
//                                                   double.parse(_con.todayStores
//                                                       .elementAt(index)
//                                                       .lng),
//                                                   _con.todayStores
//                                                       .elementAt(index)
//                                                       .id,
//                                                   _con.todayStores
//                                                       .elementAt(index)
//                                                       .name);
//                                             } else {
//                                               _con.offlineCheckIn(
//                                                   _con.todayStores
//                                                       .elementAt(index)
//                                                       .id,
//                                                   _con.todayStores
//                                                       .elementAt(index)
//                                                       .name);
//                                             }
//                                           }
//                                           //_con.offlineCheckIn(_con.todayStores.elementAt(index).id,_con.todayStores.elementAt(index).name);
//                                         },
//                                         child: Container(
//                                           margin: EdgeInsets.symmetric(
//                                               horizontal: 8, vertical: 4),
//                                           //height: 100,
//                                           decoration: BoxDecoration(
//                                               color: _con.todayStores
//                                                           .elementAt(index)
//                                                           .isCheckedinToday &&
//                                                       !_con.todayStores
//                                                           .elementAt(index)
//                                                           .tookOrder
//                                                   ? Colors.blueAccent
//                                                       .withOpacity(0.10)
//                                                   : _con.todayStores
//                                                           .elementAt(index)
//                                                           .tookOrder
//                                                       ? Colors.green
//                                                           .withOpacity(0.10)
//                                                       : _con.todayStores
//                                                               .elementAt(index)
//                                                               .isInTodaysRoute
//                                                           ? Colors.grey
//                                                               .withOpacity(0.10)
//                                                           : Colors.red
//                                                               .withOpacity(
//                                                                   0.10),
//                                               borderRadius:
//                                                   BorderRadius.circular(16),
//                                               border: Border.all(
//                                                   color: Theme.of(context)
//                                                       .buttonColor,
//                                                   width: 0.5)),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             children: [
//                                               Expanded(
//                                                 flex: 2,
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           left: 5.0, top: 3),
//                                                   child: Text(
//                                                     "Name: " +
//                                                         _con.todayStores
//                                                             .elementAt(index)
//                                                             .name,
//                                                     style:
//                                                         TextStyle(fontSize: 20),
//                                                     textAlign: TextAlign.start,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                   flex: 1,
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 5.0, top: 0),
//                                                     child: Text(
//                                                       "Proprietor: " +
//                                                           _con.todayStores
//                                                               .elementAt(index)
//                                                               .proprietor,
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .bodyText1,
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                     ),
//                                                   )),
//                                               Expanded(
//                                                   flex: 2,
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 5.0,
//                                                             top: 0,
//                                                             bottom: 3),
//                                                     child: Text(
//                                                       "Address: " +
//                                                           _con.todayStores
//                                                               .elementAt(index)
//                                                               .address,
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .bodyText2,
//                                                       textAlign:
//                                                           TextAlign.start,
//                                                     ),
//                                                   )),
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     }),
//                               )
//                             : Center(
//                                 child: Text(
//                                   "Today's store is empty",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.red),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),

//                         _con.isAttendanceGiven
//                             ? SizedBox()
//                             : Text(
//                                 "NB: To continue your daily work please provide attendance.",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.red),
//                                 textAlign: TextAlign.center,
//                               ),
//                         // _con.isAttendanceGiven &&
//                         //         _con.selectedStoreId != null &&
//                         //         _con.storeName != ""
//                         //     ? InkWell(
//                         //         onTap: () {
//                         //           setState(() {
//                         //             _con.checkInPopUp(context);
//                         //             //_con.checkIn(_con.selectedStoreId);
//                         //           });
//                         //         },
//                         //         child: Container(
//                         //             alignment: Alignment.topCenter,
//                         //             color: Color(0XFF355BA7),
//                         //             child: Padding(
//                         //               padding: const EdgeInsets.only(
//                         //                   left: 4.0,
//                         //                   right: 4,
//                         //                   top: 4,
//                         //                   bottom: 10),
//                         //               child: Text(
//                         //                 '${_con.storeName}',
//                         //                 textAlign: TextAlign.center,
//                         //                 style: TextStyle(
//                         //                     fontSize: 18, color: Colors.white),
//                         //               ),
//                         //             )),
//                         //       )
//                         //     : SizedBox(),

//                         // DbOptions('Dashboard', Icons.shopping_cart_checkout,
//                         //     () {
//                         //   Navigator.push(
//                         //     context,
//                         //     MaterialPageRoute(
//                         //         builder: (context) => DashboardScreenNew()),
//                         //   );
//                         // }),
//                       ],
//                     ),
//                   )
//                 : Center(child: CircularProgressIndicator()),
//           ),
//         ),
//       ),
//     );
//   }
// }
