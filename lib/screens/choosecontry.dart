import 'package:gamedif/custom/toast_component.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../app_config.dart';
import '../my_theme.dart';
import '../helpers/shared_value_helper.dart';
import 'main.dart';
import 'package:get/get.dart';
import '../helpers/home_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChoosContry extends StatefulWidget {
  @override
  _ChoosContryState createState() => _ChoosContryState();
}

class _ChoosContryState extends State<ChoosContry> {
  @override
  void initState() {
    super.initState();
    _collapse();
  }

  String lang = 'اللغة:';
  String count = 'الدولة:';
  String langselected = '';
  String countselected = '';
  String countcurrselected = 'SAR';
  int _key;
  int _keyc;
  final getxc = Get.put(HomeController());

  _collapse() {
    int newKey;
    do {
      _key = new Random().nextInt(10000);
    } while (newKey == _key);
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
        print(lstc[0]['icon']);
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
          countselected = val;
          countcurrselected = curr;
          print(countcurrselected);
          _collapsec();
        });
        print(count);
      },
    );
  }

  Widget ListTilew(String val) {
    return new ListTile(
      title: Text(val),
      onTap: () {
        setState(() {
          this.lang = val;
          langselected = val;
          _collapse();
        });
        print(lang);
      },
    );
  }

  Country() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
      child: Card(
          color: MyTheme.shimmer_base,
          shape: RoundedRectangleBorder(
            //  side: new BorderSide(color: MyTheme.accent_color, width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 1.5,
          child: ExpansionTile(
              key: new Key(_keyc.toString()),
              initiallyExpanded: false,
              title: new Text(this.count),
              backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
              children: [
                for (var i in listint)
                  ListTilewc(
                      lstc[i]['name'], lstc[i]['icon'], lstc[i]['currency']),
              ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              height: 150,
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        child: Image.asset('assets/app_logo.png'),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          FlatButton(
                                            minWidth:
                                            MediaQuery.of(context).size.width / 3,
                                            height: 35,
                                            color: MyTheme.accent_colorw,
                                            shape: RoundedRectangleBorder(
                                                side: langu_choos.value == 'ar'
                                                    ? BorderSide(color: MyTheme.golden)
                                                    : BorderSide(
                                                    color: MyTheme.textfield_grey),
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(25.0))),
                                            child: Text(
                                              "العربية",
                                              style: TextStyle(
                                                  color: MyTheme.accent_color,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            onPressed: () async {
                                              langselected = 'عربي';
                                              SharedPreferences prefs =
                                              await SharedPreferences.getInstance();
                                              langu_choos.value = 'ar';
                                              await prefs.setString('lng', 'ar');
                                              await prefs.setString(
                                                  'country', countselected);
                                              getxc.changeLanguage('ar');
                                              setState(() {});
                                            },
                                          ),
                                          Container(
                                            width: 40,
                                          ),
                                          FlatButton(
                                            minWidth:
                                            MediaQuery.of(context).size.width / 3,
                                            height: 35,
                                            color: MyTheme.accent_colorw,
                                            shape: RoundedRectangleBorder(
                                                side: langu_choos.value == 'en'
                                                    ? BorderSide(color: MyTheme.golden)
                                                    : BorderSide(
                                                    color: MyTheme.textfield_grey),
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(25.0))),
                                            child: Text(
                                              'English',
                                              style: TextStyle(
                                                  color: MyTheme.accent_color,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            onPressed: () async {
                                              langselected = 'English';
                                              SharedPreferences prefs =
                                              await SharedPreferences.getInstance();
                                              langu_choos.value = 'en';
                                              await prefs.setString('lng', 'en');
                                              await prefs.setString(
                                                  'country', countselected);
                                              getxc.changeLanguage('en');
                                              setState(() {});
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    lstc.length > 0
                                        ? Country()
                                        : FutureBuilder(
                                        future: fetchDataContry(),
                                        builder: (context, asyn) {
                                          if (lstc.length > 0) {
                                            return Country();
                                          } else {
                                            if (finishapi) {
                                              return Center(
                                                  child:
                                                  Text('تاكد من اتصالك بالنت'));
                                            } else {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15, right: 15),
                                                child: Container(
                                                  height: 50,
                                                  child: Center(
                                                      child: LinearProgressIndicator(
                                                          value: null)),
                                                ),
                                              );
                                            }
                                          }
                                        }),

                                    /*Card(
                    shape: RoundedRectangleBorder(
                      //  side: new BorderSide(color: MyTheme.accent_color, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 1.5,
                    child: ExpansionTile(
                        key: new Key(_key.toString()),
                        initiallyExpanded: false,
                        title: new Text(this.lang),
                        backgroundColor:
                            Theme.of(context).accentColor.withOpacity(0.025),
                        children: [ListTilew('عربي'), ListTilew('English')]),
                  )*/
                                  ],
                                ),
                              )),
                          Container(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 43, right: 43),
                            child: FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              height: 40,
                              color: MyTheme.accent_color,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0))),
                              child: Text(
                                langselected == 'English' ? "Save" : "حفظ",
                                // AppTranslation.translationsKeys[langu_choos.value]['Save'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () async {
                                SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                                if (countselected.length > 1 &&
                                    langselected.length > 1) {
                                  await prefs.setString('chooscountry', '1');
                                  await prefs.setString('lng', '1');
                                  if (langselected == 'عربي') {
                                    langu_choos.value = 'ar';
                                    await prefs.setString('lng', 'ar');
                                    await prefs.setString('country', countselected);
                                    getxc.changeLanguage('ar');
                                  } else {
                                    langu_choos.value = 'en';
                                    await prefs.setString('lng', 'en');
                                    await prefs.setString('country', countselected);
                                    getxc.changeLanguage('en');
                                  }
                                  await prefs.setString("curr", countcurrselected);
                                  curr.value = countcurrselected;
                                  print(curr.value);
                                  print(countcurrselected);
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                        return Main();
                                      }));
                                } else {
                                  ToastComponent.showDialog(
                                      langselected == 'English'
                                          ? "Must Choose Country and Language"
                                          : "يجب اختيار الدولة واللغة",
                                      context,
                                      gravity: Toast.CENTER,
                                      duration: Toast.LENGTH_LONG);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ))
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Container(
                // width: 150,
                // height: 300,
                child: Image.asset('assets/lng.png'),
              ),
            ),
          ],
        ));
  }
}
