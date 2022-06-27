import 'package:flutter/material.dart';
import '../my_theme.dart';
import '../screens/stripe_screen.dart';
import '../screens/paypal_screen.dart';
import '../screens/razorpay_screen.dart';
import '../screens/paystack_screen.dart';
import '../screens/iyzico_screen.dart';
import '../screens/bkash_screen.dart';
import '../screens/nagad_screen.dart';
import '../screens/sslcommerz_screen.dart';
import '../screens/bankpay_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../repositories/payment_repository.dart';
import '../helpers/shimmer_helper.dart';
import '../custom/toast_component.dart';
import 'package:toast/toast.dart';
import '../app_config.dart';
import '../helpers/home_controller.dart';
import 'package:get/get.dart';
import '../helpers/translation.dart';
import '../helpers/shared_value_helper.dart';
import '../custom/input_decorations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:convert';
import '../repositories/bankpay_repositories.dart';

class RechargeWallet extends StatefulWidget {
  double amount;

  RechargeWallet({Key key, this.amount}) : super(key: key);

  @override
  _RechargeWalletState createState() => _RechargeWalletState();
}

class _RechargeWalletState extends State<RechargeWallet> {
  var _selected_payment_method = "";
  var _selected_payment_method_key = "";
  var _screen_width;

  ScrollController _mainScrollController = ScrollController();
  var _paymentTypeList = [];
  var _paymentTypeListfilter = [];
  bool _isInitial = true;
  final getxc = Get.put(HomeController());

  TextEditingController _nameController = TextEditingController();
  TextEditingController _accController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*print("user data");
    print(is_logged_in.value);
    print(access_token.value);
    print(user_id.value);
    print(user_name.value);*/

    fetchAll();
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  fetchAll() {
    fetchList();
  }

  fetchList() async {
    var paymentTypeResponseList =
        await PaymentRepository().getPaymentResponseList();
    _paymentTypeListfilter.addAll(paymentTypeResponseList);
    for(int i=0;i<_paymentTypeListfilter.length;i++){
      if(_paymentTypeListfilter[i].payment_type!="wallet_system") {
        _paymentTypeList.add(_paymentTypeListfilter[i]);
      }
    }

    if (_paymentTypeList.length > 0) {
      _selected_payment_method = _paymentTypeList[0].payment_type;
      _selected_payment_method_key = _paymentTypeList[0].payment_type_key;
      print(_selected_payment_method_key);
      print('koko');
      print(_paymentTypeList[0].image);
    }
    if (_selected_payment_method == 'check_payment') {
      _selectedindex = 0;
      handerstring(_paymentTypeList[_selectedindex].description.toString());
    }

    _isInitial = false;
    setState(() {});
  }

  reset() {
    _paymentTypeList.clear();
    _isInitial = true;
    _selected_payment_method = "";
    _selected_payment_method_key = "";
    _file = null;
    _nameController.clear();
    _accController.clear();
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAll();
  }

  onPressRechargeWallet() async {
    print("grant total value");
    print(widget.amount);
    print(_selected_payment_method);

    if (_selected_payment_method == "") {
      ToastComponent.showDialog("Please choose one option to pay", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_selected_payment_method == "check_payment") {
      String  name = _nameController.text.toString();

      if (name == "") {
        ToastComponent.showDialog(AppTranslation.translationsKeys[langu_choos.value]['Enter name'], context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      if (_file == null) {
        ToastComponent.showDialog(AppTranslation.translationsKeys[langu_choos.value]['No Image Choosen'], context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      if (widget.amount == 0.00) {
        ToastComponent.showDialog("Nothing to pay", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      String base64Image = base64Encode(_file.readAsBytesSync());
      print(base64Image);
      var BankpayResponse = await BankPayRepository().getBankPayResponse(
        widget.amount,
        bankname,
        name,
        _selected_payment_method,
        "000",
        base64Image,
      );
      print(BankpayResponse);
      if (BankpayResponse.result == false) {
        print('f');
        print(BankpayResponse.message);
        ToastComponent.showDialog(BankpayResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      } else {
        reset();
        print('t');
        print(BankpayResponse.message);
        ToastComponent.showDialog(BankpayResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        Navigator.of(context).pop();
        //setState(() {});
      }
      /* Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BankPayScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));*/
    } else if (_selected_payment_method == "stripe_payment") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog("Nothing to pay", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return StripeScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    } else if (_selected_payment_method == "paypal_payment") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog("Nothing to pay", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PaypalScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    } else if (_selected_payment_method == "razorpay") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog("Nothing to pay", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return RazorpayScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    } else if (_selected_payment_method == "paystack") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog("Nothing to pay", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PaystackScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    } else if (_selected_payment_method == "iyzico") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog("Nothing to pay", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return IyzicoScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    } else if (_selected_payment_method == "bkash") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog("Nothing to pay", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BkashScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    } else if (_selected_payment_method == "nagad") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog("Nothing to pay", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return NagadScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    } else if (_selected_payment_method == "sslcommerz_payment") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog("Nothing to pay", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SslCommerzScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    }
  }

  handerstring(String s) {
    s = s.replaceAll("&nbsp;", "\n");
    s = s.replaceAll("<br></b><br>", "\n");
    s = s.replaceAll("<br>", "\n");
    s = s.replaceAll("<br><br>", "\n");
    s = s.replaceAll("<b>", "");
    s = s.replaceAll("<p>", "");
    s = s.replaceAll("&nbsp;", "");
    s = s.replaceAll("<span style=\"font-weight: bolder;\">", "");
    s = s.replaceAll("</span>", "");
    s = s.replaceAll("</p", "");
    s = s.replaceAll(">", "");
    desc = s;
  }

  int _selectedindex;
  String desc = '';
  String bankname='';
  onPaymentMethodItemTap(index) {
    if (_selected_payment_method_key !=
        _paymentTypeList[index].payment_type_key) {
      setState(() {
        _selectedindex = index;
        handerstring(_paymentTypeList[_selectedindex].description.toString());
        bankname=_paymentTypeList[index].name;
        _selected_payment_method = _paymentTypeList[index].payment_type;
        _selected_payment_method_key = _paymentTypeList[index].payment_type_key;
      });
    }

    //print(_selected_payment_method);
    //print(_selected_payment_method_key);
  }

  File _file;
  chooseAndUploadImage(context) async {
    var status = await Permission.photos.request();

    if (status.isDenied) {
      // We didn't ask for permission yet.
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text('Photo Permission'),
                content: Text(
                    'This app needs photo to take pictures for upload Bank transfer photo'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Deny'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text('Settings'),
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ));
    } else if (status.isRestricted) {
      ToastComponent.showDialog(
          "Go to your application settings and give photo permission ", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else if (status.isGranted) {
      //file = await ImagePicker.pickImage(source: ImageSource.camera);
      _file = await ImagePicker.pickImage(source: ImageSource.gallery);

      if (_file == null) {
        ToastComponent.showDialog("No file is chosen", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      //return;
      String base64Image = base64Encode(_file.readAsBytesSync());
      String fileName = _file.path.split("/").last;
      setState(() {});
      /*var profileImageUpdateResponse =
          await ProfileRepository().getProfileImageUpdateResponse(
        base64Image,
        fileName,
      );

      if (profileImageUpdateResponse.result == false) {
        ToastComponent.showDialog(profileImageUpdateResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      } else {
        ToastComponent.showDialog(profileImageUpdateResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

        avatar_original.value = profileImageUpdateResponse.path;
        setState(() {});
      }*/
    }
  }

  @override
  Widget build(BuildContext context) {
    _screen_width = MediaQuery.of(context).size.width;
    return GetBuilder<HomeController>(
      builder: (_) => getxc.lang == 'ar'
          ? Directionality(
              textDirection: TextDirection.rtl,
              child: scaffold(),
            )
          : Directionality(
              textDirection: TextDirection.ltr,
              child: scaffold(),
            ),
    );
  }

  scaffold() {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        bottomNavigationBar: buildBottomAppBar(context),
        body: Stack(
          children: [
            RefreshIndicator(
              color: MyTheme.accent_color,
              backgroundColor: Colors.white,
              onRefresh: _onRefresh,
              displacement: 0,
              child: CustomScrollView(
                controller: _mainScrollController,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: buildPaymentMethodList(),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        AppTranslation.translationsKeys[langu_choos.value]['Recharge Wallet'],
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildPaymentMethodList() {
    if (_isInitial && _paymentTypeList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_paymentTypeList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _paymentTypeList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.only(bottom: 1.0),
                child: Column(
                  children: [
                    buildPaymentMethodItemCard(index),
                    build_bankfield(index, _paymentTypeList.length)
                  ],
                ));
          },
        ),
      );
    } else if (!_isInitial && _paymentTypeList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            "No payment method is added",
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  build_bankfield(int i, int l) {

    if (i == l - 1) {
      if (_selected_payment_method == 'check_payment') {

        return Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: MyTheme.soft_accent_color, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 1,
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: _screen_width * (3 / 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: Text(
                            desc ?? "",
                            style: TextStyle(
                                color: MyTheme.dark_grey,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        _paymentTypeList[_selectedindex]
                            .bank_info!=[]?
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            AppTranslation.translationsKeys[langu_choos.value]
                                ['name'],
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontWeight: FontWeight.w600),
                          ),
                        ):Container(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            height: 36,
                            child: TextField(
                              controller: _nameController,
                              autofocus: false,
                              decoration:
                                  InputDecorations.buildInputDecoration_1(
                                      hint_text:
                                          AppTranslation.translationsKeys[
                                              langu_choos.value]['name']),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            AppTranslation.translationsKeys[langu_choos.value]
                                ['Account Number'],
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
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: true),
                              controller: _accController,
                              autofocus: false,
                              decoration:
                                  InputDecorations.buildInputDecoration_1(
                                      hint_text: AppTranslation
                                              .translationsKeys[
                                          langu_choos.value]['Account Number']),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlatButton(
                                  color: MyTheme.shimmer_base,
                                  onPressed: () {
                                    chooseAndUploadImage(context);
                                  },
                                  child: Text(AppTranslation
                                          .translationsKeys[langu_choos.value]
                                      ['Press to Choose Image']),
                                ),
                                Container(
                                    child: _file != null
                                        ? Container(
                                            height: 100,
                                            width: 100,
                                            child: Image.file(_file))
                                        : Text(AppTranslation.translationsKeys[
                                                langu_choos.value]
                                            ['No Image Choosen']))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  GestureDetector buildPaymentMethodItemCard(index) {
    return GestureDetector(
      onTap: () {
        onPaymentMethodItemTap(index);
      },
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              side: _selected_payment_method_key ==
                      _paymentTypeList[index].payment_type_key
                  ? BorderSide(color: MyTheme.accent_color, width: 2.0)
                  : BorderSide(color: MyTheme.light_grey, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 0.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: 100,
                      height: 70,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:
                              /*Image.asset(
                          _paymentTypeList[index].image,
                          fit: BoxFit.fitWidth,
                        ),*/
                              FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder.png',
                            image: AppConfig.BASE_PATH +
                                _paymentTypeList[index].image,
                            fit: BoxFit.fill,
                          ))),
                  Container(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            _paymentTypeList[index].title,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: buildPaymentMethodCheckContainer(
                _selected_payment_method_key ==
                    _paymentTypeList[index].payment_type_key),
          )
        ],
      ),
    );
  }

  Container buildPaymentMethodCheckContainer(bool check) {
    return check
        ? Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), color: Colors.green),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Icon(FontAwesome.check, color: Colors.white, size: 10),
            ),
          )
        : Container();
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        color: Colors.transparent,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton(
              minWidth: MediaQuery.of(context).size.width,
              height: 50,
              color: MyTheme.accent_color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Text(
                AppTranslation.translationsKeys[langu_choos.value]
                    ['Recharge Wallet'],
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                onPressRechargeWallet();
              },
            )
          ],
        ),
      ),
    );
  }
}
