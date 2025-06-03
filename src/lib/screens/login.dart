import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';


import '/library/CommonAppData.dart';
import '/http_service.dart';
import '/components/image_picker.dart';
import 'result_screen.dart';
import '/library/CommonThemeData.dart';

//ignore: use_key_in_widget_constructors
class LogIn extends StatefulWidget {

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final HttpService httpService = HttpService();
  final TextEditingController userName = TextEditingController();
  final TextEditingController password = TextEditingController();
  List categoryList = [];
  List<String> categories = [];
  int? categoryId;
  ImagePicker imagePicker = ImagePicker();
  bool isPick = false;
  bool onLoading = false;
  bool hidePassword = true;

  @override
  void initState()
  {
    super.initState();
  }//initState

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: CommonThemeData.AppBarBackgroundColor,
            foregroundColor: CommonThemeData.AppBarForegroundColor,
            shadowColor: Colors.transparent,
            title: Text("login".tr),
            automaticallyImplyLeading: true),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 50.0, bottom: 4.0),
              child: Image.asset("assets/images/logo.png", width: 150, height: 150) ,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 4.0),
              child: Text( 'user_name'.tr, style: const TextStyle(color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextFormField(
                  controller: userName,
                  keyboardType: TextInputType.name,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 4.0),
              child: Text( 'password'.tr, style: const TextStyle(color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextFormField(
                  controller: password,
                  keyboardType: TextInputType.visiblePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
              )
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: CommonThemeData.ButtonMinimumSize,
                  backgroundColor: CommonThemeData.ButtonBackgroundColor,
                ),
                onPressed: (){
                  if(true){
                    setState((){
                      onLoading = true;
                    });

                    httpService.post(url: "LogIn", body: {
                      'user_name': userName.text,
                      "password": sha256.convert(utf8.encode(password.text)).toString()
                    }).then((value){
                      if(value != null){
                        if(value['status']){
                          Map<String,dynamic> data = value['data'];
                          CommonAppData.isAuth = data['isAuth'] = true;
                          CommonAppData.userID = data['user_id'] = value['data']['user_id'].toString();
                          CommonAppData.userName = data['user_name'] = value['data']['user_name'];
                          CommonAppData.displayName = data['display_name'] = value['data']['display_name'];
                          CommonAppData.phone = data['phone'] = value['data']['phone'];
                          CommonAppData.email = data['email'] = value['data']['email'];
                          CommonAppData.address = data['address'] = value['data']['address'];
                          CommonAppData.image = data['image'] = value['data']['image'];
                          Get.offAndToNamed('profile', arguments: data);
                        }
                        else{
                          Get.to(ResultScreen(status: value['status'], description: value['description'], ofAll: false, to: false, pageName: ''));
                        }
                      }
                    });
                  }
                },
                child: Text('login'.tr),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new InkWell(
                  child: new Text('register'.tr),
                  onTap: (){
                    Get.toNamed('register');
                  },
                ),
                new InkWell(
                  child: new Text('   |   '),
                  onTap: (){
                  },
                ),
                new InkWell(
                  child: new Text('reset_password'.tr),
                  onTap: (){
                    Get.toNamed('resetpassword');
                  },
                ),
              ],
            ),
          ],
        ),

      ),
    );
  }//build
}//state
