//system libraries
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//own libraries
import '../library/appdata.dart';

class BottomBar extends StatefulWidget {
  final String routeName;

  BottomBar({this.routeName = "profile"});

  @override
  _BottomBarState createState() => _BottomBarState(this.routeName);
}

class _BottomBarState extends State<BottomBar> {
  final String routeName;
  _BottomBarState(this.routeName);

  //Map<String, dynamic> appData = {'appLang': 'en', 'contentLang': 'en'};
  // lang[appData['appLang']]['home']

  Future initialize() async{
    //appData = await AppData.getAppData(['appLang', 'contentLang']);
    setState(() {

    });
  }

  @override
  void initState()
  {
    initialize();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(width: 2.0, color: Colors.grey),
        ),
      ),
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              if(routeName != "profile"){
                Get.offNamed('/profile');
              }
            },
            child: Column(
              children: [
                Icon(
                  Icons.account_circle,
                  color: routeName == "profile" ? Colors.red : Colors.redAccent,
                ),
                Text('Profile', style: TextStyle(fontWeight: routeName == "profile" ? FontWeight.bold : FontWeight.normal)), //lang[this.appLang]['home']
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if(routeName != "favorite"){
                Get.offNamed('/favorite');
              }
            },
            child: Column(
              children: [
                Icon(Icons.favorite,
                  color: routeName == "favorite" ? Colors.red : Colors.redAccent,
                ),
                Text('Favorite', style: TextStyle(fontWeight: routeName == "favorite" ? FontWeight.bold : FontWeight.normal)), //lang[this.appLang]['asset']
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if(routeName != "mypromotions"){
                Get.offNamed('/mypromotions');

              }
            },
            child: Column(
              children: [
                Icon(Icons.ad_units,
                  color: routeName == "mypromotions" ? Colors.red : Colors.redAccent,
                ),
                Text('My Promos', style: TextStyle(fontWeight: routeName == "mypromotions" ? FontWeight.bold : FontWeight.normal)), //lang[this.appLang]['news']
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if(routeName != "wallet"){
                Get.offNamed('/wallet');
              }
            },
            child: Column(
              children: [
                Icon(Icons.account_balance_wallet,
                  color: routeName == "wallet" ? Colors.red : Colors.redAccent,
                ),
                Text('Wallet', style: TextStyle(fontWeight: routeName == "wallet" ? FontWeight.bold : FontWeight.normal)), //lang[this.appLang]['wallet']
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              if(routeName != "history"){
                Get.offNamed('/history');
              }
            },
            child: Column(
              children: [
                Icon(Icons.table_chart,
                  color: routeName == "history" ? Colors.red : Colors.redAccent,
                ),
                Text('History', style: TextStyle(fontWeight: routeName == "history" ? FontWeight.bold : FontWeight.normal)), //lang[this.appLang]['wallet']
              ],
            ),
          ),

        ],
      ),
    );
  }
}

