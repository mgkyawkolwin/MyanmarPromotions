import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/http_service.dart';
import '/ad_helper.dart';
import '/admod.dart';
import '/library/CommonThemeData.dart';
import '/library/CommonAppData.dart';

//ignore: use_key_in_widget_constructors
class Detail extends StatefulWidget {

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  var post = Get.arguments;
  final HttpService httpService = HttpService();



  @override
  void initState()
  {
    super.initState();

    //add reward point for viewing detail
    httpService.post(url: "addPoints", body: {
      'user_name': CommonAppData.userName,
      'points': '1',
    }).then((result) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CommonThemeData.AppBarBackgroundColor,
        shadowColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Admod(AdHelper.detailAdUnitId),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: Text(post['title'] ?? '', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: Image.network(basedImageUrl + post['image']),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text(post['start_date'] == null ? '' : '  ' + post['start_date'] + '  -  ' + post['end_date']),
                      Text(post['city_name_en'] == null ? '' : ('appLanguage'.tr == 'en' ? post['city_name_en'] : post['city_name_mm'])),
                      IconButton(icon: Icon(post['isFav'] == 0? Icons.favorite_border: Icons.favorite),
                      onPressed: (){
                      },
                    )
                  ],),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      decoration: ShapeDecoration(color: (post['description'].toString().trim().isEmpty ? Colors.black: Colors.white) , shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      padding: const EdgeInsets.all(16.0),
                      child:Text(post['description'], style: const TextStyle(color: Colors.black))),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
