// System libraries
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// My libraries
import '/library/CommonAppData.dart';
import '/http_service.dart';
import '/components/bottom_bar.dart';
import '/admod.dart';
import '/ad_helper.dart';
import '/library/CommonThemeData.dart';

//ignore: use_key_in_widget_constructors
class History extends StatefulWidget {

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  final HttpService httpService = HttpService();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List history = [];
  String nextPageUrl = "";

  getAllPosts() async {
    httpService.post(url: "getPointHistory", body: {
      'user_name': CommonAppData.userName,
    }).then((result) {
      if (mounted) {
        setState(() {
          history = result['data'];
          if (result['next_page_url'] != null){
            nextPageUrl = result['next_page_url'];
            _refreshController.loadComplete();
          }
          else{
            nextPageUrl = "";
          }

        });
      }
    });
  }

  getAllData() async {
    getAllPosts();
  }

  void _onRefresh() async {
    await getAllData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    if (nextPageUrl.isNotEmpty) {
      httpService.postRequest(url: nextPageUrl, body: {
        'user_name': CommonAppData.userName,
      }).then((newPost) {
        if (newPost['data'].isNotEmpty) {
          if (mounted) {
            setState(() {
              history.addAll(newPost['data']);
              if (newPost['next_page_url'] != null){
                nextPageUrl = newPost['next_page_url'];
              }
              else{
                nextPageUrl = "";
              }
            });
          }
          _refreshController.loadComplete();
        } else {
          _refreshController.loadNoData();
        }
      });
    } else {
      _refreshController.loadNoData();
    }
  }


  @override
  void initState()
  {
    getAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 210, 210, 210),
        appBar: AppBar(
          title: Text("history".tr),
          backgroundColor: CommonThemeData.AppBarBackgroundColor,
          foregroundColor: CommonThemeData.AppBarForegroundColor,
          shadowColor: Colors.transparent,
          centerTitle: true,
        ),
        body: SmartRefresher(
          key: const Key('history'),
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: history.isEmpty
              ? const Center(
              child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ))
          )
              : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, int index) {
                //prepare data here
                var date = DateTime.parse(history[index]['created_at']);

                //return widgets
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0),
                  child: Column(children: [

                    (index == 0) ?
                    Padding(padding: const EdgeInsets.only(bottom: 15.0), child: Admod(AdHelper.bannerAdUnitId)) : Text('', style: TextStyle(fontSize: 0)),

                    (index != 0 && index%6 == 0) ?
                    Padding(padding: const EdgeInsets.only(bottom: 15.0), child: (index%12 == 0 ? Admod(AdHelper.bannerAlternateAdUnitId) : Admod(AdHelper.bannerAdUnitId))) : Text('', style: TextStyle(fontSize: 0)),
                    history[index]['transaction'] == 'WITHDRAW' ?
                    Container(
                      height: 100,
                      padding: EdgeInsets.all(9),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5)), border: Border.all(color: Colors.grey)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children:[
                              const Icon(Icons.monetization_on),
                              Text(history[index]['transaction'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),),
                            ]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(history[index]['created_at']),
                              Text('ID: ' + date.year.toString()+date.month.toString()+date.day.toString()+history[index]['id'].toString(),),
                              Text(history[index]['status']),
                            ],),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(history[index]['payment_method']),
                              Text(history[index]['account']),
                              Text(history[index]['points'].toString() + ' Pts', style: TextStyle(fontWeight: FontWeight.bold),),
                          ],),

                        ],
                      ),
                    )
                    : Container(
                      height: 100,
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5)), border: Border.all(color: Colors.grey)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                              children:[
                                const Icon(Icons.volunteer_activism),
                                Text(history[index]['transaction'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),),
                              ]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(history[index]['created_at']),
                              Text(history[index]['points'].toString() + ' Pts', style: TextStyle( fontWeight: FontWeight.bold),),
                            ],),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(history[index]['description']),
                            ],),

                        ],
                      ),
                    )
                  ],),
                );
              }),


        ),
        bottomNavigationBar: BottomBar(routeName: 'history',),
      ),
    );
  }



}
