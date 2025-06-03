import 'package:flutter/material.dart';
// import 'package:get/get.dart';

//ignore: use_key_in_widget_constructors
class MenuDrawer extends StatelessWidget {
  final List categories;
  final VoidCallback onTap;
  MenuDrawer({required this.categories, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, int index) {
          //Get.toNamed("/post_by_category", arguments: {"id": categories[index]['id'].toString()});
      return ListTile(
        onTap: onTap,
        title: Text(categories[index]['name']),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18.0),
      );
    });

  }
}
