// System libraries
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// My libraries
import '/http_service.dart';
import '/components/drop_down.dart';
import 'result_screen.dart';
import '/components/bottom_bar.dart';
import '/library/appdata.dart';
import '/ad_helper.dart';
import '/admod.dart';
import '/library/CommonThemeData.dart';

//ignore: use_key_in_widget_constructors
class Wallet extends StatefulWidget {

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  final HttpService httpService = HttpService();
  TextEditingController totalPoints = TextEditingController();
  TextEditingController balancePoints = TextEditingController();
  TextEditingController withdrawPoints = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController account = TextEditingController();
  List<String> paymentTypeList = List.filled(0, '', growable: true);
  Map<String, dynamic> appData = {};
  String selectedPaymentMethod = '';
  String balancePointsValue = '';

  Future config() async {
    appData = await AppData.getAppDataAll();
    userName.text = appData['user_name'];
    totalPoints.text = appData['points_total'].toString();
    balancePointsValue = appData['points_balance'].toString();
    balancePoints.text = balancePointsValue;
    setState((){

    });
  }

  @override
  void initState()
  {
    paymentTypeList.add('KBZ Bank');
    paymentTypeList.add('CB Bank');
    paymentTypeList.add('AYA Bank');
    paymentTypeList.add('KBZ Pay');
    paymentTypeList.add('CB Pay');
    paymentTypeList.add('AYA Pay');
    super.initState();
    config();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text("wallet".tr),
          backgroundColor: CommonThemeData.AppBarBackgroundColor,
          foregroundColor: CommonThemeData.AppBarForegroundColor,
          shadowColor: Colors.transparent,
          centerTitle: true,
        ),
        body: ListView(
          children: [

            Admod(AdHelper.walletAdUnitId),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 25.0, bottom: 4.0),
              child: Text( 'user_name'.tr, style: const TextStyle(color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextFormField(
                controller: userName,
                readOnly: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder()
                ),
                maxLines: 1,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 25.0, bottom: 4.0),
              child: Text( 'total_points'.tr, style: const TextStyle(color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextFormField(
                  controller: totalPoints,
                  readOnly: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder()
                  ),
                  maxLines: 1,
              ),
            ),



            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 25.0, bottom: 4.0),
              child: Text( 'balance_points'.tr, style: const TextStyle(color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextFormField(
                  controller: balancePoints,
                  readOnly: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder()
                  ),
                  maxLines: 1,
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0, bottom: 10.0),
              child: Divider(color: Colors.black26, thickness: 2,),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 4.0),
              child: Text( 'payment_method'.tr, style: const TextStyle(color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, ),
              child: dropDown(
                itemList: paymentTypeList,
                labelText: 'select_category'.tr,
                validateText: 'required'.tr,
                helperText: 'completed'.tr,
                onChanged: (value){
                  selectedPaymentMethod = value.toString();
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 25.0, bottom: 4.0),
              child: Text( 'account'.tr, style: const TextStyle(color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextFormField(
                  controller: account,
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.always,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder()
                  ),
                  maxLines: 1,
                  validator: (value){
                    RegExp regExp = RegExp(
                      r"^[0-9]+$",
                      caseSensitive: false,
                      multiLine: false,
                    );
                    if(!regExp.hasMatch(value.toString())) {
                      return 'Invalid account number.';
                    } else {
                      return null;
                    }
                  }
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 25.0, bottom: 4.0),
              child: Text( 'withdraw_points'.tr, style: const TextStyle(color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextFormField(
                  controller: withdrawPoints,
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.always,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder()
                  ),
                  maxLines: 1,
                  validator: (value){
                    RegExp regExp = RegExp(
                      r"^[0-9]+$",
                      caseSensitive: false,
                      multiLine: false,
                    );
                    if(!regExp.hasMatch(value.toString())) {
                      return 'Invalid numbers.';
                    } else {
                      return null;
                    }
                  }
              ),
            ),



            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: CommonThemeData.ButtonBackgroundColor,
                  minimumSize: CommonThemeData.ButtonMinimumSize,
                ),
                onPressed: (){
                  if(validateScreen())
                  {
                    httpService.post(url: "WithdrawPoints", body: {
                      "user_name": userName.text,
                      "points": withdrawPoints.text,
                      "account": account.text,
                      "payment_method": selectedPaymentMethod
                    }).then((value){
                      if(value['status'] == true)
                      {
                        balancePoints.text = value['new_balance'].toString();
                        withdrawPoints.text = '';
                        account.text = '';
                        AppData.setAppDataByKey('points_balance', value['new_balance'].toString());
                      }
                      Get.to(ResultScreen(
                          status: value['status'],
                          description: value['description'],
                          ofAll: false, to: false, pageName: ''), fullscreenDialog: true);

                    });

                  }
                },
                child: Text('withdraw'.tr),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomBar(routeName: 'wallet',),
      ),
    );
  }

  bool validateScreen()
  {
    if(withdrawPoints.text == '') {
      return false;
    }
    if(selectedPaymentMethod == '') {
      return false;
    }
    return true;
  }
}
