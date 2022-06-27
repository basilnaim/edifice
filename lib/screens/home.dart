import 'package:gamedif/repositories/change_currency.dart';
import 'dart:convert';
import '../my_theme.dart';
import '../screens/filter.dart';
import '../screens/flash_deal_list.dart';
import '../screens/todays_deal_products.dart';
import '../screens/top_selling_products.dart';
import '../screens/category_products.dart';
import '../screens/category_list.dart';
import '../ui_sections/drawer.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../repositories/sliders_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/product_repository.dart';
import '../repositories/banners_repository.dart';
import '../app_config.dart';
import 'package:shimmer/shimmer.dart';
import '../screens/cart.dart';
import '../ui_elements/product_card.dart';
import '../helpers/shimmer_helper.dart';
import '../helpers/translation.dart';
import '../helpers/shared_value_helper.dart';
import '../repositories/cart_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title, this.show_back_button = false}) : super(key: key);

  final String title;
  bool show_back_button;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _current_slider = 0;
  ScrollController _featuredProductScrollController;
  ScrollController _mainScrollController = ScrollController();

  AnimationController pirated_logo_controller;
  Animation pirated_logo_animation;

  var _carouselImageList = [];
  var _featuredCategoryList = [];
  var _BannerList = [];
  var _featuredProductList = [];
  bool _isProductInitial = true;
  bool _isCategoryInitial = true;
  bool _isBannerInitial = true;
  bool _isCarouselInitial = true;
  int _totalProductData = 0;
  int _productPage = 1;
  int cntcart = 0;
  bool _showProductLoadingContainer = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // In initState()
    if (AppConfig.purchase_code == "") {
      initPiratedAnimation();
    }

    // fetchAll();
    getcountries();

    _mainScrollController.addListener(() {
      //print("position: " + _xcrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());
      if (_mainScrollController.position.pixels ==
          _mainScrollController.position.maxScrollExtent) {
        setState(() {
          _productPage++;
        });
        _showProductLoadingContainer = true;
        fetchFeaturedProducts();
      }
    });
  }

  fetchAll() {
    fetchcntcart();
    fetchsetting();
    fetchCarouselImages();
    fetchFeaturedCategories();
    fetchFeaturedProducts();
    fetchBanners();
  }

  fetchsetting() async {
    try {
      await get("${AppConfig.BASE_URL}/business-settings")
          .then((String result) {
        Map map = jsonDecode(result);
        List lstcv = [];
        lstcv = map["data"];
        print(lstcv);
        print('tiiiit');
        String emver = "0", phver = "0";
        for (int i = 0; i < lstcv.length; i++) {
          if (lstcv[i]['type'] == 'border_product_color') {
            print(lstcv[i]['value']);
            final Color color = HexColor(lstcv[i]['value']);
            getxc.changeBorder(color);
          }
          if (lstcv[i]['type'] == 'email_verification') {
            print('koko');
            print(lstcv[i]['value']);
            emver = lstcv[i]['value'];
          }
          if (lstcv[i]['type'] == 'verifiy_by_mobile') {
            print('koko1');
            print(lstcv[i]['value']);
            phver = lstcv[i]['value'];
          }
        }

        if (phver == '1') {
          reg_by.value = "phone";
        } else if (emver == '1') {
          reg_by.value = "email";
        } else {
          reg_by.value = "";
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  List lstcurr = [];
  changecurr(String curr) async {
    var responschange =
        await ChangeCurrencyRepository().PostChangeCurrResponse(curr);
    Map map = jsonDecode(responschange);
    print(map);
    //  List lstcv = [];
    // lstcv = map["data"];
    //  print(lstcv);
    print('bobo');
    fetchAll();
  }

  List lstcountry = [];
  getcountries() async {
    var responschange =
        await ChangeCurrencyRepository().getChangeCurrResponse();
    Map map = jsonDecode(responschange);
    print(map);
    lstcountry = map["data"];
    print(lstcountry);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currv =
        await prefs.get("curr").replaceAll('"', '').replaceAll("\\\\", "");
    print(currv);
    curr.value = currv;
    print(curr.value);
    // print(curr);
    changecurr(currv);
    //  print(lstcountry[0]['currency']);
    print('wwww');
    // fetchAll();
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

  Future<void> _showOptionsMenu(List lst) async {
    List<PopupMenuItem<dynamic>> lstpopup = [];
    for (int i = 0; i < lst.length; i++) {
      lstpopup.add(PopupMenuItem(
        value: i,
        child: Row(
          children: [
            //   Icon(Icons.edit),
            Text(lst[i]['name'] + " " + lst[i]['currency']),
          ],
        ),
      ));
    }
    var selected = await showMenu(
      position: RelativeRect.fromLTRB(60.0, 40.0, 100.0, 100.0),
      context: context,
      items: lstpopup,
    );
    print(lst[selected]['currency']);
  }
  // final List<PopupMenuItem<String>>_popUpmenuitem=lstcurr

  fetchcntcart() async {
    var cartResponseList =
        await CartRepository().getCartResponseList(user_id.value);
    cntcart = cartResponseList.length;
  }

  fetchCarouselImages() async {
    var carouselResponse = await SlidersRepository().getSliders();
    carouselResponse.sliders.forEach((slider) {
      _carouselImageList.add(slider.photo);
    });
    _isCarouselInitial = false;
    setState(() {});
  }

  fetchFeaturedCategories() async {
    var categoryResponse = await CategoryRepository().getFeturedCategories();
    _featuredCategoryList.addAll(categoryResponse.categories);
    _isCategoryInitial = false;
    setState(() {});
  }

  fetchBanners() async {
    var bannersResponse = await BannerRepository().getBanners();
    _BannerList.addAll(bannersResponse.banners);
    _isBannerInitial = false;
    setState(() {});
  }

  fetchFeaturedProducts() async {
    //var productResponse = await ProductRepository().getFeaturedProducts();
    var productResponse = await ProductRepository().getFeaturedProducts(
      page: _productPage,
    );
    _featuredProductList.addAll(productResponse.products);
    _isProductInitial = false;
    _totalProductData = productResponse.meta.total;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  reset() {
    _carouselImageList.clear();
    _featuredCategoryList.clear();
    _BannerList.clear();
    _isCarouselInitial = true;
    _isCategoryInitial = true;
    _isBannerInitial = true;
    setState(() {});
    resetProductList();
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAll();
  }

  resetProductList() {
    _featuredProductList.clear();
    _isProductInitial = true;
    _totalProductData = 0;
    _productPage = 1;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  initPiratedAnimation() {
    pirated_logo_controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    pirated_logo_animation = Tween(begin: 40.0, end: 60.0).animate(
        CurvedAnimation(
            curve: Curves.bounceOut, parent: pirated_logo_controller));

    pirated_logo_controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        pirated_logo_controller.repeat();
      }
    });

    pirated_logo_controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pirated_logo_controller?.dispose();
    _mainScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    //print(MediaQuery.of(context).viewPadding.top);

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: buildAppBar(statusBarHeight, context),
        drawer: MainDrawer(),
        body: Column(
          children: [
            buildHomeSearchBox(context),
            Expanded(
                child: Stack(
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
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                              padding: const EdgeInsets.fromLTRB(
                                8.0,
                                0.0,
                                8.0,
                                0.0,
                              ),
                              child: buildHomeCarouselSlider(context)),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              8.0,
                              5.0,
                              8.0,
                              0.0,
                            ),
                            child: buildHomeMenuRow(context),
                          ),
                        ]),
                      ),
                      /*SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              16.0,
                              1.0,
                              8.0,
                              5.0,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppTranslation
                                          .translationsKeys[langu_choos.value]
                                      ['featured categories'],
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Cairo',
                                      color: MyTheme.font_grey),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward,
                                    color: MyTheme.dark_grey)
                              ],
                            ),
                          ),
                        ]),
                      ),*/
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            8.0,
                            0.0,
                            8.0,
                            0.0,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 105,
                                child: buildHomeFeaturedCategories(context),
                              ),
                              /*_featuredCategoryList.length > 0
                                    ? LinearPercentIndicator(
                                        animation: false,
                                        addAutomaticKeepAlive: true,
                                        lineHeight: 3.0,
                                        //  animationDuration: 500,
                                        percent: 0.5,
                                        isRTL: true,
                                        animateFromLastPercent: true,
                                        linearStrokeCap:
                                            LinearStrokeCap.roundAll,
                                        progressColor: Colors.blue[800],
                                      )
                                    : Container()*/

                              /*SizedBox(
                                height: _BannerList.length == 0 ? 0 : 60,
                                child: buildHomeBanner(context),
                              )*/
                            ],
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    4.0,
                                    0.0,
                                    8.0,
                                    0.0,
                                  ),
                                  child: buildHomeBanner(context),
                                ),
                              ],
                            ),
                          ),
                          /*Container(
                            height: 80,
                          )*/
                        ]),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              16.0,
                              8.0,
                              8.0,
                              0.0,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppTranslation
                                          .translationsKeys[langu_choos.value]
                                      ['featured products'],
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Cairo',
                                      color: MyTheme.font_grey),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_downward,
                                    color: MyTheme.dark_grey)
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    4.0,
                                    0.0,
                                    8.0,
                                    0.0,
                                  ),
                                  child: buildHomeFeaturedProducts(context),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 80,
                          )
                        ]),
                      ),
                    ],
                  ),
                )
                /*Align(
                alignment: Alignment.center,
                child: buildProductLoadingContainer())*/
              ],
            ))
          ],
        ));
  }

  buildHomeFeaturedCategories(context) {
    if (_isCategoryInitial && _featuredCategoryList.length == 0) {
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
        ],
      );
    } else if (_featuredCategoryList.length > 0) {
      //snapshot.hasData
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _featuredCategoryList.length,
          itemExtent: 62,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CategoryProducts(
                      category_id: _featuredCategoryList[index].id,
                      category_name: _featuredCategoryList[index].name,
                    );
                  }));
                },
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    // side: new BorderSide(color: getxc.border, width: 1.0),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 0.0,
                  child: SingleChildScrollView(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: 60,
                          height: 60,
                          child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                  bottom: Radius.zero),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder.png',
                                image: AppConfig.BASE_PATH +
                                    _featuredCategoryList[index].banner,
                                fit: BoxFit.cover,
                              ))),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          //height: 60,
                          child: Text(
                            _featuredCategoryList[index].name,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 11, color: MyTheme.font_grey),
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            );
          });
    } else if (!_isCategoryInitial && _featuredCategoryList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            "No category found",
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

  buildHomeFeaturedProducts(context) {
    if (_isProductInitial && _featuredProductList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper().buildProductGridShimmer(
              scontroller: _featuredProductScrollController));
    } else if (_featuredProductList.length > 0) {
      //snapshot.hasData
      //  print('koko');
      //print(_productPage);
      return GridView.builder(
        // 2
        //addAutomaticKeepAlives: true,
        itemCount: _featuredProductList.length,
        controller: _featuredProductScrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75),
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          // 3
          return ProductCard(
            id: _featuredProductList[index].id,
            image: _featuredProductList[index].thumbnail_image,
            name: _featuredProductList[index].name,
            main_price: _featuredProductList[index].main_price ?? "",
            stroked_price: _featuredProductList[index].stroked_price ?? "",
            has_discount: _featuredProductList[index].has_discount ?? false,
            withrating: true,
            rating: _featuredProductList[index].rating,
            earn_point: _featuredProductList[index].earn_point,
            discount: _featuredProductList[index].discount,
            custom_text: _featuredProductList[index].custom_text ?? "",
            tax_msg: _featuredProductList[index].tax_msg ?? "",
          );
        },
      );
    } else if (_totalProductData == 0) {

      return Center(child: Text(AppTranslation
          .translationsKeys[langu_choos.value]
      ['No product is available']));
    } else {
      return Container(); // should never be happening
    }
  }

  buildHomeBanner(context) {
    if (_isBannerInitial && _BannerList.length == 0) {
      return Container();
    } else if (_BannerList.length > 0) {
      //snapshot.hasData
      return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _BannerList.length,
          itemExtent: 90,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16), bottom: Radius.zero),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.png',
                          image: _BannerList[index].photo,
                          fit: BoxFit.fill,
                        ))),
              ),
            );
          });
    } else if (!_isBannerInitial && _BannerList.length == 0) {
      return Container();
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

  buildHomeMenuRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CategoryList(
                is_top_category: true,
              );
            }));
          },
          child: Container(
            height: 90,
            width: MediaQuery.of(context).size.width / 5 - 4,
            child: Column(
              children: [
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: getxc.border, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/top_categories.png"),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Text(
                    AppTranslation.translationsKeys[langu_choos.value]
                        ['top categories'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                  ),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            print('koko');
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Filter(
                selected_filter: "brands",
              );
            }));
          },
          child: Container(
            height: 90,
            width: MediaQuery.of(context).size.width / 5 - 4,
            child: Column(
              children: [
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: getxc.border, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/brands.png"),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Text(
                        AppTranslation.translationsKeys[langu_choos.value]
                            ['Brands'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.w300))),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TopSellingProducts();
            }));
          },
          child: Container(
            height: 90,
            width: MediaQuery.of(context).size.width / 5 - 4,
            child: Column(
              children: [
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: getxc.border, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/top_sellers.png"),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Text(
                        AppTranslation.translationsKeys[langu_choos.value]
                            ['Top Sellers'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.w300))),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TodaysDealProducts();
            }));
          },
          child: Container(
            height: 90,
            width: MediaQuery.of(context).size.width / 5 - 4,
            child: Column(
              children: [
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: getxc.border, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/todays_deal.png"),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Text(
                        AppTranslation.translationsKeys[langu_choos.value]
                            ['Todays Deal'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.w300))),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FlashDealList();
            }));
          },
          child: Container(
            height: 90,
            width: MediaQuery.of(context).size.width / 5 - 4,
            child: Column(
              children: [
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: getxc.border, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/flash_deal.png"),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Text(
                        AppTranslation.translationsKeys[langu_choos.value]
                            ['Flash Deal'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.w300))),
              ],
            ),
          ),
        )
      ],
    );
  }

  buildHomeCarouselSlider(context) {
    if (_isCarouselInitial && _carouselImageList.length == 0) {
      return Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: Shimmer.fromColors(
          baseColor: MyTheme.shimmer_base,
          highlightColor: MyTheme.shimmer_highlighted,
          child: Container(
            height: 100,
            width: double.infinity,
            color: Colors.white,
          ),
        ),
      );
    } else if (_carouselImageList.length > 0) {
      return Container(
        height: 110,
        child: CarouselSlider(
          options: CarouselOptions(
              aspectRatio: 2.67,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              autoPlayCurve: Curves.easeInCubic,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  _current_slider = index;
                });
              }),
          items: _carouselImageList.map((i) {
            //  print('koko');
            // print(AppConfig.BASE_PATH + i);
            return Builder(
              builder: (BuildContext context) {
                return Stack(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/placeholder_rectangle.png',
                              image: AppConfig.BASE_PATH + i,
                              fit: BoxFit.fill,
                            ))),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _carouselImageList.map((url) {
                          int index = _carouselImageList.indexOf(url);
                          return Container(
                            width: 7.0,
                            height: 7.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current_slider == index
                                  ? MyTheme.accent_color
                                  : Color.fromRGBO(112, 112, 112, .3),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            );
          }).toList(),
        ),
      );
    } else if (!_isCarouselInitial && _carouselImageList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            "No carousel image found",
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

  AppBar buildAppBar(double statusBarHeight, BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          _scaffoldKey.currentState.openDrawer();
        },
        child: widget.show_back_button
            ? Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            : Padding(
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
      title: Container(
        height: 40, // +
        // statusBarHeight,// -
        //(MediaQuery.of(context).viewPadding.top > 40 ? 16.0 : 16.0),
        //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
        child: Container(
          child: Padding(
              padding: const EdgeInsets.only(
                  top: 5.0, bottom: 1, right: 12, left: 12),
              // when notification bell will be shown , the right padding will cease to exist.
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Filter();
                  }));
                },
                child: Container(
                  width: double.infinity,
                  // height: 100,
                  child: Image.asset('assets/main.png'),
                ),

                /*Text(AppTranslation.translationsKeys[langu_choos.value]
                      ['Edifice'])*/
              )),
        ),
      ),
      elevation: 0.0,
      titleSpacing: 0,
      actions: <Widget>[
        Container(
          width: 10,
        ),
        Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: MyTheme.light_grey,
              shape: BoxShape.circle,
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Cart(has_bottomnav: true);
                }));
              },
              child: Visibility(
                visible: true,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 12.0),
                      child: Image.asset(
                        'assets/cart.png',
                        height: 16,
                        color: MyTheme.font_grey,
                      ),
                    ),
                    cntcart > 0
                        ? Positioned(
                            top: 1.0,
                            right: 0.0,
                            child: new Stack(
                              children: <Widget>[
                                new Icon(Icons.brightness_1,
                                    size: 18.0, color: Colors.red),
                                new Positioned(
                                  top: 1.0,
                                  right: 5.0,
                                  child: new Text(cntcart.toString(),
                                      style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500)),
                                )
                              ],
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            )),
        Container(
          width: 10,
        ),

        /*Container(
          width: 2,
        ),
        Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: MyTheme.light_grey,
              shape: BoxShape.circle,
            ),
            child: InkWell(
              onTap: () {
                ToastComponent.showDialog("Coming soon", context,
                    gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
              },
              child: Visibility(
                visible: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 12.0),
                  child: Image.asset(
                    'assets/bell.png',
                    height: 16,
                    color: MyTheme.font_grey,
                  ),
                ),
              ),
            )),*/
      ],
    );
  }

  buildHomeSearchBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            const Radius.circular(16.0),
          ),
          color: MyTheme.light_grey,
        ),
        height: 40,
        child: TextField(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Filter();
            }));
          },
          autofocus: false,
          decoration: InputDecoration(
              hintText: AppTranslation.translationsKeys[langu_choos.value]
                  ['Search products'],
              hintStyle: TextStyle(fontSize: 16.0, color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyTheme.light_grey, width: 0.5),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(16.0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1.0),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(16.0),
                ),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              suffixIcon: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.place_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                onTap: () {
                  // popupMenu;
                  //_showOptionsMenu(lstcountry);
                },
              ),
              contentPadding: EdgeInsets.all(0.0)),
        ),
      ),
    );
  }

  Container buildProductLoadingContainer() {
    return Container(
      height: _showProductLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalProductData == _featuredProductList.length
            ? "No More Products"
            : "Loading More Products ..."),
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
