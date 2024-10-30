import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_session1/e-commerce_application/screens/main_layout/main_layout.dart';
import 'package:we_session1/e-commerce_application/shared/cubit/app_cubit/app_cubit.dart';
import 'package:we_session1/e-commerce_application/shared/network/local/cache_helper/cache_helper.dart';
import 'package:we_session1/e-commerce_application/shared/network/remote/dio_helper/dio_helper.dart';

import 'e-commerce_application/screens/login_screen/login_screen.dart';
import 'e-commerce_application/shared/cubit/auth_cubit/auth_cubit.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.initializeCache();
  await DioHelper.initializeDio();
  String? token = CacheHelper.getStringFromCache("token");
  runApp( MyApp(
    token: token,
  ));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers:[
        BlocProvider(create: (_)=>AppCubit()),
        BlocProvider(create: (_)=>AuthCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: token == null ? const NewLoginScreen() : const MainLayout(),
          routes: {
            '/login': (context) => NewLoginScreen(),
          }
      ),
    );
  }
}
