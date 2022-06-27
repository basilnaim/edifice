import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../my_theme.dart';

class HomeController extends GetxController {
  String  lang='ar' ;
  Color   border=MyTheme.golden;


  void changeLanguage(String s){
    lang=s;
    update();
  }

  void changeBorder(Color s){
    border=s;
    update();
  }
}