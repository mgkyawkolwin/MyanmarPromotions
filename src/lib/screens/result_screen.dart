import 'package:flutter/material.dart';
import 'package:get/get.dart';

//ignore: use_key_in_widget_constructors
class ResultScreen extends StatelessWidget {
  final bool status;
  String description;
  bool ofAll = false;
  bool to = false;
  String pageName;

//ignore: use_key_in_widget_constructors
  ResultScreen({required this.status, required this.description, required this.ofAll, required this.to, required this.pageName});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body:
        status ?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(child: Icon(Icons.check_circle, color: Colors.green, size: 64.0)),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text("success".tr, style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Padding(padding: const EdgeInsets.only(left: 20, right:20), child: Text(description, style: const TextStyle(color: Colors.white
              )),),
            ),
            Center(
              child: ElevatedButton(
                onPressed: (){
                  if(to) {
                    Get.offNamed(pageName);
                  }else if(ofAll) {
                    Get.offAllNamed(pageName);
                  }else{
                    Get.back();
                  }

                },
                child: Text("close".tr),
              ),
            ),
          ],
        ):
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(child: Icon(Icons.warning, color: Colors.amber, size: 64.0)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text("fail".tr, style: const TextStyle(color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Padding(padding: const EdgeInsets.only(left:20, right:20) ,child: Text(description, style: const TextStyle(color: Colors.white
              ))),
            ),
            ElevatedButton(
              onPressed: (){
                if(to) {
                  Get.offNamed(pageName);
                }else if(ofAll) {
                  Get.offAllNamed(pageName);
                }else{
                  Get.back();
                }
              },
              child: Text("close".tr),
            ),
          ],
        ),
      ),
    );
  }
}
