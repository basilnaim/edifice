import '../my_theme.dart';
import 'package:flutter/material.dart';
import '../screens/product_details.dart';
import '../app_config.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../helpers/translation.dart';
import '../helpers/shared_value_helper.dart';
import 'package:flutter/widgets.dart';
import '../helpers/home_controller.dart';
import 'package:get/get.dart';

final getxc = Get.put(HomeController());

class ProductCard extends StatefulWidget {
  int id;
  String image;
  String name;
  String main_price;
  String stroked_price;
  bool has_discount;
  bool withrating;
  double rating;
  int earn_point;
  double discount;
  String custom_text;
  String tax_msg;

  ProductCard({
    Key key,
    this.id,
    this.image,
    this.name,
    this.main_price,
    this.stroked_price,
    this.has_discount,
    this.withrating,
    this.rating,
    this.earn_point,
    this.discount,
    this.custom_text,
    this.tax_msg,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final widthsc = MediaQuery.of(context).size.width;
    print(widthsc);
    print('1yyy1');
    //  print((MediaQuery.of(context).size.width - 48 ) / 2);
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(
            id: widget.id,
          );
        }));
      },
      child: Card(
        //clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          side: new BorderSide(color: getxc.border, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
            child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Stack(
                  children: [
                    Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                              // width: double.infinity,
                              //  height: 100,
                              height:
                                  ((MediaQuery.of(context).size.width - 110) /
                                          2) +
                                      2,
                              child: ClipRRect(
                                  clipBehavior: Clip.hardEdge,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10),
                                      bottom: Radius.zero),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/placeholder.png',
                                    image: AppConfig.BASE_PATH + widget.image,
                                    fit: BoxFit.fill,
                                  ))),
                          Container(
                            //height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                                  child: Container(
                                    height: 27,
                                    child: Text(
                                      widget.name,
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: MyTheme.font_grey,
                                          fontSize: 12,
                                          height: 1.2,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                                  child: Text(
                                    widget.main_price + widget.tax_msg,
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: widget.discount > 0
                                            ? Colors.red
                                            : MyTheme.accent_color,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                widget.has_discount
                                    ? Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(8, 0, 8, 0),
                                        child: Text(
                                          widget.stroked_price,
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: MyTheme.accent_color,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    : Container(
                                        height: 20,
                                      ),
                                widget.withrating
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            //width: double.infinity,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: MyTheme
                                                        .softsoft_accent_color,
                                                    width: 0),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                color: MyTheme.white),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2.0,
                                                      vertical: 1.0),
                                              child: Text(
                                                AppTranslation.translationsKeys[
                                                            langu_choos.value]
                                                        ['Club Point'] +
                                                    ":" +
                                                    widget.earn_point
                                                        .toString(),
                                                style: TextStyle(
                                                    color: MyTheme.font_grey,
                                                    fontSize: 10.0),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 10,
                                          ),
                                          RatingBar(
                                            itemSize: 10.0,
                                            ignoreGestures: true,
                                            initialRating: double.parse(
                                                widget.rating.toString()),
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            ratingWidget: RatingWidget(
                                              full: Icon(FontAwesome.star,
                                                  color: Colors.amber),
                                              empty: Icon(FontAwesome.star,
                                                  color: Color.fromRGBO(
                                                      224, 224, 225, 1)),
                                            ),
                                            itemPadding:
                                                EdgeInsets.only(right: 1.0),
                                            onRatingUpdate: (rating) {
                                              //print(rating);
                                            },
                                          ),
                                          //
                                        ],
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ]),
                    widget.discount > 0 ? off(widthsc) : Container(),
                    widget.custom_text.length > 1
                        ? custtxt(widget.custom_text)
                        : Container()
                  ],
                ))),
      ),
    );
  }

  Widget off(var widthsc) {
    return GetBuilder<HomeController>(
        builder: (_) => getxc.lang == 'ar'
            ? Padding(
                child: Positioned(
                  // bottom: 190,
                  // left: 10,
                  child:Card(
                    color: MyTheme.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.only(
                          topLeft: const Radius.circular(50.0),
                          bottomLeft: const Radius.circular(50.0),
                        )),
                    elevation: 1.5,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: MyTheme.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black,
                                blurRadius: 15,
                                offset: Offset(1, 1))
                          ]),
                      child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /*Text(
                        AppTranslation.translationsKeys[langu_choos.value]
                            ['off'],
                        style: TextStyle(color: MyTheme.golden, fontSize: 10.0),
                        textAlign: TextAlign.center,
                      ),*/
                          Card(
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                //  side: new BorderSide(color: MyTheme.accent_color, width: 1.0),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              elevation: 1.5,
                              child: Container(
                                height: 20,
                                width: 20,
                                child: Text(
                                  widget.discount.toInt().toString() + "%",
                                  style: TextStyle(
                                      color: MyTheme.white, fontSize: 10.0),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ) ,
                ),
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              )
            : Padding(
                child: Positioned(
                  //bottom: 190,
                  //  right: 145,
                  child: Card(
                    color: MyTheme.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.only(
                      topRight: const Radius.circular(50.0),
                      bottomRight: const Radius.circular(50.0),
                    )),
                    elevation: 1.5,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: MyTheme.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black,
                                blurRadius: 15,
                                offset: Offset(1, 1))
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          /*Text(
                        AppTranslation.translationsKeys[langu_choos.value]
                            ['off'],
                        style: TextStyle(color: MyTheme.golden, fontSize: 10.0),
                        textAlign: TextAlign.center,
                      ),*/
                          Card(
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                //  side: new BorderSide(color: MyTheme.accent_color, width: 1.0),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              elevation: 1.5,
                              child: Container(
                                height: 20,
                                width: 20,
                                child: Text(
                                  widget.discount.toInt().toString() + "%",
                                  style: TextStyle(
                                      color: MyTheme.white, fontSize: 10.0),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              ));
  }

  Widget custtxt(String custt) {
    return GetBuilder<HomeController>(
      builder: (_) => getxc.lang == 'ar'
          ? Padding(
              child: Positioned(
                /*bottom: 190,
                left: 0.1,*/
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Card(
                      color: MyTheme.accent_color,
                      shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.only(
                        topRight: const Radius.circular(50.0),
                        bottomRight: const Radius.circular(50.0),
                      )),
                      elevation: 1.5,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          8.0,
                          5.0,
                          3.0,
                          5.0,
                        ),
                        child: Text(
                          custt,
                          style:
                              TextStyle(color: MyTheme.white, fontSize: 10.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            )
          : Padding(
              child: Positioned(
                /*bottom: 190,
          right: 1,*/
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Card(
                      color: MyTheme.accent_color,
                      shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.only(
                        topLeft: const Radius.circular(50.0),
                        bottomLeft: const Radius.circular(50.0),
                      )),
                      elevation: 1.5,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          3.0,
                          5.0,
                          8.0,
                          5.0,
                        ),
                        child: Text(
                          custt,
                          style:
                              TextStyle(color: MyTheme.white, fontSize: 10.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            ),
    );
  }
}
