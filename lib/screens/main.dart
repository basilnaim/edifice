import '../my_theme.dart';
import '../screens/cart.dart';
import '../screens/category_list.dart';
import '../screens/home.dart';
import '../screens/profile.dart';
import '../screens/filter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../helpers/home_controller.dart';


class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  final getxc = Get.put(HomeController());
  int _currentIndex = 0;
  var _children = [
    Home(),
    CategoryList(
      is_base_category: true,
    ),
    Filter(
      selected_filter: "sellers",
    ),
    Cart(has_bottomnav: true),
    Profile()
  ];

  void onTapped(int i) {
    setState(() {
      _currentIndex = i;
    });
  }

  void initState() {
    // TODO: implement initState
    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.initState();
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
     // backgroundColor: Colors.white,
      extendBody: true,
      body: _children[_currentIndex],
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //specify the location of the FAB
      /*floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom ==
            0.0, // if the kyeboard is open then hide, else show
        child: FloatingActionButton(
          backgroundColor: MyTheme.accent_color,
          onPressed: () {},
          tooltip: "start FAB",
          child: Container(
              margin: EdgeInsets.all(0.0),
              child: Transform.scale(scale: 1.5,child: IconButton(
                  icon: new Image.asset('assets/app_logo.png'),
                  tooltip: 'Action',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Filter(
                        selected_filter: "sellers",
                      );
                    }));
                  }),)
          ),
          elevation: 0.0,
        ),
      ),*/
      /*bottomNavigationBar: BottomAppBar(
      //  color: Colors.red,
        clipBehavior: Clip.antiAlias,
        child: Container(child:BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: onTapped,
            currentIndex: _currentIndex,
            backgroundColor: Colors.white,
            fixedColor: Theme.of(context).accentColor,
            unselectedItemColor: Color.fromRGBO(153, 153, 153, 1),
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/home.png",
                    color: _currentIndex == 0
                        ? Theme.of(context).accentColor
                        : MyTheme.font_grey,
                    height: 15,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: GetBuilder<HomeController>(
                        builder: (_) => Text(
                          AppTranslation.translationsKeys[langu_choos.value]
                          ['home'],
                          style: TextStyle(fontSize: 10),
                        )),
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/categories.png",
                    color: _currentIndex == 1
                        ? Theme.of(context).accentColor
                        : MyTheme.font_grey,
                    height: 15,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      AppTranslation.translationsKeys[langu_choos.value]
                      ['categories'],
                      style: TextStyle(fontSize: 10),
                    ),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    color: _currentIndex == 2
                        ? Theme.of(context).accentColor
                        : MyTheme.font_grey,
                    size: 25,
                  ),
                  *//*Image.asset(
                    "assets/app_logo.png",
                    color: _currentIndex == 2
                        ? Theme.of(context).accentColor
                        : Color.fromRGBO(153, 153, 153, 1),
                    height: 20,
                  ),*//*
                  title: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      AppTranslation.translationsKeys[langu_choos.value]
                      ['Search'],
                      style: TextStyle(fontSize: 10),
                    ),
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/cart.png",
                    color: _currentIndex == 3
                        ? Theme.of(context).accentColor
                        : MyTheme.font_grey,
                    height: 15,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      AppTranslation.translationsKeys[langu_choos.value]
                      ['cart'],
                      style: TextStyle(fontSize: 10),
                    ),
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/profile.png",
                    color: _currentIndex == 4
                        ? Theme.of(context).accentColor
                        : MyTheme.font_grey,
                    height: 15,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      AppTranslation.translationsKeys[langu_choos.value]
                      ['profile'],
                      style: TextStyle(fontSize: 10),
                    ),
                  )),
            ],
          ),
        ),),
      ),*/
    );
  }
}
