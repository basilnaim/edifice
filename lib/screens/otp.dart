import '../my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../custom/input_decorations.dart';
import '../screens/login.dart';
import '../repositories/auth_repository.dart';
import '../custom/toast_component.dart';
import 'package:toast/toast.dart';
import '../helpers/translation.dart';
import '../helpers/shared_value_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Otp extends StatefulWidget {
  Otp({Key key,
    this.verify_by = "email",
    this.user_id,
    this.name,
    this.phone,
    this.country_code,
    this.email,
    this.password}) : super(key: key);
  final String verify_by;
  final String user_id;
  final String name;
  final String phone;
  final String country_code;
  final String email;
  final String password;

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  //controllers
  TextEditingController _verificationCodeController = TextEditingController();

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

  onTapResend() async {
    var resendCodeResponse = await AuthRepository()
        .getResendCodeResponse(widget.user_id,widget.verify_by);

    if (resendCodeResponse.result == false) {
      ToastComponent.showDialog(resendCodeResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(resendCodeResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

    }

  }


  Future<bool> signIn(ProgressDialog pr) async {
  //  FirebaseAuth _auth = FirebaseAuth.instance;
    var smsCode = _verificationCodeController.text.toString();
    final AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: widget.user_id,
        smsCode: smsCode
    );
    // UserCredential result =
    // await _auth.signInWithCredential(authCredential);
    /*AuthCredential credential= PhoneAuthProvider.getCredential(
        verificationId: widget.user_id,
        smsCode: smsCode
    );*/
    await FirebaseAuth.instance.signInWithCredential(authCredential).then((user) async {
      print('signed in with phone number successful: user -> $user');
      var signupResponse = await AuthRepository().getSignupResponse(
          widget.name,
          widget.phone,
          widget.country_code,
          widget.email,
          widget.password,
          widget.password,
          "phone");
      if (signupResponse.result == false ) {
        print('f2');
        pr.hide();
        ToastComponent.showDialog(signupResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      } else {
        pr.hide();
        ToastComponent.showDialog(signupResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Login();
        }));

      }
    }).catchError((e){
      print('+'+e.toString());
      pr.hide();
      ToastComponent.showDialog(e.toString(), context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    });
  }

  onPressConfirm() async {
    var code = _verificationCodeController.text.toString();
    ProgressDialog pr = ProgressDialog(context);
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    await pr.show();
    if(code == ""){
      pr.hide();
      ToastComponent.showDialog("Enter verification code", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if(widget.verify_by=='email'){
      var confirmCodeResponse = await AuthRepository()
          .getConfirmCodeResponse(widget.user_id,code);

      if (confirmCodeResponse.result == false) {
        pr.hide();
        ToastComponent.showDialog(confirmCodeResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      } else {
        pr.hide();
        ToastComponent.showDialog(confirmCodeResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Login();
        }));

      }
    }else{
          signIn(pr);
    }

  }

  @override
  Widget build(BuildContext context) {
    String _verify_by = widget.verify_by; //phone or email
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
       // alignment: Alignment.center,
        children: [
          Container(

            //  width: _screen_width * (3 / 4),
            child: Image.asset(
                "assets/splash_login_registration_background_image.png"),
          ),
          Container(
            width: double.infinity,
            child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /*Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 15),
                  child: Container(
                    width: 75,
                    height: 75,
                    child:
                        Image.asset('assets/app_logo.png'),
                  ),
                ),*/
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0,top:20),
                      child: Text(
                        "Verify your " +
                            (_verify_by == "email"
                                ? "Email Account"
                                : "Phone Number"),
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                          width: _screen_width * (3 / 4),
                          child: _verify_by == "email"
                              ? Text(
                              AppTranslation.translationsKeys[langu_choos.value]
                              ['Enter the verification code that sent to your email recently'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: MyTheme.dark_grey, fontSize: 14))
                              : Text(
                              AppTranslation.translationsKeys[langu_choos.value]
                              ['Enter the verification code that sent to your phone recently']
                              ,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: MyTheme.dark_grey, fontSize: 14))),
                    ),
                    Container(
                      width: _screen_width * (3 / 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: 36,
                                  child: TextField(
                                    controller: _verificationCodeController,
                                    autofocus: false,
                                    decoration:
                                    InputDecorations.buildInputDecoration_1(
                                        hint_text: "A X B 4 J H"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
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
                                  AppTranslation.translationsKeys[langu_choos.value]
                                  ['Confirm'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  onPressConfirm();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: InkWell(
                        onTap: (){
                          onTapResend();
                        },
                        child: Text(
                            AppTranslation.translationsKeys[langu_choos.value]
                            ['Resend Code'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                decoration: TextDecoration.underline,
                                fontSize: 13)),
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
