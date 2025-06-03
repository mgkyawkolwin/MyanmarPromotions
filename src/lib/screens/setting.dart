// System libraries
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// My libraries
import '/http_service.dart';
import '/components/bottom_bar.dart';

//ignore: use_key_in_widget_constructors
class Setting extends StatefulWidget {

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  final HttpService httpService = HttpService();
  String lang = 'en';


  @override
  void initState()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text("setting".tr),
          backgroundColor: Colors.amberAccent,
          foregroundColor: Colors.black,
          shadowColor: Colors.transparent,
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 4.0),
              child: Row(
                children: [
                  Row(
                    children: [
                      const Text("EN"),
                      IconButton(
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
                          icon: Icon(lang == "en" ? Icons.toggle_off : Icons.toggle_on, size: 36.0)),
                      const Text("MM"),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomBar(routeName: 'setting',),
      ),
    );
  }
}
