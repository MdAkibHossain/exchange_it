import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/common/drawer/common_drawer.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../../home/presentation/widgets/appbar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyHistoryScreen extends StatefulWidget {
  const MyHistoryScreen({
    super.key,
  });

  @override
  State<MyHistoryScreen> createState() => _MyHistoryScreenState();
}

class _MyHistoryScreenState extends State<MyHistoryScreen> {
  final history = FirebaseDatabase.instance.ref('Orders');
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
        return CommonOnWillPop(context);
      },
      child: Scaffold(
        // key: _scaffoldKey,
        // appBar: CommonAppBarWithNotification(
        //   showNotificationIcon: false,
        //   height: 15.0.h,
        //   title: "My History",
        //   leading: GestureDetector(
        //     onTap: () {
        //       _scaffoldKey.currentState?.openDrawer();
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.all(14),
        //       child: SvgPicture.asset(
        //         AppAssets.featherMenuIcon,
        //         // height: 16,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        //   // leading: Text("hello"),
        // ),
        // drawer: CommonDrawer(),
        appBar: CommonAppBarWithNotification(
          title: "My History",
          height: 15.0.h,
          isGotoHome: true,
        ),
        body: SizedBox(
          // height: 33.0.h,
          child: FirebaseAnimatedList(
            reverse: true,
            query: history,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              if (snapshot.child("email").value.toString() == email) {
                return Column(
                  children: [
                    listCard(
                        sendItem: snapshot.child("sendItem").value.toString(),
                        receivedItem:
                            snapshot.child("receiveItem").value.toString(),
                        sendAmount:
                            snapshot.child("sendAmount").value.toString(),
                        receivedAmount:
                            snapshot.child("receiveAmount").value.toString(),
                        dateTime: snapshot.child("createdAt").value.toString(),
                        status: snapshot.child("status").value.toString(),
                        contactNumber:
                            snapshot.child("contactNumber").value.toString(),
                        email: snapshot.child("email").value.toString()),
                  ],
                );
              }
              return SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget listCard(
      {required String sendItem,
      required String receivedItem,
      required String sendAmount,
      required String contactNumber,
      required String receivedAmount,
      required String email,
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
        child: Column(children: [
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              defaultText("Contact Phone Number :"),
              defaultText(contactNumber),
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
          commonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     SizedBox(
              //       child: Text(
              //         "Status: ",
              //         textScaleFactor: 1.0,
              //         style: TextStyle(
              //             fontSize: 12.0.sp,
              //             fontWeight: FontWeight.w600,
              //             fontFamily: AppFonts.ROBOTO),
              //       ),
              //     ),
              //     Container(
              //       padding:
              //           EdgeInsets.symmetric(horizontal: 1.0.w, vertical: 0.1.h),
              //       decoration: BoxDecoration(
              //           color: AppColors.googleBlue,
              //           borderRadius: BorderRadius.circular(3)),
              //       child: Row(
              //         children: [
              //           const Icon(
              //             Icons.timelapse_outlined,
              //             color: AppColors.white,
              //           ),
              //           Text(
              //             status,
              //             textScaleFactor: 1.0,
              //             style: TextStyle(
              //                 color: AppColors.white,
              //                 fontSize: 11.0.sp,
              //                 fontWeight: FontWeight.w500,
              //                 fontFamily: AppFonts.POPPINS),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),

              SizedBox(height: 1.0.h),
            ],
          ),
        ]));
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
}

////////-0395984654======---------2///////

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:sizer/sizer.dart';
// import '../../../../core/common/drawer/common_drawer.dart';
// import '../../../../core/utils/app_assets.dart';
// import '../../../../core/utils/app_colors.dart';
// import '../../../../core/utils/app_fonts.dart';
// import '../../../home/presentation/widgets/appbar.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class MyHistoryScreen extends StatefulWidget {
//   const MyHistoryScreen({
//     super.key,
//   });

//   @override
//   State<MyHistoryScreen> createState() => _MyHistoryScreenState();
// }

// class _MyHistoryScreenState extends State<MyHistoryScreen> {
//   final history = FirebaseDatabase.instance.ref('Orders');
//   String email = FirebaseAuth.instance.currentUser!.email.toString();
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // key: _scaffoldKey,
//       // appBar: CommonAppBarWithNotification(
//       //   showNotificationIcon: false,
//       //   height: 15.0.h,
//       //   title: "My History",
//       //   leading: GestureDetector(
//       //     onTap: () {
//       //       _scaffoldKey.currentState?.openDrawer();
//       //     },
//       //     child: Padding(
//       //       padding: const EdgeInsets.all(14),
//       //       child: SvgPicture.asset(
//       //         AppAssets.featherMenuIcon,
//       //         // height: 16,
//       //         color: Colors.white,
//       //       ),
//       //     ),
//       //   ),
//       //   // leading: Text("hello"),
//       // ),
//       // drawer: CommonDrawer(),
//       appBar: CommonAppBarWithNotification(
//         title: "My History",
//         height: 15.0.h,
//         isGotoHome: true,
//       ),
//       body: SizedBox(
//         // height: 33.0.h,
//         child: FirebaseAnimatedList(
//           query: history,
//           itemBuilder: (BuildContext context, DataSnapshot snapshot,
//               Animation<double> animation, int index) {
//             if (snapshot.child("email").value.toString() == email) {
//               return Column(
//                 children: [
//                   listCard(
//                       sendItem: snapshot.child("sendItem").value.toString(),
//                       receivedItem:
//                           snapshot.child("receiveItem").value.toString(),
//                       sendAmount: snapshot.child("sendAmount").value.toString(),
//                       receivedAmount:
//                           snapshot.child("receiveAmount").value.toString(),
//                       dateTime: snapshot.child("createdAt").value.toString(),
//                       status: snapshot.child("status").value.toString(),
//                       contactNumber:
//                           snapshot.child("contactNumber").value.toString(),
//                       email: snapshot.child("email").value.toString()),
//                 ],
//               );
//             }
//             return SizedBox();
//           },
//         ),
//       ),
//     );
//   }

//   Widget listCard(
//       {required String sendItem,
//       required String receivedItem,
//       required String sendAmount,
//       required String contactNumber,
//       required String receivedAmount,
//       required String email,
//       required String dateTime,
//       required String status}) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
//       padding: EdgeInsets.symmetric(vertical: 1.0.h),
//       decoration: BoxDecoration(
//         border: Border.all(
//             color: const Color.fromARGB(255, 120, 117, 117), width: 1.0),
//         borderRadius: const BorderRadius.all(
//           Radius.circular(8),
//         ),
//       ),
//       child: Column(
//         children: [
//           SizedBox(height: 1.0.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               titleText(sendItem),
//               const SizedBox(
//                 child: Icon(Icons.sync_alt),
//               ),
//               titleText(receivedItem),
//             ],
//           ),
//           commonDivider(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               defaultText("Amount send :"),
//               defaultText(sendAmount),
//             ],
//           ),
//           commonDivider(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               defaultText("Amount receive :"),
//               defaultText(receivedAmount),
//             ],
//           ),
//           commonDivider(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               defaultText("DateTime :"),
//               defaultText(
//                   "${DateFormat.yMMMMd('en_US').format(DateTime.parse(dateTime))} ${DateFormat.jm().format(DateTime.parse(dateTime))}"),
//             ],
//           ),
//           commonDivider(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               defaultText("Contact Phone Number :"),
//               defaultText(contactNumber),
//             ],
//           ),
//           commonDivider(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               defaultText("Email :"),
//               defaultText(email),
//             ],
//           ),
//           commonDivider(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 child: Text(
//                   "Status: ",
//                   textScaleFactor: 1.0,
//                   style: TextStyle(
//                       fontSize: 12.0.sp,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: AppFonts.ROBOTO),
//                 ),
//               ),
//               Container(
//                 padding:
//                     EdgeInsets.symmetric(horizontal: 1.0.w, vertical: 0.1.h),
//                 decoration: BoxDecoration(
//                     color: AppColors.googleBlue,
//                     borderRadius: BorderRadius.circular(3)),
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.timelapse_outlined,
//                       color: AppColors.white,
//                     ),
//                     Text(
//                       status,
//                       textScaleFactor: 1.0,
//                       style: TextStyle(
//                           color: AppColors.white,
//                           fontSize: 11.0.sp,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: AppFonts.POPPINS),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 1.0.h),
//         ],
//       ),
//     );
//   }

//   Widget commonDivider() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.1.h),
//       child: Divider(
//         thickness: 0.3.w,
//       ),
//     );
//   }

//   Widget titleText(String text) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.0.h),
//       alignment: Alignment.centerLeft,
//       child: Text(
//         text,
//         textScaleFactor: 1.0,
//         style: TextStyle(
//             // color: AppColors.color2C2D30,
//             color: AppColors.color525252,
//             fontSize: 12.0.sp,
//             fontWeight: FontWeight.w700,
//             fontFamily: AppFonts.ROBOTO),
//       ),
//     );
//   }

//   Widget defaultText(String text) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.0.h),
//       alignment: Alignment.centerLeft,
//       child: Text(
//         text,
//         textScaleFactor: 1.0,
//         style: TextStyle(
//             // color: AppColors.color2C2D30,
//             color: AppColors.color525252,
//             fontSize: 11.0.sp,
//             fontWeight: FontWeight.w500,
//             fontFamily: AppFonts.ROBOTO),
//       ),
//     );
//   }
// }
