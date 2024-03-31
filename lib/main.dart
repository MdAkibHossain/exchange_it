import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/features/splash/presentation/view/logo_initialization.dart';
import 'package:flutter_application_1/on_generate_route.dart';
import 'package:sizer/sizer.dart';

import 'core/data/dataproviders/dio_client.dart';
import 'features/home/logic/clusters_bloc/clusters_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appRouter});
  final AppRouter appRouter;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DollarRateBloc>(
          create: (context) => DollarRateBloc(ApiProvider()),
        ),
      ],
      child: Sizer(builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return MaterialApp(
          title: 'Exchange It',
          onGenerateRoute: appRouter.onGeneratedRoute,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: LogoInitialization(),
        );
      }),
    );
  }
}
