import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/presentation/view/home_screen.dart';
import 'package:flutter_application_1/features/splash/presentation/view/splash_screen.dart';
import 'package:flutter_application_1/route_name.dart';
import 'package:page_transition/page_transition.dart';

import 'core/model/page_arguments_model.dart';
import 'features/confirm_order/presentation/view/confirm_order_screen.dart';
import 'features/confirm_transaction/presentation/view/confirm_transaction_screen.dart';
import 'features/details_input/presentation/view/details_input_screen.dart';
import 'features/history/presentation/view/my_history.dart';

class AppRouter {
  Route? onGeneratedRoute(RouteSettings? route) {
    switch (route!.name) {
      case RouteName.root:
        var arg = route.arguments as PageRouteArguments;
        return PageTransition(
          child: HomeScreen(
            arguments: arg,
          ),
          type: PageTransitionType.fade,
        );
      case RouteName.home:
        var arg = route.arguments as PageRouteArguments;
        return PageTransition(
          child: HomeScreen(
            arguments: arg,
          ),
          type: PageTransitionType.fade,
        );

      case RouteName.splashScreen:
        var arg = route.arguments as PageRouteArguments;
        return PageTransition(
          child: SplashScreen(
            arguments: arg,
          ),
          type: PageTransitionType.fade,
        );
      case RouteName.detailsInputScreen:
        var arg = route.arguments as PageRouteArguments;
        return PageTransition(
          child: DetailsInputScreen(
            arguments: arg,
          ),
          type: PageTransitionType.fade,
        );
      case RouteName.confirmOrderScreen:
        var arg = route.arguments as PageRouteArguments;
        return PageTransition(
          child: ConfirmOrderScreen(
            arguments: arg,
          ),
          type: PageTransitionType.fade,
        );
      case RouteName.confirmTransactionScreen:
        var arg = route.arguments as PageRouteArguments;
        return PageTransition(
          child: ConfirmTransactionScreen(arguments: arg),
          type: PageTransitionType.fade,
        );
      case RouteName.myHistoryScreen:
        //var arg = route.arguments as PageRouteArguments;
        return PageTransition(
          child: const MyHistoryScreen(),
          type: PageTransitionType.fade,
        );

      default:
        return _errorRoute();
    }
  }

  // AppRouter._(); CheckOutScreen
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("ERROR"),
          centerTitle: true,
        ),
        body: const Center(
          child: Text("Page not found!"),
        ),
      ),
    );
  }
}
