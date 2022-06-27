import 'package:flutter/material.dart';
import '../custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'dart:convert';
import '../repositories/payment_repository.dart';
import '../my_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../screens/order_list.dart';
import '../screens/wallet.dart';
import '../app_config.dart';
import '../helpers/shared_value_helper.dart';

class BankPayScreen extends StatefulWidget {
  int owner_id;
  double amount;
  String payment_type;
  String payment_method_key;

  BankPayScreen(
      {Key key,
      this.owner_id = 0,
      this.amount = 0.00,
      this.payment_type = "",
      this.payment_method_key = ""})
      : super(key: key);

  @override
  _BankPayScreenState createState() => _BankPayScreenState();
}

class _BankPayScreenState extends State<BankPayScreen> {
  int _order_id = 0;
  bool _order_init = false;

  WebViewController _webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();



    if (widget.payment_type == "cart_payment") {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }


  buildBody() {
        child: Center(
          child: Text("Banks"),
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
        "Pay with Bank",
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
