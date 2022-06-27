import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../screens/main.dart';
import '../screens/profile.dart';
import '../screens/order_list.dart';
import '../screens/wishlist.dart';
import '../screens/login.dart';
import '../screens/messenger_list.dart';
import '../screens/wallet.dart';
import '../helpers/shared_value_helper.dart';
import '../app_config.dart';
import '../helpers/auth_helper.dart';
import '../helpers/translation.dart';
import '../screens/category_list.dart';
import '../screens/cart.dart';
import '../my_theme.dart';


class MainDrawer extends StatefulWidget {
  const MainDrawer({
    Key key,
  }) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  onTapLogout(context) async {
    AuthHelper().clearUserData();
    /*
    var logoutResponse = await AuthRepository()
            .getLogoutResponse();


    if(logoutResponse.result == true){
         ToastComponent.showDialog(logoutResponse.message, context,
                   gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
         }
         */
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Login();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      child: Drawer(
        child: Container(
          padding: EdgeInsets.only(top: 100),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                is_logged_in.value == true
                    ? ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        AppConfig.BASE_PATH + "${avatar_original.value}",
                      ),
                    ),
                    title: Text("${user_name.value}"),
                    subtitle:
                    user_email.value != "" && user_email.value != null
                        ? Text("${user_email.value}")
                        : Text("${user_phone.value}"))
                    : Text(AppTranslation.translationsKeys[langu_choos.value]['not logged in'],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14)),
                Divider(),
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/home.png",
                        height: 16, color: MyTheme.golden),
                    title: Text(AppTranslation.translationsKeys[langu_choos.value]['home'],
                        style: TextStyle(
                            color:Colors.black,
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return Main();
                          }));
                    }),
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/categories.png",
                        height: 16, color: MyTheme.golden),
                    title: Text(AppTranslation.translationsKeys[langu_choos.value]['categories'],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return CategoryList(
                              is_base_category: true,
                            );
                          }));
                    }),
                is_logged_in.value == true
                    ? ListTile(
                    visualDensity:
                    VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/cart.png",
                        height: 16, color: MyTheme.golden),
                    title: Text(AppTranslation.translationsKeys[langu_choos.value]['cart'],
                        style: TextStyle(
                            color:Colors.black,
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return Cart(has_bottomnav: false);
                          }));
                    })
                    : Container(),
                is_logged_in.value == true
                    ? ListTile(
                    visualDensity:
                    VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/heart.png",
                        height: 16, color: MyTheme.golden),
                    title: Text(AppTranslation.translationsKeys[langu_choos.value]['my wishlist'],
                        style: TextStyle(
                            color:Colors.black,
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return Wishlist();
                          }));
                    })
                    : Container(),
                is_logged_in.value == true
                    ? ListTile(
                    visualDensity:
                    VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/order.png",
                        height: 16, color: MyTheme.golden),
                    title: Text(AppTranslation.translationsKeys[langu_choos.value]['orders'],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return OrderList(from_checkout: false);
                          }));
                    })
                    : Container(),
                is_logged_in.value == true
                    ? ListTile(
                    visualDensity:
                    VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/chat.png",
                        height: 16, color: MyTheme.golden),
                    title: Text(AppTranslation.translationsKeys[langu_choos.value]['messages'],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return MessengerList();
                          }));
                    })
                    : Container(),
                is_logged_in.value == true
                    ? ListTile(
                    visualDensity:
                    VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/wallet.png",
                        height: 16, color: MyTheme.golden),
                    title: Text(AppTranslation.translationsKeys[langu_choos.value]['wallet'],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return Wallet();
                          }));
                    })
                    : Container(),
                is_logged_in.value == true
                    ? ListTile(
                    visualDensity:
                    VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/profile.png",
                        height: 16, color: MyTheme.golden),
                    title: Text(AppTranslation.translationsKeys[langu_choos.value]['profile'],
                        style: TextStyle(
                            color:Colors.black,
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return Profile(show_back_button: true);
                          }));
                    })
                    : Container(),

                Divider(height: 24),
                is_logged_in.value == false
                    ? ListTile(
                    visualDensity:
                    VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/login.png",
                        height: 16, color: MyTheme.golden),
                    title: Text(AppTranslation.translationsKeys[langu_choos.value]['login'],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return Login();
                          }));
                    })
                    : Container(),
                is_logged_in.value == true
                    ? ListTile(
                    visualDensity:
                    VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/logout.png",
                        height: 16, color: MyTheme.golden),
                    title: Text(AppTranslation.translationsKeys[langu_choos.value]['logout'],
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 14)),
                    onTap: () {
                      onTapLogout(context);
                    })
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
