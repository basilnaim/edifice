import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "my_theme.dart";
import 'screens/splash.dart';
import 'package:shared_value/shared_value.dart';
import 'helpers/shared_value_helper.dart';
import 'dart:async';
import 'repositories/auth_repository.dart';
import 'app_config.dart';
import 'services/push_notification_service.dart';
import 'package:one_context/one_context.dart';


 main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  fetch_user() async{

    var userByTokenResponse =
    await AuthRepository().getUserByTokenResponse();

    if (userByTokenResponse.result == true) {
      is_logged_in.value  = true;
      user_id.value = userByTokenResponse.id;
      user_name.value = userByTokenResponse.name;
      user_email.value = userByTokenResponse.email;
      user_phone.value = userByTokenResponse.phone;
      avatar_original.value = userByTokenResponse.avatar_original;
      print('tok');
      print(access_token.value);
    }
  }

  access_token.load().whenComplete(() {
    fetch_user();
  });










  /*is_logged_in.load();
  user_id.load();
  avatar_original.load();
  user_name.load();
  user_email.load();
  user_phone.load();*/

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,

  ));




  runApp(
    SharedValue.wrapApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  @override
  void initState() {


    super.initState();
    Future.delayed(Duration(milliseconds: 100), () async {
      PushNotificationService().initialise();
      await Firebase.initializeApp();
    });



  }

  @override
  Widget build(BuildContext context) {



    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      builder: OneContext().builder,
      navigatorKey: OneContext().navigator.key,
      title: AppConfig.app_name,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: MyTheme.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        accentColor: MyTheme.accent_color,
        //canvasColor: MyTheme.accent_color,
        textTheme: TextTheme(
            bodyText1: TextStyle(fontFamily: 'Cairo'),
            bodyText2: TextStyle(fontFamily: 'Cairo',fontSize: 10.0),
          )
        //
        // the below code is getting fonts from http
        /*textTheme: GoogleFonts.sourceSansProTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.sourceSansPro(textStyle: textTheme.bodyText1)??"",
          bodyText2: GoogleFonts.sourceSansPro(
              textStyle: textTheme.bodyText2, fontSize: 12)??"",
        ),*/
      ),
      home: Splash(),
      //home: Main(),
    );
  }
}
