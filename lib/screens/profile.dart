import 'package:flutter/material.dart';
import '../my_theme.dart';
import '../ui_sections/drawer.dart';
import '../app_config.dart';
import '../screens/wallet.dart';
import '../screens/profile_edit.dart';
import '../screens/address.dart';
import '../screens/order_list.dart';
import '../screens/club_point.dart';
import '../screens/refund_request.dart';
import '../repositories/profile_repositories.dart';
import '../custom/toast_component.dart';
import 'package:toast/toast.dart';
import '../addon_config.dart';
import '../helpers/home_controller.dart';
import 'package:get/get.dart';
import '../helpers/lang.dart';
import '../helpers/translation.dart';
import '../helpers/shared_value_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import '../repositories/change_currency.dart';
import '../screens/main.dart';
import '../screens/notification_list.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.show_back_button = false}) : super(key: key);

  bool show_back_button;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ScrollController _mainScrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final getxc = Get.put(HomeController());

  List<Lang> lnglist = Lang.getLangdata();
  Lang _selectedlang;
  List<DropdownMenuItem<Lang>> _dropdownlang;

  Lang symbol;


  int _cartCounter = 0;
  String _cartCounterString = "...";
  int _wishlistCounter = 0;
  String _wishlistCounterString = "...";
  int _orderCounter = 0;
  String _orderCounterString = "...";
  int _keyc;
  String count = 'العملة:';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // _dropdownlang = buildDropdownLang(lnglist);
  //  _selectedlang = _dropdownlang[0].value;
    if (is_logged_in.value == true) {
      fetchAll();
    }
  }

  Future<String> get(String url) async {
    var urlv = Uri.parse(url);
    var response = await http.get(urlv);
    if (response.statusCode == 200) {
      return (response.body.trim().toString());
    } else {
      throw Exception('Failed to load');
    }
  }

  bool finishapi = false;
  List lstc = [];
  List<int> listint = [];

  fetchDataContry() async {
    finishapi = false;
    print("enterapi");
    try {
      await get("${AppConfig.BASE_URLPOS}countries").then((String result) {
        Map map = jsonDecode(result);
        //   print(map);
        List lstcv = [];
        lstcv = map["data"];
        for (int i = 0; i < lstcv.length; i++) {
          print(i);
          if (i == 0) {
            lstc.clear();
            listint.clear();
          }
          if (lstcv[0]['status'].toString() == "1") {
            lstc.add(lstcv[i]);
            listint.add(i);
          }
        }
        print(lstc[0]['name']);
        print(listint);
        finishapi = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  _collapsec() {
    int newKey;
    do {
      _keyc = new Random().nextInt(10000);
    } while (newKey == _keyc);
  }

  Widget ListTilewc(String val, String icon, String curr) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(val),
          ),
          FadeInImage.assetNetwork(
            height: 20,
            width: 30,
            placeholder: 'assets/placeholder.png',
            image: icon,
            fit: BoxFit.cover,
          )
        ],
      ),
      onTap: () {
        setState(() {
          this.count = val;
          changecurr(curr);
          _collapsec();
        });
        print(count);
      },
    );
  }

  changecurr(String currp) async {
    curr.value = currp;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var responschange =
        await ChangeCurrencyRepository().PostChangeCurrResponse(currp);
    Map map = jsonDecode(responschange);
    print(map);
    print(map['success']);
    String res = map['success'].toString();
    if (res == 'true') {
      await prefs.setString("curr", currp);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    } else {
      ToastComponent.showDialog(
          AppTranslation.translationsKeys[langu_choos.value]['No Connection'],
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    }
  }

  Country() {
    return Card(
        shape: RoundedRectangleBorder(
          //  side: new BorderSide(color: MyTheme.accent_color, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0,
        child: ExpansionTile(
            key: new Key(_keyc.toString()),
            initiallyExpanded: false,
            title: new Text(this.count),
            backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
            children: [
              for (var i in listint)
                ListTilewc(
                    lstc[i]['name'], lstc[i]['icon'], lstc[i]['currency']),
            ]));
  }

  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  fetchAll() {
    fetchCounters();
  }

  fetchCounters() async {
    var profileCountersResponse =
        await ProfileRepository().getProfileCountersResponse();

    _cartCounter = profileCountersResponse.cart_item_count;
    _wishlistCounter = profileCountersResponse.wishlist_item_count;
    _orderCounter = profileCountersResponse.order_count;

    _cartCounterString =
        counterText(_cartCounter.toString(), default_length: 2);
    _wishlistCounterString =
        counterText(_wishlistCounter.toString(), default_length: 2);
    _orderCounterString =
        counterText(_orderCounter.toString(), default_length: 2);

    setState(() {});
  }

  String counterText(String txt, {default_length = 3}) {
    var blank_zeros = default_length == 3 ? "000" : "00";
    var leading_zeros = "";
    if (txt != null) {
      if (default_length == 3 && txt.length == 1) {
        leading_zeros = "00";
      } else if (default_length == 3 && txt.length == 2) {
        leading_zeros = "0";
      } else if (default_length == 2 && txt.length == 1) {
        leading_zeros = "0";
      }
    }

    var newtxt = (txt == null || txt == "" || txt == null.toString())
        ? blank_zeros
        : txt;

    // print(txt + " " + default_length.toString());
    // print(newtxt);

    if (default_length > txt.length) {
      newtxt = leading_zeros + newtxt;
    }
    //print(newtxt);

    return newtxt;
  }

  reset() {
    _cartCounter = 0;
    _cartCounterString = "...";
    _wishlistCounter = 0;
    _wishlistCounterString = "...";
    _orderCounter = 0;
    _orderCounterString = "...";
    setState(() {});
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

  scaffold() {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MainDrawer(),
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  buildBody(context) {
    if (is_logged_in.value == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            "Please log in to see the profile",
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else {
      return RefreshIndicator(
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
                buildTopSection(),
                buildCountersRow(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    height: 10,
                  ),
                ),
                buildHorizontalMenu(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    height: 10,
                  ),
                ),
                buildVerticalMenu()
              ]),
            )
          ],
        ),
      );
    }
  }

  buildHorizontalMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OrderList();
            }));
          },
          child: Column(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: MyTheme.light_grey,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.assignment_outlined,
                      color: Colors.green,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  AppTranslation.translationsKeys[langu_choos.value]['orders'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyTheme.font_grey, fontWeight: FontWeight.w300),
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ProfileEdit();
            })).then((value) {
              onPopped(value);
            });
          },
          child: Column(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: MyTheme.light_grey,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.person,
                      color: Colors.blueAccent,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  AppTranslation.translationsKeys[langu_choos.value]['My Data'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyTheme.font_grey, fontWeight: FontWeight.w300),
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Address();
            }));
          },
          child: Column(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: MyTheme.light_grey,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.amber,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  AppTranslation.translationsKeys[langu_choos.value]['Address'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyTheme.font_grey, fontWeight: FontWeight.w300),
                ),
              )
            ],
          ),
        ),
        /*InkWell(
          onTap: () {
            ToastComponent.showDialog("Coming soon", context,
                gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          },
          child: Column(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: MyTheme.light_grey,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Icon(Icons.message_outlined, color: Colors.redAccent),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Message",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyTheme.font_grey, fontWeight: FontWeight.w300),
                ),
              )
            ],
          ),
        ),*/
      ],
    );
  }

  /*DropdownButton languageChooser() {
    String lng;
    if(langu_choos.value.length>0){
    }else{
      lng='عربي';
    }
    return DropdownButton<String>(
          isExpanded: false,
          dropdownColor: MyTheme.grey_153,
          // hint: Text('Please choose a Language'), // Not necessary for Option 1
          value:lng,
          onChanged: (symbol) {
            getxc.changeLanguage(symbol);
            langu_choos.value=symbol;
            setState(() {
              lng=symbol;
            });
          },
          items: dummyLangList.map((Lang _language) {
            return DropdownMenuItem<String>(

              child:  Text(_language.name,style: TextStyle( fontSize: 14)),
              value: _language.name,
            );
          }).toList());
  }*/

  buildVerticalMenu() {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /*Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.language,
                        color: Colors.white,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Container(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.symmetric(
                              vertical: BorderSide(
                                  color: MyTheme.light_grey, width: .5),
                              horizontal: BorderSide(
                                  color: MyTheme.light_grey, width: 1))),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      height: 36,
                      width: MediaQuery.of(context).size.width * .33,
                      child: new DropdownButton<Lang>(
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Icon(Icons.expand_more, color: Colors.black54),
                        ),
                        iconSize: 14,
                        underline: SizedBox(),
                        value: _selectedlang,
                        items: _dropdownlang,
                        onChanged: (Lang symbol) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          setState(() {
                            _selectedlang = symbol;
                          });
                          langu_choos.value = symbol.key;
                          getxc.changeLanguage(symbol.key);
                          await prefs.setString('lng', symbol.key);
                        },
                      ),
                    ),

                    //languageChooser(),
                  ),
                )
              ],
            ),
          ),
          is_logged_in.value == true
              ? Container()
              : FutureBuilder(
                  future: fetchDataContry(),
                  builder: (context, asyn) {
                    if (lstc.length > 0) {
                      print('soso');
                      return Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: MyTheme.accent_color,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                ),
                              )),
                          Container(width: 200, child: Country())
                        ],
                      );
                    } else {
                      if (finishapi) {
                        return Center(child: Text('تاكد من اتصالك بالنت'));
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Container(
                            height: 50,
                            child: Center(
                                child: LinearProgressIndicator(value: null)),
                          ),
                        );
                      }
                    }
                  }),*/
          /*InkWell(
            onTap: () {
              ToastComponent.showDialog("Coming soon", context,
                  gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
            },
            child: Visibility(
              visible: true,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Text(
                        AppTranslation.translationsKeys[langu_choos.value]
                            ['Notification'],
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: MyTheme.font_grey, fontSize: 14),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),*/
          Card(
            elevation: 0.0,
            margin: const EdgeInsets.fromLTRB(1.0, 8.0, 1.0, 0.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.language,
                          color: Colors.white,
                        ),
                      )),
                  title: Text(
                    AppTranslation.translationsKeys[langu_choos.value]
                        ['Language'],
                    textAlign: getxc.lang == 'ar'?TextAlign.right:TextAlign.left,
                    style: TextStyle(color: MyTheme.font_grey, fontSize: 16),
                  ),
                  trailing: Icon(getxc.lang == 'ar'?Icons.keyboard_arrow_left:Icons.keyboard_arrow_right),
                  onTap: () {
                        showModalBottomSheet(
                        context: context, builder: (ctx) => _buildBottomSheet(ctx));
                  },
                ),
                _buildDivider(),
                ListTile(
                  leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                        ),
                      )),
                  title: Text(
                    AppTranslation.translationsKeys[langu_choos.value]
                        ['Notification'],
                    textAlign: getxc.lang == 'ar'?TextAlign.right:TextAlign.left,
                    style: TextStyle(color: MyTheme.font_grey, fontSize: 16),
                  ),
                  trailing: Icon(getxc.lang == 'ar'?Icons.keyboard_arrow_left:Icons.keyboard_arrow_right),
                  onTap: () {
                    /*ToastComponent.showDialog("Coming soon", context,
                        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);*/
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return NotificationList();
                        }));
                  },
                ),
                _buildDivider(),
                ListTile(
                  leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.credit_card_rounded,
                          color: Colors.white,
                        ),
                      )),
                  title: Text(
                    AppTranslation.translationsKeys[langu_choos.value]
                        ['Purchase History'],
                    textAlign: getxc.lang == 'ar'?TextAlign.right:TextAlign.left,
                    style: TextStyle(color: MyTheme.font_grey, fontSize: 16),
                  ),
                  trailing: Icon(getxc.lang == 'ar'?Icons.keyboard_arrow_left:Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return OrderList();
                    }));
                  },
                ),
                _buildDivider(),
                AddonConfig.club_point_addon_installed
                    ? ListTile(
                        leading: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.monetization_on_outlined,
                                color: Colors.white,
                              ),
                            )),
                        title: Text(
                          AppTranslation.translationsKeys[langu_choos.value]
                              ['Earning Points'],
                          textAlign: getxc.lang == 'ar'?TextAlign.right:TextAlign.left,
                          style:
                              TextStyle(color: MyTheme.font_grey, fontSize: 16),
                        ),
                        trailing: Icon(getxc.lang == 'ar'?Icons.keyboard_arrow_left:Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Clubpoint();
                          }));
                        },
                      )
                    : Container(),
                AddonConfig.club_point_addon_installed
                    ? _buildDivider()
                    : Container(),
                AddonConfig.refund_addon_installed
                    ? ListTile(
                        leading: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.pinkAccent,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.double_arrow,
                                color: Colors.white,
                              ),
                            )),
                        title: Text(
                          AppTranslation.translationsKeys[langu_choos.value]
                              ['Refund Requests'],
                          textAlign: getxc.lang == 'ar'?TextAlign.right:TextAlign.left,
                          style:
                              TextStyle(color: MyTheme.font_grey, fontSize: 16),
                        ),
                        trailing: Icon(getxc.lang == 'ar'?Icons.keyboard_arrow_left:Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return RefundRequest();
                          }));
                        },
                      )
                    : Container(),
                AddonConfig.refund_addon_installed
                    ? _buildDivider()
                    : Container(),
              ],
            ),
          ),

          /*InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return OrderList();
              }));
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.credit_card_rounded,
                          color: Colors.white,
                        ),
                      )),

                ],
              ),
            ),
          ),*/
          /*Text(
            AppTranslation.translationsKeys[langu_choos.value]
            ['Purchase History'],
            textAlign: TextAlign.center,
            style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
          )*/
          /*AddonConfig.club_point_addon_installed
              ? InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Clubpoint();
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.monetization_on_outlined,
                                color: Colors.white,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: Text(
                            AppTranslation.translationsKeys[langu_choos.value]
                                ['Earning Points'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container(),*/
          /*AddonConfig.refund_addon_installed
              ? InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RefundRequest();
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.pinkAccent,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.double_arrow,
                                color: Colors.white,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: Text(
                            AppTranslation.translationsKeys[langu_choos.value]
                                ['Refund Requests'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container(),*/
        ],
      ),
    );
  }

  buildCountersRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _cartCounterString,
                style: TextStyle(
                    fontSize: 16,
                    color: MyTheme.font_grey,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  AppTranslation.translationsKeys[langu_choos.value]
                      ['In your cart'],
                  style: TextStyle(
                    color: MyTheme.medium_grey,
                  ),
                )),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _wishlistCounterString,
                style: TextStyle(
                    fontSize: 16,
                    color: MyTheme.font_grey,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  AppTranslation.translationsKeys[langu_choos.value]
                      ['In wishlist'],
                  style: TextStyle(
                    color: MyTheme.medium_grey,
                  ),
                )),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _orderCounterString,
                style: TextStyle(
                    fontSize: 16,
                    color: MyTheme.font_grey,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  AppTranslation.translationsKeys[langu_choos.value]['Ordered'],
                  style: TextStyle(
                    color: MyTheme.medium_grey,
                  ),
                )),
          ],
        )
      ],
    );
  }

  buildTopSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                  color: Color.fromRGBO(112, 112, 112, .3), width: 2),
              //shape: BoxShape.rectangle,
            ),
            child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.all(Radius.circular(100.0)),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/placeholder.png',
                  image: AppConfig.BASE_PATH + "${avatar_original.value}",
                  fit: BoxFit.fill,
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            "${user_name.value}",
            style: TextStyle(
                fontSize: 14,
                color: MyTheme.font_grey,
                fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: user_email.value != "" && user_email.value != null
                ? Text(
                    "${user_email.value}",
                    style: TextStyle(
                      color: MyTheme.medium_grey,
                    ),
                  )
                : Text(
                    "${user_phone.value}",
                    style: TextStyle(
                      color: MyTheme.medium_grey,
                    ),
                  )),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Container(
            height: 24,
            child: FlatButton(
              color: Colors.green,
              // 	rgb(50,205,50)
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.only(
                topLeft: const Radius.circular(16.0),
                bottomLeft: const Radius.circular(16.0),
                topRight: const Radius.circular(16.0),
                bottomRight: const Radius.circular(16.0),
              )),
              child: Text(
                AppTranslation.translationsKeys[langu_choos.value]
                    ['Check Balance'],
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Wallet();
                }));
              },
            ),
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: GestureDetector(
        child: widget.show_back_button
            ? Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            : Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Builder(
                      builder: (context) => Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 0.0),
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
              ),
      ),
      title: Text(
        AppTranslation.translationsKeys[langu_choos.value]['account'],
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  List<DropdownMenuItem<Lang>> buildDropdownLang(List which_filter_list) {
    List<DropdownMenuItem<Lang>> items = List();
    for (Lang which_filter_item in which_filter_list) {
      items.add(
        DropdownMenuItem(
          value: which_filter_item,
          child: Text(which_filter_item.name),
        ),
      );
    }
    return items;
  }

  Container _buildBottomSheet(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(8.0),
      /*decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),*/
      child: ListView(
        children: [
          ListTile(
            title: Text(
              'عربي',
              textAlign: TextAlign.center,
              style:
              TextStyle(color: MyTheme.font_grey, fontSize: 16),
            ),
           // trailing: Icon(Icons.keyboard_arrow_left),
            onTap: () async {
              SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              langu_choos.value = 'ar';
              getxc.changeLanguage('ar');
              await prefs.setString('lng', 'ar');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'English',
              textAlign: TextAlign.center,
              style:
              TextStyle(color: MyTheme.font_grey, fontSize: 16),
            ),
        //    trailing: Icon(Icons.keyboard_arrow_left),
            onTap: () async {
              SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              langu_choos.value = 'en';
              getxc.changeLanguage('en');
              await prefs.setString('lng', 'en');
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}

Container _buildDivider() {
  return Container(
    margin: const EdgeInsets.symmetric(
      horizontal: 8.0,
    ),
    width: double.infinity,
    height: 1.0,
    color: Colors.grey.shade400,
  );
}


