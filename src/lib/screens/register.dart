import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '/http_service.dart';
import '/components/image_picker.dart';
import 'result_screen.dart';
import '/library/CommonThemeData.dart';

//ignore: use_key_in_widget_constructors
class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final HttpService httpService = HttpService();
  final TextEditingController userName = TextEditingController();
  final TextEditingController displayName = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController email = TextEditingController();
  List categoryList = [];
  List<String> categories = [];
  int? categoryId;
  ImagePicker imagePicker = ImagePicker();
  bool isPick = false;
  bool onLoading = false;
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
            title: Text("register".tr),
            backgroundColor: CommonThemeData.AppBarBackgroundColor,
            foregroundColor: CommonThemeData.AppBarForegroundColor,
            shadowColor: Colors.transparent,
            automaticallyImplyLeading: true),
        body: ListView(
          children: [
            Center(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  height: 150,
                  width:150,
                  margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 40.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 0.8)
                  ),
                  child: isPick? Image.file(imagePicker.file, width: 150, height:150) : const Icon(Icons.photo_library_outlined, size: 150)
                )
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black26),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: (){
                  imagePicker.pick().then((value) {
                    setState(() {
                      isPick = imagePicker.isPick;
                    });
                  });
                },
                child: Text('select_image'.tr),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 4.0),
              child: Text( isPick ? '': 'Image is required', style: const TextStyle(color: Colors.red),),
            ),
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
              child: Text( 'display_name'.tr, style: const TextStyle(color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextFormField(
                  controller: displayName,
                  keyboardType: TextInputType.name,
                  autovalidateMode: AutovalidateMode.always,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder()
                  ),
                  maxLines: 1,
                  validator: (value){
                    RegExp regExp = RegExp(
                      r"^[\w ]+$",
                      caseSensitive: false,
                      multiLine: false,
                    );
                    if(!regExp.hasMatch(value.toString())) {
                      return 'Invalid display name.';
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
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 5.0, bottom: 4.0),
              child: Text( 'phone'.tr, style: const TextStyle(color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextFormField(
                  controller: phone,
                  keyboardType: TextInputType.name,
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
                      return 'Invalid phone number.';
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
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 5.0, bottom: 4.0),
              child: Text( 'address'.tr, style: const TextStyle(color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextFormField(
                  controller: address,
                  autovalidateMode: AutovalidateMode.always,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder()
                  ),
                  minLines: 3,
                  maxLines: 5,
                  validator: (value){
                    RegExp regExp = RegExp(
                      r"[^.\r\n$]+$",
                      caseSensitive: false,
                      multiLine: false,
                    );
                    if(!regExp.hasMatch(value.toString())) {
                      return 'Invalid address.';
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
                    httpService.post(url: "SaveNewUser", body: {
                      "user_name": userName.text,
                      "display_name": displayName.text,
                      "password": sha256.convert(utf8.encode(password.text)).toString(),
                      "phone": phone.text,
                      "email": email.text,
                      "address": address.text,
                      "image": imagePicker.toBased64(),
                    }).then((value){
                      if(value['status'] == true) {
                        Get.to(ResultScreen(status: value['status'], description: value['description'], ofAll: true, to: false, pageName: '/login'));
                      }
                      else{
                        Get.to(ResultScreen(status: false, description: value['description'], ofAll: false, to: false, pageName: ''));
                      }


                    });
                  }
                },
                child: Text('register'.tr),
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
    }else if(!RegExp(r"^[\w ]+$", caseSensitive: false).hasMatch(displayName.text)) {
      return false;
    } else if(!RegExp(r'^[0-9]+$', caseSensitive: false).hasMatch(phone.text)) {
      return false;
    }else if(password.text != confirmPassword.text) {
      return false;
    }else if(!RegExp(r'^[\w0-9@]+$', caseSensitive: false).hasMatch(password.text)) {
      return false;
    }else if(!RegExp(r'^[\w0-9@]+$', caseSensitive: false).hasMatch(confirmPassword.text)) {
      return false;
    }else if(email.text != '' && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$', caseSensitive: false).hasMatch(email.text)) {
      return false;
    }else if(!RegExp(r'[^.\r\n$]+$', caseSensitive: false).hasMatch(address.text)) {
      return false;
    }else{
      return true;
    }
  }

}
