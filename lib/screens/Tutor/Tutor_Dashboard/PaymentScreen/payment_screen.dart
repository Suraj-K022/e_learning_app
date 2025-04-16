import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../customWidgets/customtext.dart';


class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        title: Poppins(
          text: 'Payments',
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
      body:
      ListView(padding: EdgeInsets.symmetric(horizontal: 24),
        children: [
          Poppins(text: '25 March',fontSize: 14,color: Get.theme.secondaryHeaderColor,),

          ListTile(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            title: Poppins(text: 'Java',fontSize: 16,color: Get.theme.secondaryHeaderColor,),
            trailing: Poppins(text: '+249 Rs',fontSize: 14,color:Colors.green
              ,),
            subtitle: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Poppins(text: 'Pratham Goswami ',fontSize: 12,color: Get.theme.primaryColor,),
                Poppins(text: 'By Credit card ',fontSize: 12,color: Get.theme.hintColor,),
              ],
            ),
            tileColor: Get.theme.cardColor,
          ),
        ],
      ),
    );
  }
}
