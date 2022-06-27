import 'package:flutter/material.dart';
import '../my_theme.dart';
import '../repositories/refund_request_repository.dart';
import '../helpers/shimmer_helper.dart';
import '../helpers/home_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../helpers/translation.dart';
import '../helpers/shared_value_helper.dart';

class RefundRequest extends StatefulWidget {
  @override
  _RefundRequestState createState() => _RefundRequestState();
}

class _RefundRequestState extends State<RefundRequest> {
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

  fetchData() async {
    var refundRequestResponse =
        await RefundRequestRepository().getRefundRequestListResponse(page: _page);
    _list.addAll(refundRequestResponse.refund_requests);
    _isInitial = false;
    _totalData = refundRequestResponse.meta.total;
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

  onPopped(value) async {
     reset();
     fetchData();
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

  scaffold(){
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
                      child: buildList(),
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
        AppTranslation.translationsKeys[langu_choos.value]
        ['Refund Requests'],
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildList() {
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
            return buildItemCard(index);
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

  buildItemCard(index) {
    return Card(
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Container(
                width: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _list[index].date,
                      style: TextStyle(
                        color: MyTheme.dark_grey,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Refund Status",
                      style: TextStyle(
                        color: MyTheme.dark_grey,
                      ),
                    ),
                    Text(
                      _list[index].refund_label,
                      style: TextStyle(
                        color: _list[index].refund_status == 1 ? Colors.green: Colors.blue,
                      ),
                    ),
                  ],
                )),
            Spacer(),
            Container(
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _list[index].order_code,
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      _list[index].product_price,
                      style: TextStyle(
                        color: MyTheme.accent_color,
                      ),
                    ),
                    Text(
                      _list[index].product_name,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: MyTheme.font_grey,
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
