import 'package:flutter/material.dart';
import '../my_theme.dart';
import '../repositories/clubpoint_repository.dart';
import '../helpers/shimmer_helper.dart';
import '../custom/toast_component.dart';
import '../screens/wallet.dart';
import 'package:toast/toast.dart';
import '../helpers/translation.dart';
import '../helpers/shared_value_helper.dart';
import '../helpers/home_controller.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../app_config.dart';
import 'package:http/http.dart' as http;

class Clubpoint extends StatefulWidget {
  @override
  _ClubpointState createState() => _ClubpointState();
}

class _ClubpointState extends State<Clubpoint> {
  ScrollController _xcrollController = ScrollController();

  List<dynamic> _list = [];
  List<dynamic> _converted_ids = [];
  bool _isInitial = true;
  int _page = 1;
  int _totalData = 0;
  bool _showLoadingContainer = false;

  final getxc = Get.put(HomeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchData();
   // fetchtot();

    _xcrollController.addListener(() {
      //print("position: " + _xcrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchData();
      }
    });
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

  fetchtot() async {
    print("${AppConfig.BASE_URL}/get-detail/${user_id.value}");
    try {
      await get("${AppConfig.BASE_URL}/get-detail/${user_id.value}")
          .then((String result) {
        Map map = jsonDecode(result);
        List lstcv = [];
        lstcv = map["data"];
        print('koko');
        print(lstcv);

      });
    } catch (e) {
      print(e.toString());
    }
  }

  fetchData() async {
    var clubpointResponse =
        await ClubpointRepository().getClubPointListResponse(page: _page);
    _list.addAll(clubpointResponse.clubpoints);
    _isInitial = false;
    _totalData = clubpointResponse.meta.total;
    _showLoadingContainer = false;
    setState(() {});
  }

  reset() {
    _list.clear();
    _converted_ids.clear();
    _isInitial = true;
    _totalData = 0;
    _page = 1;
    _showLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchData();
  }

  onPressConvert(item_id, _convertedSnackbar) async {
    var clubpointToWalletResponse =
        await ClubpointRepository().getClubpointToWalletResponse(item_id);

    if (clubpointToWalletResponse.result == false) {
      ToastComponent.showDialog(clubpointToWalletResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      /*ToastComponent.showDialog(clubpointToWalletResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);*/
      Scaffold.of(context).showSnackBar(_convertedSnackbar);

      _converted_ids.add(item_id);
      setState(() {});
    }
  }

  onPopped(value) async {
    reset();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    SnackBar _convertedSnackbar = SnackBar(
      content: Text(
        'Points converted to wallet',
        style: TextStyle(color: MyTheme.font_grey),
      ),
      backgroundColor: MyTheme.soft_accent_color,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'SHOW WALLET',
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Wallet();
          })).then((value) {
            onPopped(value);
          });
        },
        textColor: MyTheme.accent_color,
        disabledTextColor: Colors.grey,
      ),
    );

    return GetBuilder<HomeController>(
      builder: (_) => getxc.lang == 'ar'
          ? Directionality(
        textDirection: TextDirection.rtl,
        child: scaffold(_convertedSnackbar),
      )
          : Directionality(
        textDirection: TextDirection.ltr,
        child: scaffold(_convertedSnackbar),
      ),
    );

  }

  scaffold(SnackBar _convertedSnackbar){
    return Scaffold(
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
              controller: _xcrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                          AppTranslation.translationsKeys[langu_choos.value]['TotalPoints']+":"+_totalData.toString(),
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(color: MyTheme.font_grey, fontSize: 18),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(30,0,30,0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                             //   width: 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppTranslation.translationsKeys[langu_choos.value]
                                      ['Order Code'],
                                      style: TextStyle(
                                        color: MyTheme.dark_grey,
                                      ),
                                      //textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 0,
                                    ),
                                  ],
                                )),
                            Spacer(),
                            Container(
                             //   width: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppTranslation.translationsKeys[langu_choos.value]
                                      ['Order Date'],
                                      style: TextStyle(
                                        color: MyTheme.dark_grey,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0,
                                    ),
                                  ],
                                )),
                            Spacer(),
                            Container(
                              //  width: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      AppTranslation.translationsKeys[langu_choos.value]
                                      ['Club Point'],
                                      style: TextStyle(
                                        color: MyTheme.dark_grey,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0,
                                    ),
                                    /*_list[index].convert_status == 1 ||
                            _converted_ids.contains(_list[index].id)
                        ? Text(
                            "DONE",
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          )
                        : SizedBox(
                            height: 24,
                            width: 80,
                            child: FlatButton(
                              color: MyTheme.accent_color,
                              child: Text(
                                "Convert",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                onPressConvert(
                                    _list[index].id, _convertedSnackbar);
                              },
                            ),
                          ),*/
                                  ],
                                ))
                          ],
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: buildList(_convertedSnackbar),
                    ),
                  ]),
                )
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter, child: buildLoadingContainer())
        ],
      ),
    );
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _list.length
            ? "No More Items"
            : "Loading More Items ..."),
      ),
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
        AppTranslation.translationsKeys[langu_choos.value]['Earned Points'],
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildList(_convertedSnackbar) {
    if (_isInitial && _list.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 10, item_height: 100.0));
    } else if (_list.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _list.length,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(0.0),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return buildItemCard(index, _convertedSnackbar);
          },
        ),
      );
    } else if (_totalData == 0) {

      return Center(child: Text(AppTranslation
          .translationsKeys[langu_choos.value]
      ['No data is available']));
    } else {
      return Container(); // should never be happening
    }
  }

  buildItemCard(index, _convertedSnackbar) {
    return Card(
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: MyTheme.medium_grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      child: Text(
                        _list[index].invoice??"",
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                  ],
                )),
            Container(width: 20,),
            Container(
              //  width: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _list[index].date,
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    /*Text(
                      "Converted?",
                      style: TextStyle(
                        color: MyTheme.dark_grey,
                      ),
                    ),
                    Text(
                      _list[index].convert_status == 1 ||
                              _converted_ids.contains(_list[index].id)
                          ? "Yes"
                          : "No",
                      style: TextStyle(
                        color: _list[index].convert_status == 1
                            ? Colors.green
                            : Colors.blue,
                      ),
                    ),*/
                  ],
                )),
            Container(width: 20,),
            Container(
             //   width: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _list[index].points.toString() +
                          AppTranslation.translationsKeys[langu_choos.value]
                              ['Points'],
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    /*_list[index].convert_status == 1 ||
                            _converted_ids.contains(_list[index].id)
                        ? Text(
                            "DONE",
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          )
                        : SizedBox(
                            height: 24,
                            width: 80,
                            child: FlatButton(
                              color: MyTheme.accent_color,
                              child: Text(
                                "Convert",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                onPressConvert(
                                    _list[index].id, _convertedSnackbar);
                              },
                            ),
                          ),*/
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
