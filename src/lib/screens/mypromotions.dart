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
class MyPromotions extends StatefulWidget {

  @override
  _MyPromotionsState createState() => _MyPromotionsState();
}

class _MyPromotionsState extends State<MyPromotions> {

  final HttpService httpService = HttpService();
  final RefreshController _myRefreshController = RefreshController(initialRefresh: false);
  List myPost = [];
  String nextPageUrl = "";

  getAllPosts() async {
    httpService.post(url: "getPostsByUser", body: {
      'user_name': CommonAppData.userName,
    }).then((result) {
      if(result['data'].isNotEmpty){
        for(int x=0;x< result['data'].length;x++){
          result['data'][x]['enable'] = true;
        }
        if (mounted) {
          setState(() {
            myPost = result['data'];
            if (result['next_page_url'] != null){
              nextPageUrl = result['next_page_url'];
              _myRefreshController.loadComplete();
            }
            else{
              nextPageUrl = "";
            }

          });
        }
        _myRefreshController.loadComplete();
      }else{
        _myRefreshController.loadNoData();
      }
    });
  }

  getAllData() async {
    getAllPosts();
  }

  void _onRefresh() async {
    setState(() {
      myPost = [];
    });
    await getAllData();
    _myRefreshController.refreshCompleted();
  }

  void _onLoading() {
    if (nextPageUrl.isNotEmpty) {
      httpService.postRequest(url: nextPageUrl, body: {
        'user_name': CommonAppData.userName,
      }).then((newPost) {
        if (newPost['data'].isNotEmpty) {
          for(int x=0;x< newPost['data'].length;x++){
            newPost['data'][x]['enable'] = true;
          }
          if (mounted) {
            setState(() {
              myPost.addAll(newPost['data']);
              if (newPost['next_page_url'] != null) {
                nextPageUrl = newPost['next_page_url'];
              }else{
                nextPageUrl = "";
              }
            });
          }
          _myRefreshController.loadComplete();
        } else {
          _myRefreshController.loadNoData();
        }
      });
    } else {
      _myRefreshController.loadNoData();
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
          title: Text("my_promotions".tr),
          backgroundColor: CommonThemeData.AppBarBackgroundColor,
          foregroundColor: CommonThemeData.AppBarForegroundColor,
          shadowColor: Colors.transparent,
          centerTitle: true,
        ),
        body: SmartRefresher(
          key: const Key('myrefresher'),
          controller: _myRefreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView.builder(
              itemCount: myPost.length,
              // padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              itemBuilder: (context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0),
                  child: Column(children: [
                    (index == 0) ?
                    Padding(padding: const EdgeInsets.only(bottom: 15.0), child: Admod(AdHelper.bannerAdUnitId)) : const Text('', style: TextStyle(fontSize: 0)),

                    (index != 0 && index%6 == 0) ?
                    Padding(padding: const EdgeInsets.only(bottom: 15.0), child: (index%12 == 0 ? Admod(AdHelper.bannerAlternateAdUnitId) : Admod(AdHelper.bannerAdUnitId))) : const Text('', style: TextStyle(fontSize: 0)),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                      child: ListView(
                        key: const Key('promotions'),
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        children: [
                          Container(
                              child:Text(myPost[index]['title'] ?? '', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                              color: Colors.white,height: 50,
                              alignment: Alignment.center),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed("detail", arguments: {
                                'image': myPost[index]['image'],
                                'hash_image_file': myPost[index]['hash_image_file'],
                                'description': myPost[index]['description'],
                                'display_name': myPost[index]['display_name'],
                                'start_date': myPost[index]['start_date'],
                                'end_date': myPost[index]['end_date'],
                                'title': myPost[index]['title'],
                                'isFav': myPost[index]['isFav'],
                                'city_name_en': myPost[index]['city_name_en'],
                                'city_name_mm': myPost[index]['city_name_mm'],
                              });
                            },
                            child: Image.network(basedImageUrl + myPost[index]['image']),
                          ),
                          Container(
                              color: Colors.white,
                              height: 40,
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(myPost[index]['start_date'] == null ? '' : '  ' + myPost[index]['start_date'] + '  -  ' + myPost[index]['end_date']),
                                  Text(myPost[index]['city_name_en'] == null ? '' : ('appLanguage'.tr == 'en' ? myPost[index]['city_name_en'] : myPost[index]['city_name_mm'])),
                                  IconButton(icon: Icon(myPost[index]['isFav'] == 0? Icons.favorite_border: Icons.favorite),
                                    enableFeedback: myPost[index]['enable'],
                                    onPressed: (){
                                      if(CommonAppData.isAuth)
                                      {
                                        setState((){
                                          myPost[index]['enable'] = false;
                                          if(myPost[index]['isFav'] == 1){
                                            myPost[index]['isFav'] = 0;
                                          }else{
                                            myPost[index]['isFav'] = 1;
                                          }
                                        });
                                        setFavIcon(index);
                                      }
                                    },
                                  )
                                ],

                              )),
                        ],
                      ),
                    ),
                  ],),
                );
              }),
          footer: ClassicFooter(
            iconPos: IconPosition.top,
            outerBuilder: (child) {
              return SizedBox(
                width: 80.0,
                child: Center(
                  child: child,
                ),
              );
            },
          ),
          header: ClassicHeader(
            iconPos: IconPosition.top,
            outerBuilder: (child) {
              return SizedBox(
                width: 80.0,
                child: Center(
                  child: child,
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: BottomBar(routeName: 'mypromotions',),
      ),
    );
  }

  void setFavIcon(int index) async{
    if(CommonAppData.isAuth){
      httpService.post(url: "toggleFavorite", body: {
        "user_id": CommonAppData.userID,
        "post_id": myPost[index]['post_id'].toString(),
      }).then((result) {
        if(result['status'] == true){
          setState((){
            //fav icon state is already changed immediately after user click
            //only change back to previous state if failed
            if(result['status'] == false){
              if(myPost[index]['isFav'] == 1){
                myPost[index]['isFav'] = 0;
              }else{
                myPost[index]['isFav'] = 1;
              }
            }
            myPost[index]['enable'] = true;
          });
        }
      });
    }
  }

}
