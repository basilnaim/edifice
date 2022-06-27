import 'package:flutter/material.dart';
import '../my_theme.dart';
import '../ui_elements/product_card.dart';
import '../repositories/product_repository.dart';
import '../helpers/shimmer_helper.dart';
import '../helpers/translation.dart';
import '../helpers/shared_value_helper.dart';
import '../helpers/home_controller.dart';
import 'package:get/get.dart';

class TopSellingProducts extends StatefulWidget {
  @override
  _TopSellingProductsState createState() => _TopSellingProductsState();
}

class _TopSellingProductsState extends State<TopSellingProducts> {
  ScrollController _scrollController;
  final getxc = Get.put(HomeController());
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
        AppTranslation.translationsKeys[langu_choos.value]
            ['Top Selling Products'],
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildProductList(context) {
    return FutureBuilder(
        future: ProductRepository().getBestSellingProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //snapshot.hasError
            print("product error");
            print(snapshot.error.toString());
            return Container();
          } else if (snapshot.hasData) {
            var productResponse = snapshot.data;
            print(productResponse.toString());
            return SingleChildScrollView(
              child: GridView.builder(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: productResponse.products.length,
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
                      id: productResponse.products[index].id,
                      image: productResponse.products[index].thumbnail_image,
                      name: productResponse.products[index].name,
                      main_price:
                          productResponse.products[index].main_price ?? "",
                      stroked_price:
                          productResponse.products[index].stroked_price ?? "",
                      has_discount:
                          productResponse.products[index].has_discount ?? false,
                      withrating: true,
                      rating: productResponse.products[index].rating,
                      earn_point: productResponse.products[index].earn_point,
                      discount: productResponse.products[index].discount,
                      custom_text:
                          productResponse.products[index].custom_text ?? "",
                      tax_msg: productResponse.products[index].tax_msg ?? "");
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
