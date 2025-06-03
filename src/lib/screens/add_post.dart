import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myanmarpromotions/library/CommonAppData.dart';


import '/ad_helper.dart';
import '/http_service.dart';
import '/components/text_input.dart';
import '/components/drop_down.dart';
import '/components/image_picker.dart';
import 'result_screen.dart';
import '/admod.dart';
import '/library/CommonThemeData.dart';


//ignore: use_key_in_widget_constructors
class AddPost extends StatefulWidget {

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final HttpService httpService = HttpService();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  List categoryList = [];
  List cityList = [];
  List<String> categories = [];
  List<String> cities = [];
  int categoryId = 0;
  int cityId = 0;
  ImagePicker imagePicker = ImagePicker();
  bool isPick = false;
  bool onLoading = false;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  //Date Picker
  _selectStartDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateUtils.addDaysToDate(DateTime.now(), 365),
    );
    if (selected != null && selected.compareTo(_startDate) != 0)
    {
        _startDate = selected;
        startDateController.text = _startDate.day.toString() + '/' + _startDate.month.toString() + '/' + _startDate.year.toString();
    }
  }

  _selectEndDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime.now(),
      lastDate: DateUtils.addDaysToDate(DateTime.now(), 365),
    );
    if (selected != null && selected.compareTo(_startDate) != 0)
    {
      _endDate = selected;
      endDateController.text = _endDate.day.toString() + '/' + _endDate.month.toString() + '/' + _endDate.year.toString();
    }

  }


  //Date Picker End
  @override
  void initState()
  {
    super.initState();
    httpService.get(url: "categories").then((value){

      categoryList = value;
      for(var category in categoryList)
      {
        categories.add("appLanguage".tr == "en" ? category['name_en'] : category['name_mm']);
      }
      if(mounted){
        setState((){
          categories = categories;
        });
      }
    });

    httpService.get(url: "getCities").then((value){
      cityList = value;
      for(var city in cityList)
      {
        cities.add("appLanguage".tr == "en" ? city['name_en'] : city['name_mm']);
      }
      setState((){
        cities = cities;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text("new_post".tr),
            centerTitle: true,
            backgroundColor: CommonThemeData.AppBarBackgroundColor,
          foregroundColor: CommonThemeData.AppBarForegroundColor,
          shadowColor: Colors.transparent,
        ),
        body: ListView(
          children: [
            Admod(AdHelper.newPromotionAdUnitId),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 4.0),
              child: Text( 'select_category'.tr, style: const TextStyle(color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, ),
              child: dropDown(
                itemList: categories,
                labelText: '',
                validateText: 'required'.tr,
                helperText: '',
                onChanged: (value){
                  for(var category in categoryList){
                    if("appLanguage".tr == "en"){
                      if(category['name_en'] == value){
                        categoryId = category['id'];
                      }
                    }else{
                      if(category['name_mm'] == value){
                        categoryId = category['id'];
                      }
                    }
                  }
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 4.0),
              child: Text( 'select_city'.tr, style: const TextStyle(color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, ),
              child: dropDown(
                itemList: cities,
                labelText: '',
                validateText: 'required'.tr,
                helperText: '',
                onChanged: (value){
                  for(var city in cityList){
                    if("appLanguage".tr == "en"){
                      if(city['name_en'] == value){
                        cityId = city['id'];
                      }
                    }else{
                      if(city['name_mm'] == value){
                        cityId = city['id'];
                      }
                    }
                  }
                },
              ),
            ),



            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 4.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      Text( 'promotion_start_date'.tr, style: const TextStyle(color: Colors.black),),
                      SizedBox(
                        width: 150.0,
                        child: TextFormField(
                          controller: startDateController,
                          autovalidateMode: AutovalidateMode.always,
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          maxLines: 1,
                            validator: (value){
                              RegExp regExp = RegExp(
                                r"^[0-9]{2}\/[0-9]{2}/[0-9]{4}$",
                                caseSensitive: false,
                                multiLine: false,
                              );
                              if(!regExp.hasMatch(value.toString())){
                                return 'Invalid date.';
                              }
                              else{
                                return null;
                              }
                            },
                          onTap: (){
                            _selectStartDate(context);
                          },
                        ),
                      ),
                    ],),
                    Column(children: [
                      Text( 'promotion_end_date'.tr, style: const TextStyle(color: Colors.black),),
                      SizedBox(
                        width: 150.0,
                        child: TextFormField(
                          controller: endDateController,
                          keyboardType: TextInputType.name,
                          autovalidateMode: AutovalidateMode.always,
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          maxLines: 1,
                          validator: (value){
                            RegExp regExp = RegExp(
                              r"^[0-9]{2}\/[0-9]{2}/[0-9]{4}$",
                              caseSensitive: false,
                              multiLine: false,
                            );
                            if(!regExp.hasMatch(value.toString())){
                              return 'Invalid date.';
                            }
                            else{
                              return null;
                            }
                          },
                          onTap: (){
                            _selectEndDate(context);
                          },
                        ),
                      ),
                    ],),
                  ]
              ),
            ),

            isPick? Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Image.file(imagePicker.file),
            ) : Container(
              height: 50,
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 0.8),
                borderRadius: const BorderRadius.all(Radius.circular(8.0),),
              ),
              child: const Icon(Icons.photo_library_outlined),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 4.0),
              child: Text( isPick ? '': 'Image is required', style: const TextStyle(color: Colors.red),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 4.0),
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
              child: Text( 'shop_name'.tr, style: const TextStyle(color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextFormField(
                controller: _shopNameController,
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.always,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                maxLines: 1,
                validator: (value){
                  RegExp regExp = RegExp(
                    r"^[\w ]+$",
                    caseSensitive: false,
                    multiLine: false,
                  );
                  if(!regExp.hasMatch(value.toString())){
                    return 'This field is required.';
                  }
                  else{
                    return null;
                  }
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 4.0),
              child: Text( 'description'.tr, style: const TextStyle(color: Colors.black),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: textInput(textEditingController: _description,
                labelText: 'description'.tr,
                validateText: "",
                helperText: 'completed'.tr,
                maxLines: 5,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: CommonThemeData.ButtonBackgroundColor,
                  minimumSize: CommonThemeData.ButtonMinimumSize
                ),
                onPressed: (){
                  if(validateScreen()){

                    httpService.post(url: "savePromotion", body: {
                      'category_id': categoryId.toString(),
                      'city_id': cityId.toString(),
                      'start_date': startDateController.text,
                      'end_date': endDateController.text,
                      "description": _description.text,
                      "image": imagePicker.toBased64(),
                      'shopName': _shopNameController.text,
                      'user_id': CommonAppData.userID
                    }).then((value){
                      if(value != null){
                        if(value['status'] == true) {
                          Get.to(ResultScreen(status: value['status'],
                            description: value['description'],
                            ofAll: true,
                            to: false,
                            pageName: '/',));
                        }else {
                          Get.to(ResultScreen(status: value['status'],
                            description: value['description'],
                            ofAll: false,
                            to: false,
                            pageName: '',));
                        }
                      }
                    });
                  }
                },
                child: Text('post_promotion'.tr),
              ),
            ),
          ],
        ),

      ),
    );
  }

  bool validateScreen()
  {
    if(categoryId <= 0)
    {
      return false;
    }
    else if(cityId <= 0)
    {
      return false;
    }
    else if(startDateController.text == '')
    {
      return false;
    }
    else if(endDateController.text == ''){
      return false;
    }
    else if(_endDate.compareTo(_startDate) <= 0){
      return false;
    }
    else if(!isPick){
      return false;
    }
    else{
      return true;
    }
  }
}
