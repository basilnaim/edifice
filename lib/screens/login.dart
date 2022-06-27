import '../app_config.dart';
import '../social_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../custom/input_decorations.dart';
import '../custom/intl_phone_input.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../addon_config.dart';
import '../screens/registration.dart';
import '../screens/main.dart';
import '../screens/password_forget.dart';
import '../custom/toast_component.dart';
import 'package:toast/toast.dart';
import '../repositories/auth_repository.dart';
import '../helpers/auth_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import '../helpers/shared_value_helper.dart';
import '../repositories/profile_repositories.dart';
import '../helpers/translation.dart';
import '../helpers/home_controller.dart';
import 'package:get/get.dart';
import '../my_theme.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _login_by = "email"; //phone or email
  String initialCountry = 'US';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'US', dialCode: "+1");
  String _phone = "";
  final getxc = Get.put(HomeController());
  //controllers
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }


  onPressedLogin() async {
    var email = _emailController.text.toString();
    var password = _passwordController.text.toString();

    if (_login_by == 'email' && email == "") {
      ToastComponent.showDialog("Enter email", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (_login_by == 'phone' && _phone == "") {
      ToastComponent.showDialog("Enter phone number", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (password == "") {
      ToastComponent.showDialog("Enter password", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    var loginResponse = await AuthRepository()
        .getLoginResponse(_login_by == 'email' ? email : _phone, password);

    if (loginResponse.result == false) {
      print('ff');
      ToastComponent.showDialog(loginResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      print('kook');
      print(loginResponse.user.currency_code);
      if(loginResponse.user.currency_code != null) {
        curr.value = loginResponse.user.currency_code;
      }
     // print(loginResponse.toString());
      ToastComponent.showDialog(loginResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
     await AuthHelper().setUserData(loginResponse);
      print('tt');
      // push notification starts
      final FirebaseMessaging _fcm = FirebaseMessaging();
      if (Platform.isIOS) {
        _fcm.requestNotificationPermissions(IosNotificationSettings());
      }
      String fcmToken = await _fcm.getToken();

      if (fcmToken != null) {
        print("--fcm token--login");
        print(fcmToken);

        if (is_logged_in.value == true) {
          print('amr');
          // update device token
          var deviceTokenUpdateResponse =
          await ProfileRepository().getDeviceTokenUpdateResponse(fcmToken);

        }
      }
      //push norification ends

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    }
  }

  onPressedFacebookLogin() async {
    final facebookLogin = FacebookLogin();
    final facebookLoginResult = await facebookLogin.logIn(['email']);

    /*print(facebookLoginResult.accessToken);
    print(facebookLoginResult.accessToken.token);
    print(facebookLoginResult.accessToken.expires);
    print(facebookLoginResult.accessToken.permissions);
    print(facebookLoginResult.accessToken.userId);
    print(facebookLoginResult.accessToken.isValid());

    print(facebookLoginResult.errorMessage);
    print(facebookLoginResult.status);*/

    final token = facebookLoginResult.accessToken.token;

    /// for profile details also use the below code
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token',headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer ${access_token.value}"
    });
    final profile = json.decode(graphResponse.body);
    //print(profile);
    /*from profile you will get the below params
    {
     "name": "Iiro Krankka",
     "first_name": "Iiro",
     "last_name": "Krankka",
     "email": "iiro.krankka\u0040gmail.com",
     "id": "<user id here>"
    }*/

    var loginResponse = await AuthRepository().getSocialLoginResponse(
        profile['name'], profile['email'], profile['id'].toString());

    if (loginResponse.result == false) {
      ToastComponent.showDialog(loginResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(loginResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      AuthHelper().setUserData(loginResponse);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    }
  }

  onPressedGoogleLogin() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        // you can add extras if you require
      ],
    );

    _googleSignIn.signIn().then((GoogleSignInAccount acc) async {
      GoogleSignInAuthentication auth = await acc.authentication;
      print(acc.id);
      print(acc.email);
      print(acc.displayName);
      print(acc.photoUrl);

      acc.authentication.then((GoogleSignInAuthentication auth) async {
        print(auth.idToken);
        print(auth.accessToken);

        //---------------------------------------------------
        var loginResponse = await AuthRepository().getSocialLoginResponse(
            acc.displayName, acc.email, auth.accessToken);

        if (loginResponse.result == false) {
          ToastComponent.showDialog(loginResponse.message, context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        } else {
          ToastComponent.showDialog(loginResponse.message, context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          AuthHelper().setUserData(loginResponse);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Main();
          }));
        }

        //-----------------------------------
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    return GetBuilder<HomeController>(
      builder: (_) => getxc.lang == 'ar'
          ? Directionality(
        textDirection: TextDirection.rtl,
        child: scaffold(context),
      )
          : Directionality(
        textDirection: TextDirection.ltr,
        child: scaffold(context),
      ),
    );
  }

  scaffold(BuildContext context){
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /*Positioned(
            top: 400,
            child: Container(
              width: _screen_width * (3 / 4),
              child: Image.asset(
                  "assets/reg.png"),
            ),
          ),*/
          Container(
            width: double.infinity,
            child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 15),
                      child: Container(
                        width: 200,
                        height: 150,
                        child:
                        Image.asset('assets/app_logo.png'),
                      ),
                    ),
                    /*Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        AppTranslation.translationsKeys[langu_choos.value]['Login to']+' '+ AppConfig.app_name,
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),*/
                    Container(
                      width: _screen_width * (3 / 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              _login_by == "email"
                                  ?  AppTranslation.translationsKeys[langu_choos.value]['email']
                                  :  AppTranslation.translationsKeys[langu_choos.value]['phone'],
                              style: TextStyle(
                                  color: MyTheme.accent_color,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          if (_login_by == "email")
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 36,
                                    child: TextField(
                                      controller: _emailController,
                                      autofocus: false,
                                      decoration:
                                      InputDecorations.buildInputDecoration_1(
                                          hint_text: "customer@example.com"),
                                    ),
                                  ),
                                  AddonConfig.otp_addon_installed
                                      ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _login_by = "phone";
                                      });
                                    },
                                    child: Text(
                                      "or, Login with a phone number",
                                      style: TextStyle(
                                          color: MyTheme.accent_color,
                                          fontStyle: FontStyle.italic,
                                          decoration:
                                          TextDecoration.underline),
                                    ),
                                  )
                                      : Container()
                                ],
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 36,
                                    child: CustomInternationalPhoneNumberInput(
                                      onInputChanged: (PhoneNumber number) {
                                        print(number.phoneNumber);
                                        setState(() {
                                          _phone = number.phoneNumber;
                                        });
                                      },
                                      onInputValidated: (bool value) {
                                        print(value);
                                      },
                                      selectorConfig: SelectorConfig(
                                        selectorType: PhoneInputSelectorType.DIALOG,
                                      ),
                                      ignoreBlank: false,
                                      autoValidateMode: AutovalidateMode.disabled,
                                      selectorTextStyle:
                                      TextStyle(color: MyTheme.font_grey),
                                      textStyle:
                                      TextStyle(color: MyTheme.font_grey),
                                      initialValue: phoneCode,
                                      textFieldController: _phoneNumberController,
                                      formatInput: true,
                                      keyboardType: TextInputType.numberWithOptions(
                                          signed: true, decimal: true),
                                      inputDecoration: InputDecorations
                                          .buildInputDecoration_phone(
                                          hint_text: "01710 333 558"),
                                      onSaved: (PhoneNumber number) {
                                        print('On Saved: $number');
                                      },
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _login_by = "email";
                                      });
                                    },
                                    child: Text(
                                      "or, Login with an email",
                                      style: TextStyle(
                                          color: MyTheme.accent_color,
                                          fontStyle: FontStyle.italic,
                                          decoration: TextDecoration.underline),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              AppTranslation.translationsKeys[langu_choos.value]['password'],
                              style: TextStyle(
                                  color: MyTheme.accent_color,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: 36,
                                  child: TextField(
                                    controller: _passwordController,
                                    autofocus: false,
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    decoration:
                                    InputDecorations.buildInputDecoration_1(
                                        hint_text: "• • • • • • • •"),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return PasswordForget();
                                        }));
                                  },
                                  child: Text(
                                    AppTranslation.translationsKeys[langu_choos.value]['forgot password?'],
                                    style: TextStyle(
                                        color: MyTheme.accent_color,
                                        fontStyle: FontStyle.italic,
                                        decoration: TextDecoration.underline),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: MyTheme.textfield_grey, width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              child: FlatButton(
                                minWidth: MediaQuery.of(context).size.width,
                                //height: 50,
                                color: MyTheme.golden,
                                shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12.0))),
                                child: Text(
                                  AppTranslation.translationsKeys[langu_choos.value]['log in'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  print('www');
                                  onPressedLogin();
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Center(
                                child: Text(
                                  AppTranslation.translationsKeys[langu_choos.value]['or, create a new account ?'],
                                  style: TextStyle(
                                      color: MyTheme.medium_grey, fontSize: 12),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: MyTheme.textfield_grey, width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              child: FlatButton(
                                minWidth: MediaQuery.of(context).size.width,
                                //height: 50,
                                color: MyTheme.accent_color,
                                shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12.0))),
                                child: Text(
                                  AppTranslation.translationsKeys[langu_choos.value]['sign up'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return Registration();
                                      }));
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: SocialConfig.allow_google_login || SocialConfig.allow_facebook_login,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Center(
                                  child: Text(
                                    "Login with",
                                    style: TextStyle(
                                        color: MyTheme.medium_grey, fontSize: 14),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Center(
                              child: Container(
                                width: 120,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Visibility(
                                      visible: SocialConfig.allow_google_login,
                                      child: InkWell(
                                        onTap: () {
                                          onPressedGoogleLogin();
                                        },
                                        child: Container(
                                          width: 28,
                                          child:
                                          Image.asset("assets/google_logo.png"),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: SocialConfig.allow_facebook_login,
                                      child: InkWell(
                                        onTap: () {
                                          onPressedFacebookLogin();
                                        },
                                        child: Container(
                                          width: 28,
                                          child:
                                          Image.asset("assets/facebook_logo.png"),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: false,
                                      child: InkWell(
                                        onTap: () {
                                          // onPressedTwitterLogin();
                                        },
                                        child: Container(
                                          width: 28,
                                          child:
                                          Image.asset("assets/twitter_logo.png"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: _screen_width * (3 / 5),
                          child: Image.asset(
                              "assets/reg.png"),
                        ))
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
