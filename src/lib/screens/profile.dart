import 'package:flutter/material.dart';
import 'package:get/get.dart';

//own libraries
import '/library/CommonAppData.dart';
import '/http_service.dart';
import '/components/image_picker.dart';
import 'result_screen.dart';
import '/library/appdata.dart';
import '/components/bottom_bar.dart';
import '/ad_helper.dart';
import '/admod.dart';
import '/library/CommonThemeData.dart';

//ignore: use_key_in_widget_constructors
class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var data = Get.arguments;

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

  String image = '';

  //validation
  bool emailValidated = false;


  Future config() async {

  }

  @override
  void initState()
  {
    super.initState();
    image = CommonAppData.image;
    userName.text = CommonAppData.userName;
    displayName.text = CommonAppData.displayName;
    phone.text = CommonAppData.phone;
    email.text = CommonAppData.email;
    address.text = CommonAppData.address;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("profile".tr),
          automaticallyImplyLeading: true,
          backgroundColor: CommonThemeData.AppBarBackgroundColor,
          foregroundColor: CommonThemeData.AppBarForegroundColor,
          shadowColor: Colors.transparent,
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Admod(AdHelper.profileAdUnitId),
            Center(
              child:GestureDetector(
                onTap: (){
                  imagePicker.pick().then((value) {
                    setState(() {
                      isPick = imagePicker.isPick;
                    });
                  });
                },
                child:Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children:[
                  Container(
                      clipBehavior: Clip.hardEdge,
                      height: 150,
                      width:150,
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 0.8)
                      ),
                      child: isPick ? Image.file(imagePicker.file) : Image.network(basedImageUrl + image, width: 150, height: 150)
                  ),
                  ButtonTheme(
                    padding: EdgeInsets.zero,
                    child: ElevatedButton(
                      clipBehavior: Clip.none,
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                          backgroundColor: MaterialStateProperty.all(Colors.grey),
                          shadowColor: MaterialStateProperty.all(Colors.transparent),
                          shape: MaterialStateProperty.all<CircleBorder>(
                              const CircleBorder(
                                  side: BorderSide.none
                              )
                          )
                      ),
                      onPressed: (){
                        imagePicker.pick().then((value) {
                          setState(() {
                            isPick = imagePicker.isPick;
                          });
                        });
                      },
                      child: const Icon(Icons.add_photo_alternate),
                    ),
                  ),
                ]),),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 4.0),
              child: Text( 'user_name'.tr, style: const TextStyle(color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextFormField(
                  controller: userName,
                  readOnly: true,
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
                    if(email.text != '' && !regExp.hasMatch(value.toString())) {
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
              padding: const EdgeInsets.only(left:16.0, right:16, top:5),
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: CommonThemeData.ButtonMinimumSize,
                  backgroundColor: CommonThemeData.ButtonBackgroundColor,
                ),
                onPressed: (){
                  if(validateScreen())
                  {
                    httpService.post(url: "UpdateUser", body: {
                      "user_name": userName.text,
                      "display_name": displayName.text,
                      "phone": phone.text,
                      "email": email.text,
                      "address": address.text,
                    }).then((value){
                      if(value['status']){
                        Map<String, dynamic> data = {};
                        CommonAppData.displayName = data['display_name'] = displayName.text;
                        CommonAppData.phone = data['phone'] = phone.text;
                        CommonAppData.email = data['email'] = email.text;
                        CommonAppData.address = data['address'] = address.text;
                        AppData.setAppData(data);
                      }
                  Get.to(ResultScreen(status: value['status'], description: value['description'], ofAll: false, to: false, pageName: ''));
                  });
                  }
                },
                child: Text('save'.tr),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left:16.0, right:16),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey),
                ),
                onPressed: (){
                  Get.toNamed('/changepassword');
                },
                child: Text('change_password'.tr),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left:16.0, right:16),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey),
                ),
                onPressed: (){
                  CommonAppData.ClearAll();
                  AppData.clearAppData();
                  Get.offAllNamed('/');
                },
                child: Text('logout'.tr),
              ),
            ),
          ],
        ),
      bottomNavigationBar: BottomBar(),
      ),
    );
  }

  bool validateScreen(){

    if(!RegExp(r"^\w+$", caseSensitive: false).hasMatch(userName.text)) {
      return false;
    }else if(!RegExp(r"^[\w ]+$", caseSensitive: false).hasMatch(displayName.text)) {
      return false;
    }else if(!RegExp(r'^[0-9]+$', caseSensitive: false).hasMatch(phone.text)) {
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
