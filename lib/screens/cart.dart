import '../screens/shipping_info.dart';
import 'package:flutter/material.dart';
import '../my_theme.dart';
import '../ui_sections/drawer.dart';
import 'package:flutter/widgets.dart';
import '../repositories/cart_repository.dart';
import '../helpers/shared_value_helper.dart';
import '../helpers/shimmer_helper.dart';
import '../app_config.dart';
import '../custom/toast_component.dart';
import 'package:toast/toast.dart';
import '../helpers/translation.dart';
import '../helpers/home_controller.dart';
import 'package:get/get.dart';
import 'checkout.dart';

class Cart extends StatefulWidget {
  Cart({Key key, this.has_bottomnav, this.isdigit = false}) : super(key: key);
  final bool has_bottomnav;
  final bool isdigit;

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _mainScrollController = ScrollController();
  var _chosenOwnerId = 0;
  var _chosenOwnerIdd = 0;

  var radio = 0;
  var radiod = 1;
  var _shopList = [];
  bool _isInitial = true;
  var _cartTotal = 0.00;
  String whtdo = "";
  // bool iscartdigit=false;
  var _cartTotalString = ". . .";
  var _cartTotalStringd = ". . .";
  var curr = "";
  final getxc = Get.put(HomeController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*print("user data");
    print(is_logged_in.value);
    print(access_token.value);
    print(user_id.value);
    print(user_name.value);*/

    if (widget.isdigit) {
      whtdo = "PROCEED TO CHECKOUT";
    } else {
      whtdo = "PROCEED TO SHIPPING";
    }

    if (is_logged_in.value == true) {
      fetchData();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  fetchData() async {
    var cartResponseList =
        await CartRepository().getCartResponseList(user_id.value);

    if (cartResponseList != null && cartResponseList.length > 0) {
      _shopList = cartResponseList;
      _chosenOwnerIdd = cartResponseList[0].owner_id;

      //  iscartdigit=true;
      try {
        _chosenOwnerId = cartResponseList[1].owner_id;
      } catch (e) {}
    }
    print('ccc');
    //  print(cartResponseList.length);
    _isInitial = false;
    getSetCartTotald();
    getSetCartTotal();
    setState(() {});
  }

  getSetCartTotal() {
    _cartTotal = 0.00;
    if (_shopList.length > 0) {
      _shopList.forEach((shop) {
        if (shop.cart_items.length > 0) {
          shop.cart_items.forEach((cart_item) {
            _cartTotal +=
                (cart_item.price + cart_item.tax) * cart_item.quantity;
            _cartTotalString = "${_cartTotal}";
            curr = cart_item.currency_symbol;
            print("bbb:");
            print(_cartTotalStringd);
            if (_cartTotalStringd.contains(". . .")) {
              whtdo = "PROCEED TO SHIPPING";
              radiod = 0;
              radio = 1;
            }
          });
        }
      });
    }
    setState(() {});
  }

  getSetCartTotald() {
    _cartTotal = 0.00;
    if (_shopList.length > 0) {
      _shopList.forEach((shop) {
        if (shop.cart_items_digital.length > 0) {
          shop.cart_items_digital.forEach((cart_item) {
            _cartTotal +=
                (cart_item.price + cart_item.tax) * cart_item.quantity;
            _cartTotalStringd = "${_cartTotal}";
            print("aaa:");
            print(_cartTotalStringd);
            curr = cart_item.currency_symbol;
            radiod = 1;
            radio = 0;
            if (_cartTotal > 0) {
              whtdo = "PROCEED TO CHECKOUT";
            }
          });
        }
      });
    }
    setState(() {});
  }

  partialTotalString(index) {
    var partialTotal = 0.00;
    var partialTotalString = "";
    if (_shopList[index].cart_items.length > 0) {
      _shopList[index].cart_items.forEach((cart_item) {
        partialTotal += (cart_item.price + cart_item.tax) * cart_item.quantity;
        partialTotalString = "${partialTotal}";
      });
    }

    return partialTotalString;
  }

  partialTotalStringd(index) {
    var partialTotal = 0.00;
    var partialTotalString = "";
    if (_shopList[index].cart_items_digital.length > 0) {
      _shopList[index].cart_items_digital.forEach((cart_item) {
        partialTotal += (cart_item.price + cart_item.tax) * cart_item.quantity;
        partialTotalString = "${partialTotal}";
      });
    }

    return partialTotalString;
  }

  onQuantityIncrease(seller_index, item_index) {
    if (_shopList[seller_index].cart_items[item_index].quantity <
        _shopList[seller_index].cart_items[item_index].upper_limit) {
      _shopList[seller_index].cart_items[item_index].quantity++;
      getSetCartTotal();
      setState(() {});
    } else {
      ToastComponent.showDialog(
          AppTranslation.translationsKeys[langu_choos.value]
                  ['Cannot order more than'] +
              " " +
              "${_shopList[seller_index].cart_items[item_index].upper_limit} " +
              AppTranslation.translationsKeys[langu_choos.value]
                  ['item(s) of this'],
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    }
  }

  onQuantityIncreased(seller_index, item_index) {
    if (_shopList[seller_index].cart_items_digital[item_index].quantity <
        _shopList[seller_index].cart_items_digital[item_index].upper_limit) {
      _shopList[seller_index].cart_items_digital[item_index].quantity++;
      getSetCartTotald();
      setState(() {});
    } else {
      ToastComponent.showDialog(
          AppTranslation.translationsKeys[langu_choos.value]
                  ['Cannot order more than'] +
              " " +
              "${_shopList[seller_index].cart_items_digital[item_index].upper_limit} " +
              AppTranslation.translationsKeys[langu_choos.value]
                  ['item(s) of this'],
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    }
  }

  onQuantityDecrease(seller_index, item_index) {
    if (_shopList[seller_index].cart_items[item_index].quantity >
        _shopList[seller_index].cart_items[item_index].lower_limit) {
      _shopList[seller_index].cart_items[item_index].quantity--;
      getSetCartTotal();
      setState(() {});
    } else {
      ToastComponent.showDialog(
          AppTranslation.translationsKeys[langu_choos.value]
                  ['Cannot order less than'] +
              " " +
              "${_shopList[seller_index].cart_items[item_index].lower_limit} " +
              AppTranslation.translationsKeys[langu_choos.value]
                  ['item(s) of this'],
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    }
  }

  onQuantityDecreased(seller_index, item_index) {
    if (_shopList[seller_index].cart_items_digital[item_index].quantity >
        _shopList[seller_index].cart_items_digital[item_index].lower_limit) {
      _shopList[seller_index].cart_items_digital[item_index].quantity--;
      getSetCartTotald();
      setState(() {});
    } else {
      ToastComponent.showDialog(
          AppTranslation.translationsKeys[langu_choos.value]
                  ['Cannot order less than'] +
              " " +
              "${_shopList[seller_index].cart_items_digital[item_index].lower_limit} " +
              AppTranslation.translationsKeys[langu_choos.value]
                  ['item(s) of this'],
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    }
  }

  onPressDelete(cart_id) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: EdgeInsets.only(
                  top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
              content: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  AppTranslation.translationsKeys[langu_choos.value]
                      ['Are you sure to remove this item'],
                  maxLines: 3,
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
                  color: MyTheme.soft_accent_color,
                  child: Text(
                    AppTranslation.translationsKeys[langu_choos.value]
                        ['Confirm'],
                    style: TextStyle(color: MyTheme.dark_grey),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    confirmDelete(cart_id);
                  },
                ),
              ],
            ));
  }

  confirmDelete(cart_id) async {
    var cartDeleteResponse =
        await CartRepository().getCartDeleteResponse(cart_id);

    if (cartDeleteResponse.result == true) {
      ToastComponent.showDialog(cartDeleteResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      reset();
      fetchData();
    } else {
      ToastComponent.showDialog(cartDeleteResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    }
  }

  onPressUpdate() {
    process(mode: "update");
    processd(mode: "update");
  }

  onPressProceedToShipping() {
    process(mode: "proceed_to_shipping");
  }

  process({mode}) async {
    var cart_ids = [];
    var cart_quantities = [];
    if (_shopList.length > 0) {
      _shopList.forEach((shop) {
        if (shop.cart_items.length > 0) {
          shop.cart_items.forEach((cart_item) {
            cart_ids.add(cart_item.id);
            cart_quantities.add(cart_item.quantity);
          });
        }
      });
    }

    if (cart_ids.length == 0) {
      ToastComponent.showDialog(
          AppTranslation.translationsKeys[langu_choos.value]['Cart is empty'],
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }

    var cart_ids_string = cart_ids.join(',').toString();
    var cart_quantities_string = cart_quantities.join(',').toString();

    print(cart_ids_string);
    print(cart_quantities_string);

    var cartProcessResponse = await CartRepository()
        .getCartProcessResponse(cart_ids_string, cart_quantities_string);

    if (cartProcessResponse.result == false) {
      ToastComponent.showDialog(cartProcessResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(cartProcessResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      if (mode == "update") {
        reset();
        fetchData();
      } else if (mode == "proceed_to_shipping") {
        print("kkkkkkkk" + _chosenOwnerId.toString());
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ShippingInfo(
            owner_id: _chosenOwnerId,
          );
        })).then((value) {
          onPopped(value);
        });
      }
    }
  }

  processd({mode}) async {
    var cart_ids = [];
    var cart_quantities = [];
    if (_shopList.length > 0) {
      _shopList.forEach((shop) {
        if (shop.cart_items_digital.length > 0) {
          shop.cart_items_digital.forEach((cart_item) {
            cart_ids.add(cart_item.id);
            cart_quantities.add(cart_item.quantity);
          });
        }
      });
    }

    if (cart_ids.length == 0) {
      ToastComponent.showDialog(
          AppTranslation.translationsKeys[langu_choos.value]['Cart is empty'],
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }

    var cart_ids_string = cart_ids.join(',').toString();
    var cart_quantities_string = cart_quantities.join(',').toString();

    print(cart_ids_string);
    print(cart_quantities_string);

    var cartProcessResponse = await CartRepository()
        .getCartProcessResponse(cart_ids_string, cart_quantities_string);

    if (cartProcessResponse.result == false) {
      ToastComponent.showDialog(cartProcessResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(cartProcessResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      if (mode == "update") {
        reset();
        fetchData();
      } else if (mode == "proceed_to_shipping") {
        print("kkkkkkkk" + _chosenOwnerIdd.toString());
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ShippingInfo(
            owner_id: _chosenOwnerIdd,
          );
        })).then((value) {
          onPopped(value);
        });
      }
    }
  }

  reset() {
    _chosenOwnerId = 0;
    _chosenOwnerIdd = 0;
    _shopList = [];
    // _shopListd = [];
    _isInitial = true;
    _cartTotal = 0.00;
    _cartTotalString = ". . .";
    _cartTotalStringd = ". . .";

    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchData();
  }

  onPopped(value) async {
    reset();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.has_bottomnav);
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
        key: _scaffoldKey,
        drawer: MainDrawer(),
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
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
                        child: buildCartSellerList(),
                      ),
                      Container(
                        height: widget.has_bottomnav ? 140 : 100,
                      )
                    ]),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: buildBottomContainer(),
            )
          ],
        ));
  }

  tot() {
    if (_shopList.length == 0) {
      return AppTranslation.translationsKeys[langu_choos.value]['total amount'];
    } else {
      return AppTranslation.translationsKeys[langu_choos.value]
              ['total amount'] +
          " " +
          "(" +
          AppTranslation.translationsKeys[langu_choos.value]
              [radio == 1 ? 'Goods Cart' : 'Digital Cart'] +
          ")";
    }
  }

  Container buildBottomContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        /*border: Border(
                  top: BorderSide(color: MyTheme.light_grey,width: 1.0),
                )*/
      ),

      height: widget.has_bottomnav ? 200 : 120,
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: MyTheme.accent_color),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        tot(),
                        style: TextStyle(color: MyTheme.white, fontSize: 12),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 0.0),
                      child: Text(
                          radio == 1
                              ? "$_cartTotalString"
                              : "$_cartTotalStringd",
                          style: TextStyle(
                              color: MyTheme.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(curr,
                          style: TextStyle(
                              color: MyTheme.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 32) * (1 / 3),
                    height: 38,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: MyTheme.textfield_grey, width: 1),
                        borderRadius: const BorderRadius.only(
                          topLeft: const Radius.circular(8.0),
                          bottomLeft: const Radius.circular(8.0),
                          topRight: const Radius.circular(8.0),
                          bottomRight: const Radius.circular(8.0),
                        )),
                    child: FlatButton(
                      minWidth: MediaQuery.of(context).size.width,
                      //height: 50,
                      color: MyTheme.light_grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.only(
                        topLeft: const Radius.circular(8.0),
                        bottomLeft: const Radius.circular(8.0),
                        topRight: const Radius.circular(8.0),
                        bottomRight: const Radius.circular(8.0),
                      )),
                      child: Text(
                        AppTranslation.translationsKeys[langu_choos.value]
                            ['update cart'],
                        style: TextStyle(
                            color: MyTheme.medium_grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        onPressUpdate();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 32) * (2 / 3),
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: MyTheme.textfield_grey, width: 1),
                        borderRadius: const BorderRadius.only(
                          topLeft: const Radius.circular(8.0),
                          bottomLeft: const Radius.circular(8.0),
                          topRight: const Radius.circular(8.0),
                          bottomRight: const Radius.circular(8.0),
                        )),
                    child: FlatButton(
                      minWidth: MediaQuery.of(context).size.width,
                      //height: 50,
                      color: MyTheme.accent_color,
                      shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.only(
                        topLeft: const Radius.circular(8.0),
                        bottomLeft: const Radius.circular(8.0),
                        topRight: const Radius.circular(8.0),
                        bottomRight: const Radius.circular(8.0),
                      )),
                      child: Text(
                        AppTranslation.translationsKeys[langu_choos.value]
                            [whtdo],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        if (whtdo == 'PROCEED TO CHECKOUT') {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Checkout(owner_id: _chosenOwnerIdd);
                          })).then((value) {
                            onPopped(value);
                          });
                        } else {
                          print("koko");
                          onPressProceedToShipping();
                        }
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          _scaffoldKey.currentState.openDrawer();
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Builder(
            builder: (context) => Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                child: Container(
                  height: 40,
                  child: Image.asset(
                    'assets/hamburger.png',
                    height: 16,
                    //color: MyTheme.dark_grey,
                    color: MyTheme.dark_grey,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: MyTheme.light_grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        AppTranslation.translationsKeys[langu_choos.value]['shopping cart'],
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  void _handleSellerRadioValueChange(value) {
    setState(() {
      _chosenOwnerId = value;
      _chosenOwnerIdd = 0;
      radio = 1;
      radiod = 0;
      // iscartdigit=false;
      whtdo = 'PROCEED TO SHIPPING';
      print(_chosenOwnerId);
    });
  }

  void _handleSellerRadioValueChanged(value) {
    setState(() {
      _chosenOwnerIdd = value;
      _chosenOwnerId = 0;
      radio = 0;
      radiod = 1;
      whtdo = 'PROCEED TO CHECKOUT';
      // iscartdigit=true;
      print('gg');
    });
  }

  buildCartSellerList() {
    if (is_logged_in.value == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppTranslation.translationsKeys[langu_choos.value]
                ['Please log in to see the cart items'],
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else if (_isInitial && _shopList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_shopList.length > 0) {
      print('vvvv');
      print(_cartTotalString);
      print(_cartTotalStringd);
      return SingleChildScrollView(
        child: Column(
          children: [
            _cartTotalStringd == '. . .'
                ? Container()
                : ListView.builder(
                    itemCount: _shopList.length,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            index == 0
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 0.0, top: 16.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: SizedBox(
                                            height: 36,
                                            width: 36,
                                            child: Transform.scale(
                                              scale: .75,
                                              child: Radio(
                                                value:
                                                    _shopList[index].owner_id,
                                                groupValue: radio,
                                                activeColor:
                                                    MyTheme.accent_color,
                                                onChanged:
                                                    _handleSellerRadioValueChanged,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _shopList[index].name,
                                          style: TextStyle(
                                              color: MyTheme.font_grey),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 0.0),
                                          child: Text(
                                            _cartTotalStringd,
                                            //  partialTotalStringd(index),
                                            style: TextStyle(
                                                color: MyTheme.accent_color,
                                                fontSize: 14),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5.0),
                                          child: Text(
                                            curr,
                                            style: TextStyle(
                                                color: MyTheme.accent_color,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            buildCartSellerItemListd(index),
                          ],
                        ),
                      );
                    },
                  ),
            _cartTotalString == '. . .'
                ? Container()
                : ListView.builder(
                    itemCount: _shopList.length,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            index == 0
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 0.0, top: 16.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: SizedBox(
                                            height: 36,
                                            width: 36,
                                            child: Transform.scale(
                                              scale: .75,
                                              child: Radio(
                                                value:
                                                    _shopList[index].owner_id,
                                                groupValue: radiod,
                                                activeColor:
                                                    MyTheme.accent_color,
                                                onChanged:
                                                    _handleSellerRadioValueChange,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _shopList[index].name,
                                          style: TextStyle(
                                              color: MyTheme.font_grey),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 0.0),
                                          child: Text(
                                            partialTotalString(index),
                                            style: TextStyle(
                                                color: MyTheme.accent_color,
                                                fontSize: 14),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            curr,
                                            style: TextStyle(
                                                color: MyTheme.accent_color,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            buildCartSellerItemList(index),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      );
    } else if (!_isInitial && _shopList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppTranslation.translationsKeys[langu_choos.value]['Cart is empty'],
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  SingleChildScrollView buildCartSellerItemList(seller_index) {
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: _shopList[seller_index].cart_items.length,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: buildCartSellerItemCard(seller_index, index),
          );
        },
      ),
    );
  }

  SingleChildScrollView buildCartSellerItemListd(seller_index) {
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: _shopList[seller_index].cart_items_digital.length,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: buildCartSellerItemCardd(seller_index, index),
          );
        },
      ),
    );
  }

  buildCartSellerItemCard(seller_index, item_index) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: getxc.border, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.0,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
            //width: 100,
            height: 100,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/placeholder.png',
                  image: AppConfig.BASE_PATH +
                      _shopList[seller_index]
                          .cart_items[item_index]
                          .product_thumbnail_image,
                  fit: BoxFit.fitWidth,
                ))),
        Container(
          width: 170,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _shopList[seller_index]
                          .cart_items[item_index]
                          .product_name,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 14,
                          height: 1.6,
                          fontWeight: FontWeight.w400),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            (_shopList[seller_index]
                                        .cart_items[item_index]
                                        .price *
                                    _shopList[seller_index]
                                        .cart_items[item_index]
                                        .quantity)
                                .toString(),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 8),
                          child: Text(
                            _shopList[seller_index]
                                .cart_items[item_index]
                                .currency_symbol
                                .toString(),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          height: 28,
                          child: InkWell(
                            onTap: () {},
                            child: IconButton(
                              onPressed: () {
                                onPressDelete(_shopList[seller_index]
                                    .cart_items[item_index]
                                    .id);
                              },
                              icon: Icon(
                                Icons.delete_forever_outlined,
                                color: MyTheme.medium_grey,
                                size: 24,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            (_shopList[seller_index].cart_items[item_index].tax)
                                .toString(),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 8),
                          child: Text(
                            _shopList[seller_index]
                                .cart_items[item_index]
                                .currency_symbol
                                .toString(),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 8),
                          child: Text(
                            AppTranslation.translationsKeys[langu_choos.value]
                                ['TAX'],
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  child: Icon(
                    Icons.add,
                    color: MyTheme.accent_color,
                    size: 18,
                  ),
                  shape: CircleBorder(
                    side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
                  ),
                  color: Colors.white,
                  onPressed: () {
                    onQuantityIncrease(seller_index, item_index);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  _shopList[seller_index]
                      .cart_items[item_index]
                      .quantity
                      .toString(),
                  style: TextStyle(color: MyTheme.accent_color, fontSize: 16),
                ),
              ),
              SizedBox(
                width: 28,
                height: 28,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  child: Icon(
                    Icons.remove,
                    color: MyTheme.accent_color,
                    size: 18,
                  ),
                  height: 30,
                  shape: CircleBorder(
                    side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
                  ),
                  color: Colors.white,
                  onPressed: () {
                    onQuantityDecrease(seller_index, item_index);
                  },
                ),
              )
            ],
          ),
        )
      ]),
    );
  }

  buildCartSellerItemCardd(seller_index, item_index) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: getxc.border, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.0,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
            width: 100,
            height: 100,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/placeholder.png',
                  image: AppConfig.BASE_PATH +
                      _shopList[seller_index]
                          .cart_items_digital[item_index]
                          .product_thumbnail_image,
                  fit: BoxFit.fitWidth,
                ))),
        Container(
          width: 170,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _shopList[seller_index]
                          .cart_items_digital[item_index]
                          .product_name,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 14,
                          height: 1.6,
                          fontWeight: FontWeight.w400),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            (_shopList[seller_index]
                                        .cart_items_digital[item_index]
                                        .price *
                                    _shopList[seller_index]
                                        .cart_items_digital[item_index]
                                        .quantity)
                                .toString(),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 8),
                          child: Text(
                            _shopList[seller_index]
                                .cart_items_digital[item_index]
                                .currency_symbol
                                .toString(),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          height: 28,
                          child: InkWell(
                            onTap: () {},
                            child: IconButton(
                              onPressed: () {
                                onPressDelete(_shopList[seller_index]
                                    .cart_items_digital[item_index]
                                    .id);
                              },
                              icon: Icon(
                                Icons.delete_forever_outlined,
                                color: MyTheme.medium_grey,
                                size: 24,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            (_shopList[seller_index]
                                    .cart_items_digital[item_index]
                                    .tax)
                                .toString(),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 8),
                          child: Text(
                            _shopList[seller_index]
                                .cart_items_digital[item_index]
                                .currency_symbol
                                .toString(),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 8),
                          child: Text(
                            AppTranslation.translationsKeys[langu_choos.value]
                                ['TAX'],
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  child: Icon(
                    Icons.add,
                    color: MyTheme.accent_color,
                    size: 18,
                  ),
                  shape: CircleBorder(
                    side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
                  ),
                  color: Colors.white,
                  onPressed: () {
                    onQuantityIncreased(seller_index, item_index);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  _shopList[seller_index]
                      .cart_items_digital[item_index]
                      .quantity
                      .toString(),
                  style: TextStyle(color: MyTheme.accent_color, fontSize: 16),
                ),
              ),
              SizedBox(
                width: 28,
                height: 28,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  child: Icon(
                    Icons.remove,
                    color: MyTheme.accent_color,
                    size: 18,
                  ),
                  height: 30,
                  shape: CircleBorder(
                    side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
                  ),
                  color: Colors.white,
                  onPressed: () {
                    onQuantityDecreased(seller_index, item_index);
                  },
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
