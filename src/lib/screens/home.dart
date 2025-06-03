import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '/http_service.dart';
import '/admod.dart';
import '/ad_helper.dart';
import '/library/CommonAppData.dart';
import '/library/CommonThemeData.dart';

Future<InitializationStatus> _initGoogleMobileAds() {
  // TODO: Initialize Google Mobile Ads SDK
  return MobileAds.instance.initialize();
}

//ignore: use_key_in_widget_constructors
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HttpService httpService = HttpService();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List post = [];
  List categories = [];
  String nextPageUrl = "";
  String lang = "en";
  int selectedCategory = -1;

  config() async {
    getAllData();
  }

  getAllCategories() async {
    httpService.get(url: "categories").then((cat) {
      if (mounted) {
        setState(() {
          categories = cat;
        });
      }
    });
  }

  getAllPosts() async {
    if(selectedCategory < 0) {
      httpService.get(url: "getPosts" + (CommonAppData.isAuth ? '?user_name=' +  CommonAppData.userName: '')).then((result) {

        if(result['data'].isNotEmpty){
          post = result['data'];
          for(int x=0;x< post.length;x++){
            post[x]['enable'] = true;
          }
          if (mounted) {
            setState(() {
              post = post;
            });
          }
          _refreshController.loadComplete();
        }
        else{
          _refreshController.loadNoData();
        }
        if (result['next_page_url'] != null) {
          nextPageUrl = result['next_page_url'];
        }
        else {
          nextPageUrl = "";
        }
      });
    }
    else{
        httpService.get(url: "post-by-category-id/" + categories[selectedCategory]['id'].toString()).then((result) {
          if(result['data'].isNotEmpty){
            post = result['data'];
            for(int x=0;x< post.length;x++){
              post[x]['enable'] = true;
            }
            if (mounted) {
              setState(() {
                post = post;
              });

            }
          _refreshController.loadComplete();
        }else{
            _refreshController.loadNoData();
          }
        if (result['next_page_url'] != null) {
          nextPageUrl = result['next_page_url'];
        }
        else{
          nextPageUrl = "";
        }
      });
    }
  }

  getAllData() async {
    getAllCategories();
    getAllPosts();
  }

  void _onRefresh() async {
    setState(() {
      post = [];
    });
    await getAllData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    if (nextPageUrl.isNotEmpty) {
      httpService.getRequest(url: nextPageUrl + (CommonAppData.isAuth ? '&user_name=' + CommonAppData.userName: '')).then((newPost) {
        if (newPost['data'].isNotEmpty) {
          for(int x=0;x< newPost['data'].length;x++){
            newPost['data'][x]['enable'] = true;
          }
          if (mounted) {
            setState(() {
              post.addAll(newPost['data']);
            });
          }
          if (newPost['next_page_url'] != null) {
            nextPageUrl = newPost['next_page_url'];
          } else {
            nextPageUrl = "";
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
  void initState() {
    super.initState();
    _initGoogleMobileAds();
    config();

    //add reward point for viewing detail
    httpService.post(url: "addAppOpenPoints", body: {
      'user_name': CommonAppData.userName,
      'points': '5',
    }).then((result) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 210, 210, 210),
        appBar: AppBar(
          backgroundColor: CommonThemeData.AppBarBackgroundColor,
          shadowColor: Colors.transparent,
          foregroundColor: CommonThemeData.AppBarForegroundColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                  const Text("EN", style: TextStyle(fontSize: 18),),
                  IconButton(
                    iconSize: 40,
                    alignment: Alignment.bottomCenter,
                      onPressed: () {
                        if (lang == "mm") {
                          Get.updateLocale(const Locale('en', 'US'));
                          setState(() {
                            lang = "en";
                          });
                        } else {
                          Get.updateLocale(const Locale('mm', 'MM'));
                          setState(() {
                            lang = "mm";
                          });
                        }
                      },
                      icon: Icon(lang == "en" ? Icons.toggle_off : Icons.toggle_on, )),

                  const Text("MM", style: TextStyle(fontSize: 18),),
                ],
              ),
            ),
            ButtonTheme(
              padding: EdgeInsets.zero,
              child: ElevatedButton(
                clipBehavior: Clip.none,
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all<CircleBorder>(
                      const CircleBorder(
                          side: BorderSide.none
                      )
                  )
                ),
                onPressed: (){
                  checkLogIn();
                },
                child: Image.asset("assets/images/new_user.png", width: 50, height: 50,),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: Container(
            color: Colors.black,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      post = [];
                      selectedCategory = -1;
                      nextPageUrl = "";
                    });
                    getAllPosts();
                  },
                  title: Text("all".tr, style: const TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18.0, color: Colors.white),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, int index) {
                        return ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {
                              post = [];
                              selectedCategory = index;
                            });
                            getAllPosts();
                          },
                          title: Text(
                            "appLanguage".tr == "en" ? categories[index]['name_en'] : categories[index]['name_mm'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18.0, color: Colors.white),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SmartRefresher(
                key: const Key('mainrefresher'),
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.builder(
                        key: const Key('main'),
                        itemCount: post.length,
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
                                        child:Text(post[index]['title'] ?? '', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                                        color: Colors.white,height: 50,
                                        alignment: Alignment.center),
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed("detail", arguments: {
                                          'image': post[index]['image'],
                                          'hash_image_file': post[index]['hash_image_file'],
                                          'description': post[index]['description'],
                                          'display_name': post[index]['display_name'],
                                          'start_date': post[index]['start_date'],
                                          'end_date': post[index]['end_date'],
                                          'title': post[index]['title'],
                                          'isFav': post[index]['isFav'],
                                          'city_name_en': post[index]['city_name_en'],
                                          'city_name_mm': post[index]['city_name_mm'],
                                        });
                                      },
                                      child: Image.network(basedImageUrl + post[index]['image']),
                                    ),
                                    Container(
                                        color: Colors.white,
                                        height: 40,
                                        child:Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(post[index]['start_date'] == null ? '' : '  ' + post[index]['start_date'] + '  -  ' + post[index]['end_date']),
                                            Text(post[index]['city_name_en'] == null ? '' : ('appLanguage'.tr == 'en' ? post[index]['city_name_en'] : post[index]['city_name_mm'])),
                                            IconButton(icon: Icon(post[index]['isFav'] == 0? Icons.favorite_border: Icons.favorite),
                                              enableFeedback: post[index]['enable'],
                                              onPressed: (){
                                                if(CommonAppData.isAuth)
                                                {
                                                  setState((){
                                                    post[index]['enable'] = false;
                                                    if(post[index]['isFav'] == 1){
                                                      post[index]['isFav'] = 0;
                                                    }else{
                                                      post[index]['isFav'] = 1;
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
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(CommonAppData.isAuth) {
              Get.toNamed('add_post');
            }else{
              Get.toNamed('login');
            }
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void setFavIcon(int index) async{
    if(CommonAppData.isAuth){
      httpService.post(url: "toggleFavorite", body: {
        "user_id": CommonAppData.userID,
        "post_id": post[index]['post_id'].toString(),
      }).then((result) {
        if(result['status'] == true){
          setState((){
            //fav icon state is already changed immediately after user click
            //only change back to previous state if failed
            if(result['status'] == false){
              if(post[index]['isFav'] == 1){
                post[index]['isFav'] = 0;
              }else{
                post[index]['isFav'] = 1;
              }
            }
            post[index]['enable'] = true;
          });
        }
      });
    }
    else{
      Get.toNamed('LogIn');
    }
  }

  checkLogIn() async {
    if(CommonAppData.isAuth){
      Get.toNamed('profile', arguments: {'image': basedImageUrl +  CommonAppData.image});
    }else{
      Get.toNamed('login');
    }
  }
}
