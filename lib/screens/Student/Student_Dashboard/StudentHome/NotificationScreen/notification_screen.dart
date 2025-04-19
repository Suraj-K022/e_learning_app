import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../customWidgets/customtext.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Poppins(
          text: 'Notification',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Get.theme.secondaryHeaderColor,
        ),
        leading: InkWell(
          onTap: () {
            Get.back(canPop: true);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Get.theme.secondaryHeaderColor,
            size: 24,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          ListTile(
            title: Poppins(
              text: 'Notification 1',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Get.theme.secondaryHeaderColor,
            ),
            subtitle: Poppins(
              text: 'Notification 1 Discription',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Get.theme.hintColor,
            ),
            trailing: Poppins(
              text: '2 Days ago ',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Get.theme.hintColor,
            ),
            minTileHeight: 40,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            tileColor: Get.theme.cardColor,
            leading: Container(
              color: Get.theme.secondaryHeaderColor,
              height: 40,
              width: 40,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          ListTile(
            title: Poppins(
              text: 'Notification 2',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Get.theme.secondaryHeaderColor,
            ),
            subtitle: Poppins(
              text: 'Notification 2 Discription',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Get.theme.hintColor,
            ),
            trailing: Poppins(
              text: '2 Days ago ',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Get.theme.hintColor,
            ),
            minTileHeight: 40,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            tileColor: Get.theme.cardColor,
            leading: Container(
              color: Get.theme.secondaryHeaderColor,
              height: 40,
              width: 40,
            ),
          ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
