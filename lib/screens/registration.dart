import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../app_config.dart';
import '../my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../custom/input_decorations.dart';
import '../custom/intl_phone_input.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../addon_config.dart';
import '../screens/otp.dart';
import '../screens/login.dart';
import '../custom/toast_component.dart';
import 'package:toast/toast.dart';
import '../repositories/auth_repository.dart';
import '../helpers/shared_value_helper.dart';
import '../helpers/translation.dart';
import '../helpers/home_controller.dart';
import 'package:get/get.dart';
import 'common_webview_screen.dart';
import 'package:gamedif/repositories/change_currency.dart';
import 'dart:convert';


class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String _register_by = "phone"; //phone or email
  String initialCountry = 'US';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'US', dialCode: "+1");

  String _phone = "";
  String verificationId;
  String country_code="";
  final getxc = Get.put(HomeController());
  //controllers
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

  List<String> _listcountry=['US'];

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
    getcountries();
    _register_by=reg_by.value;
   // _register_by="";
  ////  print(_register_by);
   // print('lolo');
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      //setState(() {});
    });
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  List lstcountry = [];
  getcountries() async {
    var responschange =
    await ChangeCurrencyRepository().getChangeCurrResponse();
    Map map = jsonDecode(responschange);
    lstcountry = map["data"];
    print('kok1');
    print(lstcountry);
    for(int i=0;i<lstcountry.length;i++){
      _listcountry.add(lstcountry[i]["code"]);
    }
    print('kok2');
    print(_listcountry);
    setState(() {

    });

  }



  Future<void> verifyPhon(BuildContext cnx, ProgressDialog pr) async {

    var name = _nameController.text.toString().trim();
    var email = _emailController.text.toString().trim();
    var password = _passwordController.text.toString().trim();
    var password_confirm = _passwordConfirmController.text.toString().trim();

    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent =
        (String verId, [int forceCodeResend]) async {

      this.verificationId = verId;

      pr.hide();
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Otp(
          verify_by: _register_by,
          user_id: this.verificationId,
        );
      }));

    };

    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential phoneAuthCredential) {
      print('verified');
      pr.hide();
    };

    final PhoneVerificationFailed verfiFaild = (FirebaseAuthException exc) {
      print('aaaaaaaaaabbb');
      pr.hide();
      // String ss=exc.message.toString();
      if (exc.message.toString().contains('TOO_SHORT')) {
        ToastComponent.showDialog("The phone number you entered is short", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      } else {
        print('bbbb');
        print(exc.message);
        ToastComponent.showDialog(exc.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      }

      // print('${exc.message}');
    };

   // print(this.country_code.replaceAll("+", "00")+this._phone);
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+"+this.country_code+this._phone,
        timeout: const Duration(seconds: 120),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verfiFaild,
        codeSent: smsCodeSent,
        codeAutoRetrievalTimeout: autoRetrieve);
  }

  onPressSignUp(ProgressDialog pr) async {
    var name = _nameController.text.toString().trim();
    var email = _emailController.text.toString().trim().replaceAll(RegExp(r"\s+"), "");
    var password = _passwordController.text.toString().trim();
    var password_confirm = _passwordConfirmController.text.toString().trim();

    if (name == "") {
      pr.hide();
      ToastComponent.showDialog("Enter your name", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (email == "") {
      pr.hide();
      ToastComponent.showDialog("Enter email", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if ( _phone == "") {
      pr.hide();
      ToastComponent.showDialog("Enter phone number", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (password == "") {
      pr.hide();
      ToastComponent.showDialog("Enter password", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (password_confirm == "") {
      pr.hide();
      ToastComponent.showDialog("Confirm your password", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (password.length < 6) {
      pr.hide();
      ToastComponent.showDialog(
          "Password must contain atleast 6 characters", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (password != password_confirm) {
      pr.hide();
      ToastComponent.showDialog("Passwords do not match", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    print(_phone);
    var signupResponse;
    if(_register_by=='phone'){
      signupResponse = await AuthRepository().getSignupstep1Response(
          name,
          _phone,
          country_code,
          email,
          password,
          password_confirm,
          _register_by);
    }else{
      //
      signupResponse = await AuthRepository().getSignupResponse(
          name,
          _phone,
          country_code,
          email,
          password,
          password_confirm,
          _register_by);
    }

   // print('www');
    if (signupResponse.result == false ) {
      pr.hide();
      print('f');
      ToastComponent.showDialog(signupResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(signupResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      if(_register_by=='phone'){
        verifyPhon(context,pr);
      }else{
        pr.hide();
        if(_register_by=='email'){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Otp(
              verify_by: _register_by,
              user_id: signupResponse.user_id.toString(),
            );
          }));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Login();
          }));
        }
      }
    }
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
          Container(
            width: _screen_width * (3 / 4),
            child: Image.asset(
                "assets/reg.png"),
          ),
          Container(
            width: double.infinity,
            child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 10),
                      child: Container(
                        width: 75,
                        height: 75,
                        child:
                        Image.asset('assets/app_logo.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        AppTranslation.translationsKeys[langu_choos.value]['Join'] + AppConfig.app_name,
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      width: _screen_width * (3 / 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              AppTranslation.translationsKeys[langu_choos.value]['name'],
                              style: TextStyle(
                                  color: MyTheme.accent_color,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              height: 36,
                              child: TextField(
                                controller: _nameController,
                                autofocus: false,
                                decoration: InputDecorations.buildInputDecoration_1(
                                    hint_text: AppTranslation.translationsKeys[langu_choos.value]['Full Name']),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              AppTranslation.translationsKeys[langu_choos.value]['phone'],
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
                                  child: CustomInternationalPhoneNumberInput(
                                    countries:_listcountry,
                                    onInputChanged: (PhoneNumber number) {
                                      //print(number.phoneNumber);
                                      // print(number.dialCode);
                                      // print(number.isoCode);
                                      setState(() {
                                        _phone = number.phoneNumber.replaceAll(number.dialCode, "");
                                        country_code=number.dialCode.replaceAll("+", "");
                                      });
                                      print(_phone);
                                    },
                                    onInputValidated: (bool value) {
                                      print('g');
                                      print(country_code);
                                    },

                                    selectorConfig: SelectorConfig(
                                      selectorType: PhoneInputSelectorType.DIALOG,

                                    ),
                                    ignoreBlank: false,
                                    autoValidateMode: AutovalidateMode.disabled,
                                    selectorTextStyle:
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
                                      // print('On Saved: $number');
                                    },
                                  ),
                                ),
                                /*GestureDetector(
                              onTap: () {
                                setState(() {
                                  _register_by = "email";
                                });
                              },
                              child: Text(
                                "or, Register with an email",
                                style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline),
                              ),
                            )*/
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              AppTranslation.translationsKeys[langu_choos.value]['email'],
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
                                      _register_by = "phone";
                                    });
                                  },
                                  child: Text(
                                    "or, Register with a phone number",
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
                                Text(
                                  AppTranslation.translationsKeys[langu_choos.value]['Password must be at least 6 character'],
                                  style: TextStyle(
                                      color: MyTheme.textfield_grey,
                                      fontStyle: FontStyle.italic),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              AppTranslation.translationsKeys[langu_choos.value]['retype password'],
                              style: TextStyle(
                                  color: MyTheme.accent_color,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              height: 36,
                              child: TextField(
                                controller: _passwordConfirmController,
                                autofocus: false,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration: InputDecorations.buildInputDecoration_1(
                                    hint_text: "• • • • • • • •"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
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
                                onPressed: () async {
                                  if(_register_by=='phone'){
                                    onregbyphon();
                                  }else{
                                    ProgressDialog pr = ProgressDialog(context);
                                    pr = ProgressDialog(context,
                                        type: ProgressDialogType.Normal, isDismissible: false);
                                    await pr.show();
                                    pr.update(progress: 50, message: 'الرجاء الانتظار');
                                    onPressSignUp(pr);
                                  }
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0,left: 20,right: 20),
                            child: new Center(
                              child: new RichText(
                                text: new TextSpan(
                                  children: [
                                    new TextSpan(
                                      text: AppTranslation.translationsKeys[langu_choos.value]['Your joining means that you agree to all of the']+' ',
                                      style: new TextStyle(color: Colors.black),
                                    ),
                                    new TextSpan(
                                      text: AppTranslation.translationsKeys[langu_choos.value]['Terms and Conditions']+' ',
                                      style: new TextStyle(color: Colors.blue),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) {
                                                return CommonWebviewScreen(
                                                  url:
                                                  "${AppConfig.RAW_BASE_URL}/Term-Conditions",
                                                  page_name:AppTranslation.translationsKeys[langu_choos.value]['Terms and Conditions'],
                                                );
                                              }));
                                        },
                                    ),
                                    new TextSpan(
                                      text: AppTranslation.translationsKeys[langu_choos.value]['and']+' ',
                                      style: new TextStyle(color: Colors.black),
                                    ),
                                    new TextSpan(
                                      text: AppTranslation.translationsKeys[langu_choos.value]['Privacy Policy'],
                                      style: new TextStyle(color: Colors.blue),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) {
                                                return CommonWebviewScreen(
                                                  url:
                                                  "${AppConfig.RAW_BASE_URL}/privacypolicy",
                                                  page_name:AppTranslation.translationsKeys[langu_choos.value]['Privacy Policy'],
                                                );
                                              }));
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Center(
                                child: Text(
                                  AppTranslation.translationsKeys[langu_choos.value]['Already have an Account ?'],
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
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return Login();
                                      }));
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }

  onregbyphon() {
    String ms="للتأكد عبر رقم الهاتف"+"\n"+"سيتم نقلك إلى المتصفح بشكل آلي لاختيار مجموعه عشوائية من الصور"+"\n"+
        "لللتاكد انك لست روبوت"+"\n"+"("+"reCAPTCHA"+")"+"؟";
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          contentPadding: EdgeInsets.only(
              top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
          content: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              ms,
              maxLines: 6,
              style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
            ),
          ),
          actions: [
            FlatButton(
              child: Text(
                AppTranslation.translationsKeys[langu_choos.value]
                ['Cancel'],
                style: TextStyle(color: MyTheme.medium_grey),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            FlatButton(
              color: MyTheme.accent_color,
              child: Text(
                AppTranslation.translationsKeys[langu_choos.value]
                ['Confirm'],
                style: TextStyle(color: MyTheme.dark_grey),
              ),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                ProgressDialog pr = ProgressDialog(context);
                pr = ProgressDialog(context,
                    type: ProgressDialogType.Normal, isDismissible: false);
                await pr.show();
                pr.update(progress: 50, message: 'الرجاء الانتظار');
                onPressSignUp(pr);
              },
            ),
          ],
        ));
  }
}
