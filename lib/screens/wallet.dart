import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../my_theme.dart';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import '../helpers/reg_ex_inpur_formatter.dart';
import '../repositories/wallet_repository.dart';
import '../helpers/shimmer_helper.dart';
import '../custom/toast_component.dart';
import 'package:toast/toast.dart';
import '../screens/recharge_wallet.dart';
import '../screens/main.dart';
import '../helpers/translation.dart';
import '../helpers/shared_value_helper.dart';
import '../helpers/home_controller.dart';
import 'package:get/get.dart';

class Wallet extends StatefulWidget with WidgetsBindingObserver {

  Wallet({Key key, this.from_recharge = false}) : super(key: key);
  final bool from_recharge;

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final _amountValidator = RegExInputFormatter.withRegex(
      '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');
  ScrollController _mainScrollController = ScrollController();
  ScrollController _scrollController = ScrollController();
  TextEditingController _amountController = TextEditingController();
  final getxc = Get.put(HomeController());
  var _balanceDetails = null;

  List<dynamic> _rechargeList = [];
  bool _rechargeListInit = true;
  int _rechargePage = 1;
  int _totalRechargeData = 0;
  bool _showRechageLoadingContainer = false;

  @override
  void initState() {
    super.initState();
    print('toto');
    fetchAll();
    _mainScrollController.addListener(() {
      if (_mainScrollController.position.pixels ==
          _mainScrollController.position.maxScrollExtent) {
        setState(() {
          _rechargePage++;
        });
        _showRechageLoadingContainer = true;
        fetchRechargeList();
      }
    });
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    print('lolo');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state== AppLifecycleState.resumed){
      print('resum');
    }else{
      print('notresum');
    }
  }

  fetchAll() {
    fetchBalanceDetails();
    fetchRechargeList();
  }

  fetchBalanceDetails() async {
    var balanceDetailsResponse =
        await WalletRepository().getBalance();

    _balanceDetails = balanceDetailsResponse;

    setState(() {});
  }

  fetchRechargeList() async {
    var rechageListResponse = await WalletRepository()
        .getRechargeList( page: _rechargePage);
    _rechargeList.addAll(rechageListResponse.recharges);
    _totalRechargeData = rechageListResponse.meta.total;

    _rechargeListInit = false;
    _showRechageLoadingContainer = false;

    setState(() {});
  }

  reset() {
    _balanceDetails = null;
    _rechargeList.clear();
    _rechargeListInit = true;
    _rechargePage = 1;
    _totalRechargeData = 0;
    _showRechageLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }

  onPressProceed(){
    var amount_String = _amountController.text.toString();

    if(amount_String == ""){
      ToastComponent.showDialog(AppTranslation.translationsKeys[langu_choos.value]['Amount cannot be empty'], context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    var amount = double.parse(amount_String);

    Navigator.of(context, rootNavigator: true).pop();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RechargeWallet(amount: amount );
    }));
    
  }

  @override
  Widget build(BuildContext context) {
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

  scaffold(){
    return WillPopScope(
      onWillPop: () {
        if (widget.from_recharge) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Main();
          }));
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          body: Stack(
            children: [
              RefreshIndicator(
                color: MyTheme.accent_color,
                backgroundColor: Colors.white,
                onRefresh: _onPageRefresh,
                displacement: 10,
                child: CustomScrollView(
                  controller: _mainScrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          height: 276,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0.0, left: 16.0, right: 16.0, bottom: 16.0),
                          child: buildRechargeList(),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
              //original
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  height: 276,
                  //color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 0.0, left: 16.0, right: 16.0),
                    child: _balanceDetails != null
                        ? buildTopSection(context)
                        : ShimmerHelper().buildBasicShimmer(height: 150),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: buildLoadingContainer())
            ],
          )),
    );
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showRechageLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalRechargeData == _rechargeList.length
            ? AppTranslation.translationsKeys[langu_choos.value]['No More']
            : AppTranslation.translationsKeys[langu_choos.value]['Loading More']+"..."),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () {
            return Navigator.of(context).pop();
          },
        ),
      ),
      title: Text(
        AppTranslation.translationsKeys[langu_choos.value]['my wallet'],
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildRechargeList() {
    if (_rechargeListInit && _rechargeList.length == 0) {
      return SingleChildScrollView(child: buildRechargeListShimmer());
    } else if (_rechargeList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _rechargeList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: buildRechargeListItemCard(index),
            );
          },
        ),
      );
    } else if (_totalRechargeData == 0) {
      return Center(child: Text(AppTranslation.translationsKeys[langu_choos.value]['No recharges yet']));
    } else {
      return Container(); // should never be happening
    }
  }

  buildRechargeListShimmer() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ShimmerHelper().buildBasicShimmer(height: 75.0),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ShimmerHelper().buildBasicShimmer(height: 75.0),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ShimmerHelper().buildBasicShimmer(height: 75.0),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ShimmerHelper().buildBasicShimmer(height: 75.0),
        )
      ],
    );
  }

  Card buildRechargeListItemCard(int index) {
    return Card(
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                 Container(
                    width: 50,
                    child: Text(
                      getFormattedRechargeListIndex(index),
                      style: TextStyle(
                          color: MyTheme.dark_grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    )),
                _rechargeList[index].approval_string=='Approved'?
                 Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0), color: Colors.green),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Icon(FontAwesome.check, color: Colors.white, size: 10),
                  ),
                )
                :Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0), color: Colors.red),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Icon(FontAwesome.close, color: Colors.white, size: 10),
                  ),
                )
              ],
            ),
            Container(
                width: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _rechargeList[index].date,
                      style: TextStyle(
                        color: MyTheme.dark_grey,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Payment Method",
                      style: TextStyle(
                        color: MyTheme.dark_grey,
                      ),
                    ),
                    Text(
                      _rechargeList[index].payment_method,
                      style: TextStyle(
                        color: MyTheme.dark_grey,
                      ),
                    ),
                  ],
                )),
            Spacer(),
            Container(
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _rechargeList[index].amount,
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Approval Status",
                      style: TextStyle(
                        color: MyTheme.dark_grey,
                      ),
                    ),
                    Text(
                      _rechargeList[index].approval_string,
                      style: TextStyle(
                        color: MyTheme.dark_grey,
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  getFormattedRechargeListIndex(int index) {
    int num = index + 1;
    var txt = num.toString().length == 1
        ? "# 0" + num.toString()
        : "#" + num.toString();
    return txt;
  }

  buildTopSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            color: MyTheme.accent_color,
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(color: Color.fromRGBO(112, 112, 112, .3), width: 1),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  AppTranslation.translationsKeys[langu_choos.value]['Wallet Balance'],
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _balanceDetails.balance,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  "Last recharged : ${_balanceDetails.last_recharged}",
                  style: TextStyle(
                    color: MyTheme.light_grey,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
          ),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: MyTheme.textfield_grey, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(8.0))),
            child: FlatButton(
              minWidth: MediaQuery.of(context).size.width,
              //height: 50,
              color: Color.fromRGBO(252, 252, 252, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0))),
              child: Icon(
                Icons.add,
                size: 24,
                color: MyTheme.dark_grey,
              ),
              onPressed: () {
                print('wowo');
                buildShowAddFormDialog(context);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 5.0),
          child: Text(
            AppTranslation.translationsKeys[langu_choos.value]['Wallet Recharge History'],
            style: TextStyle(
                color: MyTheme.font_grey,
                fontSize: 10,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Future buildShowAddFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              contentPadding: EdgeInsets.only(
                  top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
              content: Container(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(AppTranslation.translationsKeys[langu_choos.value]['Amount'],
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller: _amountController,
                            autofocus: false,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [_amountValidator],
                            decoration: InputDecoration(
                                hintText: AppTranslation.translationsKeys[langu_choos.value]['Enter Amount'],
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.textfield_grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(left: 8.0)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FlatButton(
                        minWidth: 75,
                        height: 30,
                        color: Color.fromRGBO(253, 253, 253, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                                color: MyTheme.light_grey, width: 1.0)),
                        child: Text(
                          AppTranslation.translationsKeys[langu_choos.value]['CLOSE'],
                          style: TextStyle(
                            color: MyTheme.font_grey,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: FlatButton(
                        minWidth: 75,
                        height: 30,
                        color: MyTheme.accent_color,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(
                                color: MyTheme.light_grey, width: 1.0)),
                        child: Text(
                          AppTranslation.translationsKeys[langu_choos.value]['Proceed'],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          onPressProceed();
                        },
                      ),
                    )
                  ],
                )
              ],
            ));
  }
}
