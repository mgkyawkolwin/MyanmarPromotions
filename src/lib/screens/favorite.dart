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
class Favorite extends StatefulWidget {

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {

  final HttpService httpService = HttpService();
  final RefreshController _favRefreshController = RefreshController(initialRefresh: false);
  List favPost = [];
  String nextPageUrl = "";

  getAllPosts() async {
    httpService.post(url: "getFavPostsByUser", body: {
      'user_name': CommonAppData.userName,
    }).then((result) {
      if(result['data'].isNotEmpty){
        if (mounted) {
          setState(() {
            favPost = result['data'];
            if (result['next_page_url'] != null){
              nextPageUrl = result['next_page_url'];
              _favRefreshController.loadComplete();
            }
            else{
              nextPageUrl = "";
            }

          });
        }
        _favRefreshController.loadComplete();
      }else{
        _favRefreshController.loadNoData();
      }
    });
  }

  getAllData() async {
    getAllPosts();
  }

  void _onRefresh() async {
    await getAllData();
    _favRefreshController.refreshCompleted();
  }

  void _onLoading() {
    if (nextPageUrl.isNotEmpty) {
      httpService.postRequest(url: nextPageUrl, body: {
        'user_name': CommonAppData.userName,
      }).then((newPost) {
        if (newPost['data'].isNotEmpty) {
          if (mounted) {
            setState(() {
              favPost.addAll(newPost['data']);
              if (newPost['next_page_url'] != null) {
                nextPageUrl = newPost['next_page_url'];
              }else{
                nextPageUrl = "";
              }
            });
          }
          _favRefreshController.loadComplete();
        } else {
          _favRefreshController.loadNoData();
        }
      });
    } else {
      _favRefreshController.loadNoData();
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
            title: Text("favorite".tr),
          backgroundColor: CommonThemeData.AppBarBackgroundColor,
          foregroundColor: CommonThemeData.AppBarForegroundColor,
          shadowColor: Colors.transparent,
          centerTitle: true,
        ),
        body: SmartRefresher(
          key: const Key('favrefresher'),
          controller: _favRefreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: favPost.isEmpty
              ? const Center(
              child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ))
          )
              : ListView.builder(
              itemCount: favPost.length,
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
                              child:Text(favPost[index]['title'] ?? '', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                              color: Colors.white,height: 50,
                              alignment: Alignment.center),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed("detail", arguments: {
                                'image': favPost[index]['image'],
                                'hash_image_file': favPost[index]['hash_image_file'],
                                'description': favPost[index]['description'],
                                'display_name': favPost[index]['display_name'],
                                'start_date': favPost[index]['start_date'],
                                'end_date': favPost[index]['end_date'],
                                'title': favPost[index]['title'],
                                'isFav': favPost[index]['isFav'],
                                'city_name_en': favPost[index]['city_name_en'],
                                'city_name_mm': favPost[index]['city_name_mm'],
                              });
                            },
                            child: Image.network(basedImageUrl + favPost[index]['image']),
                          ),
                          Container(
                              color: Colors.white,
                              height: 40,
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(favPost[index]['start_date'] == null ? '' : '  ' + favPost[index]['start_date'] + '  -  ' + favPost[index]['end_date']),
                                  Text(favPost[index]['city_name_en'] == null ? '' : ('appLanguage'.tr == 'en' ? favPost[index]['city_name_en'] : favPost[index]['city_name_mm'])),
                                  IconButton(icon: Icon(favPost[index]['isFav'] == 0? Icons.favorite_border: Icons.favorite),
                                    onPressed: (){
                                      if(CommonAppData.isAuth)
                                      {
                                        setState(() {
                                          favPost.removeAt(index);
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
        bottomNavigationBar: BottomBar(routeName: 'favorite',),
      ),
    );
  }

  void setFavIcon(int index) async{
    if(CommonAppData.isAuth){
      httpService.post(url: "removeFavorite", body: {
        "user_id": CommonAppData.userID,
        "post_id": favPost[index]['post_id'].toString(),
      }).then((result) {
        if(result['status'] == false){
          setState((){
            favPost = favPost;
          });
        }
      });
    }
  }

}
