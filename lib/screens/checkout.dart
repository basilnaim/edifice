import 'package:flutter/material.dart';
import '../my_theme.dart';
import '../screens/order_list.dart';
import '../screens/stripe_screen.dart';
import '../screens/paypal_screen.dart';
import '../screens/razorpay_screen.dart';
import '../screens/paystack_screen.dart';
import '../screens/iyzico_screen.dart';
import '../screens/bkash_screen.dart';
import '../screens/nagad_screen.dart';
import '../screens/sslcommerz_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../helpers/shared_value_helper.dart';
import '../repositories/payment_repository.dart';
import '../repositories/cart_repository.dart';
import '../repositories/coupon_repository.dart';
import '../helpers/shimmer_helper.dart';
import '../custom/toast_component.dart';
import 'package:toast/toast.dart';
import '../helpers/translation.dart';
import '../helpers/home_controller.dart';
import 'package:get/get.dart';
import '../custom/input_decorations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:convert';
import '../app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Checkout extends StatefulWidget {
  int owner_id;

  Checkout({Key key, this.owner_id}) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  var _selected_payment_method = "";
  var _selected_payment_method_key = "";
  var _screen_width;

  ScrollController _mainScrollController = ScrollController();
  TextEditingController _couponController = TextEditingController();
  var _paymentTypeList = [];
  bool _isInitial = true;
  var _totalString = ". . .";
  var _grandTotalValue = 0.00;
  var _subTotalString = ". . .";
  var _taxString = ". . .";
  var _shippingCostString = ". . .";
  var _discountString = ". . .";
  var _used_coupon_code = "";
  var _coupon_applied = false;
  String acc = '';

  final getxc = Get.put(HomeController());

  TextEditingController _nameController = TextEditingController();
  TextEditingController _accController = TextEditingController();
  ScrollController _scrollController = new ScrollController();

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
    if (is_logged_in.value == true) {
      fetchSummary();
    }
  }

  fetchList() async {
    var paymentTypeResponseList =
        await PaymentRepository().getPaymentResponseList();
    _paymentTypeList.addAll(paymentTypeResponseList);
    if (_paymentTypeList.length > 0) {
      _selected_payment_method = _paymentTypeList[0].payment_type;
      _selected_payment_method_key = _paymentTypeList[0].payment_type_key;
    }
    _isInitial = false;
    setState(() {});
  }

  fetchSummary() async {

    var cartSummaryResponse =
        await CartRepository().getCartSummaryResponse(widget.owner_id);

    if (cartSummaryResponse != null) {
      _subTotalString = cartSummaryResponse.sub_total;
      _taxString = cartSummaryResponse.tax;
      _shippingCostString = cartSummaryResponse.shipping_cost;
      _discountString = cartSummaryResponse.discount;
      _totalString = cartSummaryResponse.grand_total;
      _grandTotalValue = cartSummaryResponse.grand_total_value;
      _used_coupon_code = cartSummaryResponse.coupon_code;
      _couponController.text = _used_coupon_code;
      _coupon_applied = cartSummaryResponse.coupon_applied;
      setState(() {});
    }
  }

  reset() {
    _paymentTypeList.clear();
    _isInitial = true;
    _selected_payment_method = "";
    _selected_payment_method_key = "";
    setState(() {});

    reset_summary();
  }

  reset_summary() {
    _totalString = ". . .";
    _grandTotalValue = 0.00;
    _subTotalString = ". . .";
    _taxString = ". . .";
    _shippingCostString = ". . .";
    _discountString = ". . .";
    _used_coupon_code = "";
    _couponController.text = _used_coupon_code;
    _coupon_applied = false;

    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAll();
  }

  onPopped(value) {
    reset();
    fetchAll();
  }

  onCouponApply() async {
    var coupon_code = _couponController.text.toString();
    if (coupon_code == "") {
      ToastComponent.showDialog(
          AppTranslation.translationsKeys[langu_choos.value]
              ['Enter coupon code'],
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }


    var couponApplyResponse = await CouponRepository()
        .getCouponApplyResponse(widget.owner_id, coupon_code);
    if (couponApplyResponse.result == false) {
      ToastComponent.showDialog(couponApplyResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    reset_summary();
    fetchSummary();
  }

  onCouponRemove() async {
    var couponRemoveResponse =
        await CouponRepository().getCouponRemoveResponse(widget.owner_id);

    if (couponRemoveResponse.result == false) {
      ToastComponent.showDialog(couponRemoveResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    reset_summary();
    fetchSummary();
  }

  onPressPlaceOrder() {
    print(_selected_payment_method);
    print(_selected_payment_method_key);
    if (_selected_payment_method == "") {
      ToastComponent.showDialog("Please choose one option to pay", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_selected_payment_method == "stripe_payment") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog("Nothing to pay", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return StripeScreen(
          owner_id: widget.owner_id,
          amount: _grandTotalValue,
          payment_type: "cart_payment",
          payment_method_key: _selected_payment_method_key,
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "paypal_payment") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog("Nothing to pay", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PaypalScreen(
          owner_id: widget.owner_id,
          amount: _grandTotalValue,
          payment_type: "cart_payment",
          payment_method_key: _selected_payment_method_key,
        );
      })).then((value) {
        onPopped(value);
      });
      ;
    } else if (_selected_payment_method == "razorpay") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog("Nothing to pay", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return RazorpayScreen(
          owner_id: widget.owner_id,
          amount: _grandTotalValue,
          payment_type: "cart_payment",
          payment_method_key: _selected_payment_method_key,
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "paystack") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog("Nothing to pay", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PaystackScreen(
          owner_id: widget.owner_id,
          amount: _grandTotalValue,
          payment_type: "cart_payment",
          payment_method_key: _selected_payment_method_key,
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "iyzico") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog("Nothing to pay", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return IyzicoScreen(
          owner_id: widget.owner_id,
          amount: _grandTotalValue,
          payment_type: "cart_payment",
          payment_method_key: _selected_payment_method_key,
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "bkash") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog("Nothing to pay", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BkashScreen(
          owner_id: widget.owner_id,
          amount: _grandTotalValue,
          payment_type: "cart_payment",
          payment_method_key: _selected_payment_method_key,
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "nagad") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog("Nothing to pay", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return NagadScreen(
          owner_id: widget.owner_id,
          amount: _grandTotalValue,
          payment_type: "cart_payment",
          payment_method_key: _selected_payment_method_key,
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "sslcommerz_payment") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog("Nothing to pay", context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SslCommerzScreen(
          owner_id: widget.owner_id,
          amount: _grandTotalValue,
          payment_type: "cart_payment",
          payment_method_key: _selected_payment_method_key,
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "wallet_system") {
      print("wallet");
      pay_by_wallet();
    } else if (_selected_payment_method == "cash_payment") {
      pay_by_cod();
    } else if (_selected_payment_method == "check_payment") {
      String name = _nameController.text.toString();
      if (name.length <= 5) {
        ToastComponent.showDialog(
            AppTranslation.translationsKeys[langu_choos.value]['Enter name'],
            context,
            gravity: Toast.CENTER,
            duration: Toast.LENGTH_LONG);
        return;
      }
      acc = _accController.text.toString();
      if (acc.length <= 0) {
        acc = '0';
      }

      if (_file == null) {
        ToastComponent.showDialog(
            AppTranslation.translationsKeys[langu_choos.value]
                ['No Image Choosen'],
            context,
            gravity: Toast.CENTER,
            duration: Toast.LENGTH_LONG);
        return;
      }

      String base64Image = base64Encode(_file.readAsBytesSync());
      String fileName = _file.path.split("/").last;

      pay_by_bank(base64Image, fileName, name, acc);
    }
  }

  pay_by_bank(
      String bas64, String filename, String routname, String routacc) async {
    print("aaaaa" + widget.owner_id.toString());
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponseFromBank(
            widget.owner_id,
            _selected_payment_method,
            _grandTotalValue,
            _selected_payment_method_key,
            routname,
            routacc,
            bas64,
            filename);

    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    //print(orderCreateResponse.result);
    //print(orderCreateResponse.message);
    //print(orderCreateResponse.order_id);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OrderList(from_checkout: true);
    }));
  }

  pay_by_wallet() async {
    print("aaaaa" + widget.owner_id.toString());
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponseFromWallet(
            widget.owner_id, _selected_payment_method_key, _grandTotalValue);

    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OrderList(from_checkout: true);
    }));
  }

  pay_by_cod() async {
    print('wwwwwwww');
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponseFromCod(
            widget.owner_id, _selected_payment_method_key);

    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.of(context).pop();
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OrderList(from_checkout: true);
    }));
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
  String bankname = '';
  onPaymentMethodItemTap(index) {
    if (_selected_payment_method_key !=
        _paymentTypeList[index].payment_type_key) {
      setState(() {
        _selectedindex = index;
        handerstring(_paymentTypeList[_selectedindex].description.toString());
        bankname = _paymentTypeList[index].name;
        _selected_payment_method = _paymentTypeList[index].payment_type;
        _selected_payment_method_key = _paymentTypeList[index].payment_type_key;
      });
    }

    print('ggg');
    print(_selected_payment_method);
    print(_selected_payment_method_key);
    if (_selected_payment_method == 'check_payment') {
      print('eee');
      //_scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      /*_scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
      );*/

      Future.delayed(const Duration(milliseconds: 200), () {
        Scrollable.ensureVisible(dataKey.currentContext,
            alignment: 5, duration: const Duration(milliseconds: 500));
      });
    }
  }

  alert() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: SingleChildScrollView(
          child: Container(
        height: 200,
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      child: Text(
                        AppTranslation.translationsKeys[langu_choos.value]
                            ['SUB TOTAL'],
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Spacer(),
                    Text(
                      _subTotalString,
                      style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      child: Text(
                        AppTranslation.translationsKeys[langu_choos.value]
                            ['TAX'],
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Spacer(),
                    Text(
                      _taxString,
                      style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      child: Text(
                        AppTranslation.translationsKeys[langu_choos.value]
                            ['SHIPPING COST'],
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Spacer(),
                    Text(
                      _shippingCostString,
                      style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      child: Text(
                        AppTranslation.translationsKeys[langu_choos.value]
                            ['DISCOUNT'],
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Spacer(),
                    Text(
                      _discountString,
                      style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
            Divider(),
            Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      child: Text(
                        AppTranslation.translationsKeys[langu_choos.value]
                            ['GRAND TOTAL'],
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Spacer(),
                    Text(
                      _totalString,
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
          ],
        ),
      )),
    );
  }

  onPressDetails() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: EdgeInsets.only(
                  top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
              content: GetBuilder<HomeController>(
                builder: (_) => getxc.lang == 'ar'
                    ? Directionality(
                        textDirection: TextDirection.rtl,
                        child: alert(),
                      )
                    : Directionality(
                        textDirection: TextDirection.ltr,
                        child: alert(),
                      ),
              ),
              actions: [
                FlatButton(
                  child: Text(
                    AppTranslation.translationsKeys[langu_choos.value]['CLOSE'],
                    style: TextStyle(color: MyTheme.medium_grey),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ));
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
                      Container(
                        height: 140,
                      )
                    ]),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  /*border: Border(
                    top: BorderSide(color: MyTheme.light_grey,width: 1.0),
                  )*/
                ),
                height: 140,
                //color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: buildApplyCouponRow(context),
                      ),
                      Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: MyTheme.soft_accent_color),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10.0,0,10,0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  AppTranslation
                                          .translationsKeys[langu_choos.value]
                                      ['total amount'],
                                  style: TextStyle(
                                      color: MyTheme.white, fontSize: 14),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    onPressDetails();
                                  },
                                  child: Text(
                                    AppTranslation
                                            .translationsKeys[langu_choos.value]
                                        ['see details'],
                                    style: TextStyle(
                                      color: MyTheme.white,
                                      fontSize: 12,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Text(_totalString,
                                    style: TextStyle(
                                        color: MyTheme.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Row buildApplyCouponRow(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 42,
          width: (MediaQuery.of(context).size.width - 50) * (2 / 3),
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: _couponController,
            readOnly: _coupon_applied,
            autofocus: false,
            decoration: InputDecoration(
                hintText: AppTranslation.translationsKeys[langu_choos.value]
                    ['Coupon Code'],
                hintStyle:
                    TextStyle(fontSize: 14.0, color: MyTheme.font_grey),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: MyTheme.textfield_grey, width: 0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(8.0),
                    bottomLeft: const Radius.circular(8.0),
                    topRight: const Radius.circular(8.0),
                    bottomRight: const Radius.circular(8.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: MyTheme.medium_grey, width: 0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(8.0),
                    bottomLeft: const Radius.circular(8.0),
                    topRight: const Radius.circular(8.0),
                    bottomRight: const Radius.circular(8.0),
                  ),
                ),
                contentPadding: EdgeInsets.only(left: 16.0)),
          ),
        ),
        !_coupon_applied
            ? Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Container(
                  width: (MediaQuery.of(context).size.width - 32) * (1 / 3),
                  height: 42,
                  child: FlatButton(
                    minWidth: MediaQuery.of(context).size.width,
                    //height: 50,
                    color: MyTheme.accent_color,
                    shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.only(
                      topRight: const Radius.circular(8.0),
                      bottomRight: const Radius.circular(8.0),
                      topLeft: const Radius.circular(8.0),
                      bottomLeft: const Radius.circular(8.0),
                    )),
                    child: Text(
                      AppTranslation.translationsKeys[langu_choos.value]
                          ['APPLY COUPON'],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      onCouponApply();
                    },
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Container(
                  width: (MediaQuery.of(context).size.width - 32) * (1 / 3),
                  height: 42,
                  child: FlatButton(
                    minWidth: MediaQuery.of(context).size.width,
                    //height: 50,
                    color: MyTheme.accent_color,
                    shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.only(
                      topRight: const Radius.circular(8.0),
                      bottomRight: const Radius.circular(8.0),
                    )),
                    child: Text(
                      "Remove",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      onCouponRemove();
                    },
                  ),
                ),
              )
      ],
    );
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
        AppTranslation.translationsKeys[langu_choos.value]['Checkout'],
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  build_bankfield(int i, int l) {
    if (i == l - 1) {
      if (_selected_payment_method == 'check_payment') {
        return Card(
            key: dataKey,
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
                        _paymentTypeList[_selectedindex].bank_info != []
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  AppTranslation
                                          .translationsKeys[langu_choos.value]
                                      ['name'],
                                  style: TextStyle(
                                      color: MyTheme.accent_color,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            : Container(),
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
                              keyboardType:
                                  TextInputType.numberWithOptions(signed: true),
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

  final dataKey = new GlobalKey();
  buildPaymentMethodList() {
    if (_isInitial && _paymentTypeList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_paymentTypeList.length > 0) {
      return ListView.builder(
        controller: _scrollController,
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
                  build_bankfield(index, _paymentTypeList.length),
                ],
              ));
        },
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
                    ['PLACE MY ORDER'],
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                onPressPlaceOrder();
              },
            )
          ],
        ),
      ),
    );
  }
}
