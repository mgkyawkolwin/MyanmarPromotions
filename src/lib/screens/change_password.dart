import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '/http_service.dart';
import '/screens/result_screen.dart';
import '/library/CommonThemeData.dart';
import '/library/CommonAppData.dart';

//ignore: use_key_in_widget_constructors
class ChangePassword extends StatefulWidget {

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final HttpService httpService = HttpService();
  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  bool hidePassword = false;
  bool passwordMatched = false;

  //validation
  bool emailValidated = false;

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
            title: Text("change_password".tr),
            centerTitle: true,
            backgroundColor: CommonThemeData.AppBarBackgroundColor,
            foregroundColor: CommonThemeData.AppBarForegroundColor,
            shadowColor: Colors.transparent,
            automaticallyImplyLeading: true),
        body: ListView(
          children: [

          Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 5.0, bottom: 4.0),
          child: Text( 'current_password'.tr, style: const TextStyle(color: Colors.black),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: TextFormField(
                controller: currentPassword,
                keyboardType: TextInputType.visiblePassword,
                autovalidateMode: AutovalidateMode.always,
                obscureText: hidePassword,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: Icon(hidePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                    )
                ),
                maxLines: 1,

                validator: (value){
                  RegExp regExp = RegExp(
                    r"^[\w0-9@]+$",
                    caseSensitive: false,
                    multiLine: false,
                  );
                  if(!regExp.hasMatch(value.toString())) {
                    return 'Invalid password';
                  }else{
                    return null;
                  }
                }
            ),
          ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 5.0, bottom: 4.0),
              child: Text( 'password'.tr, style: const TextStyle(color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextFormField(
                  controller: password,
                  keyboardType: TextInputType.visiblePassword,
                  autovalidateMode: AutovalidateMode.always,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        icon: Icon(hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                      )
                  ),
                  maxLines: 1,

                  validator: (value){
                    RegExp regExp = RegExp(
                      r"^[\w0-9@]+$",
                      caseSensitive: false,
                      multiLine: false,
                    );
                    if(!regExp.hasMatch(value.toString())) {
                      return 'Invalid password';
                    }else{
                      return null;
                    }
                  }
              ),

            ),Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 5.0, bottom: 4.0),
              child: Text( 'confirm_password'.tr, style: const TextStyle(color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextFormField(
                  controller: confirmPassword,
                  keyboardType: TextInputType.visiblePassword,
                  autovalidateMode: AutovalidateMode.always,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        icon: Icon(hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                      )
                  ),
                  maxLines: 1,

                  validator: (value){
                    RegExp regExp = RegExp(
                      r"^[\w0-9@]+$",
                      caseSensitive: false,
                      multiLine: false,
                    );
                    if(!regExp.hasMatch(value.toString())) {
                      return 'Invalid password';
                    }else if(value.toString() != password.text) {
                      return 'Passwords do not match';
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
                    httpService.post(url: "changePassword", body: {
                      'user_name': CommonAppData.userName,
                      "current_password": sha256.convert(utf8.encode(currentPassword.text)).toString(),
                      "password": sha256.convert(utf8.encode(password.text)).toString(),
                    }).then((value){
                      if(value['status'] == true) {
                        Get.off(ResultScreen(status: value['status'], description: value['description'], ofAll: false, to: false, pageName: ''));
                      }
                      else{
                        Get.to(ResultScreen(status: false, description: value['description'], ofAll: false, to: false, pageName: ''));
                      }


                    });
                  }
                },
                child: Text('change_password'.tr),
              ),
            ),

          ],
        ),

      ),
    );
  }

  bool validateScreen(){

    if(password.text != confirmPassword.text) {
      return false;
    }else if(!RegExp(r'^[\w0-9@]+$', caseSensitive: false).hasMatch(password.text)) {
      return false;
    }else if(!RegExp(r'^[\w0-9@]+$', caseSensitive: false).hasMatch(confirmPassword.text)) {
      return false;
    }else if(!RegExp(r'^[\w0-9@]+$', caseSensitive: false).hasMatch(currentPassword.text)) {
      return false;
    }else{
      return true;
    }
  }

}
