import 'package:flutter/material.dart';
import '../my_theme.dart';
import '../ui_elements/product_card.dart';
import '../repositories/product_repository.dart';
import '../helpers/shimmer_helper.dart';
import '../helpers/string_helper.dart';
import 'package:flutter/widgets.dart';
import '../helpers/home_controller.dart';
import 'package:get/get.dart';

class FlashDealProducts extends StatefulWidget {
  FlashDealProducts({Key key, this.flash_deal_id, this.flash_deal_name})
      : super(key: key);
  final int flash_deal_id;
  final String flash_deal_name;

  @override
  _FlashDealProductsState createState() => _FlashDealProductsState();
}

class _FlashDealProductsState extends State<FlashDealProducts> {
  TextEditingController _searchController = new TextEditingController();

  Future<dynamic> _future;

  List<dynamic> _searchList;
  List<dynamic> _fullList;
  ScrollController _scrollController;

  final getxc = Get.put(HomeController());

  @override
  void initState() {
    // TODO: implement initState
    _future =
        ProductRepository().getFlashDealProducts(id: widget.flash_deal_id);
    _searchList = [];
    _fullList = [];
    super.initState();
  }

  _buildSearchList(search_key) async {
    _searchList.clear();
    //  print(_fullList.length);

    if (search_key.isEmpty) {
      _searchList.addAll(_fullList);
      setState(() {});
      //print("_searchList.length on empty " + _searchList.length.toString());
      //print("_fullList.length on empty " + _fullList.length.toString());
    } else {
      for (var i = 0; i < _fullList.length; i++) {
        if (StringHelper().stringContains(_fullList[i].name, search_key)) {
          _searchList.add(_fullList[i]);
          setState(() {});
        }
      }

      //print("_searchList.length with txt " + _searchList.length.toString());
      //print("_fullList.length with txt " + _fullList.length.toString());
    }
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
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          4.0,
          0.0,
          8.0,
          0.0,
        ),
        child: buildProductList(context),
      ),
    );
  }

  bool shouldProductBoxBeVisible(product_name, search_key) {
    if (search_key == "") {
      return true; //do not check if the search key is empty
    }
    return StringHelper().stringContains(product_name, search_key);
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 75,
      /*bottom: PreferredSize(
          child: Container(
            color: MyTheme.textfield_grey,
            height: 1.0,
          ),
          preferredSize: Size.fromHeight(4.0)),*/
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Container(
          width: 250,
          child: TextField(
            controller: _searchController,
            onChanged: (txt) {
              //  print(txt);
              _buildSearchList(txt);
              // print(_searchList.toString());
              // print(_searchList.length);
            },
            onTap: () {},
            autofocus: true,
            decoration: InputDecoration(
                hintText: "Search products from : " + widget.flash_deal_name,
                hintStyle:
                    TextStyle(fontSize: 14.0, color: MyTheme.textfield_grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyTheme.white, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyTheme.white, width: 0.0),
                ),
                contentPadding: EdgeInsets.all(0.0)),
          )),
      elevation: 0.0,
      titleSpacing: 0,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: IconButton(
            icon: Icon(Icons.search, color: MyTheme.dark_grey),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  buildProductList(context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //snapshot.hasError
            //print("product error");
            //print(snapshot.error.toString());
            return Container();
          } else if (snapshot.hasData) {
            var productResponse = snapshot.data;
            if (_fullList.length == 0) {
              _fullList.addAll(productResponse.products);
              _searchList.addAll(productResponse.products);
              //print('xcalled');
            }

            //print('called');

            return SingleChildScrollView(
              child: GridView.builder(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: _searchList.length,
                controller: _scrollController,
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
                      id: _searchList[index].id,
                      image: _searchList[index].thumbnail_image,
                      name: _searchList[index].name,
                      main_price: _searchList[index].main_price,
                      stroked_price: _searchList[index].stroked_price,
                      has_discount: _searchList[index].has_discount,
                      withrating: true,
                      rating: _searchList[index].rating,
                      earn_point: _searchList[index].earn_point,
                      discount: _searchList[index].discount,
                      custom_text: _searchList[index].custom_text ?? "",
                      tax_msg: _searchList[index].tax_msg ?? "");
                },
              ),
            );
          } else {
            return ShimmerHelper()
                .buildProductGridShimmer(scontroller: _scrollController);
          }
        });
  }
}
