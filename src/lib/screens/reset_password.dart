import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '/http_service.dart';
import 'result_screen.dart';
import '/library/CommonThemeData.dart';

//ignore: use_key_in_widget_constructors
class ResetPassword extends StatefulWidget {

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final HttpService httpService = HttpService();
  final TextEditingController userName = TextEditingController();
  final TextEditingController email = TextEditingController();

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
            title: Text("reset_password".tr),
            backgroundColor: CommonThemeData.AppBarBackgroundColor,
            foregroundColor: CommonThemeData.AppBarForegroundColor,
            shadowColor: Colors.transparent,
            automaticallyImplyLeading: true),
        body: ListView(
          children: [

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 4.0),
              child: Text( 'user_name'.tr, style: const TextStyle(color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextFormField(
                  controller: userName,
                  keyboardType: TextInputType.name,
                  autovalidateMode: AutovalidateMode.always,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder()
                  ),
                  maxLines: 1,
                  validator: (value){
                    RegExp regExp = RegExp(
                      r"^\w+$",
                      caseSensitive: false,
                      multiLine: false,
                    );
                    if(!regExp.hasMatch(value.toString())) {
                      return 'Invalid user name.';
                    }else{
                      return null;
                    }
                  }
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 5.0, bottom: 4.0),
              child: Text( 'email'.tr, style: const TextStyle(color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.always,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder()
                  ),
                  maxLines: 1,
                  validator: (value){
                    RegExp regExp = RegExp(
                      r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                      caseSensitive: false,
                      multiLine: false,
                    );
                    if(!regExp.hasMatch(value.toString())) {
                      return 'Invalid email';
                    }else{
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
                    httpService.post(url: "resetPassword", body: {
                      'user_name': userName.text,
                      "email": email.text,
                      'password': base64Encode(utf8.encode(userName.text)),
                      'password_encoded': sha256.convert(utf8.encode(base64Encode(utf8.encode(userName.text)))),
                    }).then((value){
                      if(value['status'] == true) {
                        Get.to(ResultScreen(status: value['status'], description: value['description'], ofAll: false, to: false, pageName: ''));
                      }
                      else{
                        Get.to(ResultScreen(status: false, description: value['description'], ofAll: false, to: false, pageName: ''));
                      }


                    });
                  }
                },
                child: Text('reset_password'.tr),
              ),
            ),

          ],
        ),

      ),
    );
  }

  bool validateScreen(){

    if(!RegExp(r"^\w+$", caseSensitive: false).hasMatch(userName.text)) {
      return false;
    }else if(email.text != '' && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$', caseSensitive: false).hasMatch(email.text)) {
      return false;
    }else{
      return true;
    }
  }

}
