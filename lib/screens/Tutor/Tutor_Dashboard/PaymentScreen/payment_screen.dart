import 'package:e_learning_app/controller/course_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../customWidgets/customtext.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CourseController>().getAllTransactions();
    });
  }

  String formatTransactionDate(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return isoDate;
    }
  }

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
      body: GetBuilder<CourseController>(
        builder: (courseController) {
          final transactions = courseController.getTransactionDetails;


          if (courseController.isLoading) {
            return  Center(child: CircularProgressIndicator(backgroundColor: Get.theme.primaryColor,color: Get.theme.scaffoldBackgroundColor,));
          }

          if (transactions.isEmpty) {
            return  Center(child: Poppins(text: 'No transactions found',fontWeight: FontWeight.w500,fontSize: 14,color: Get.theme.secondaryHeaderColor,));
          }


          return RefreshIndicator(
            onRefresh: () async {
              await courseController.getAllTransactions();
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(), // ensures refresh works even if list is short
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Poppins(
                      text: formatTransactionDate(transaction.createdAt.toString()),
                      fontSize: 14,
                      color: Get.theme.secondaryHeaderColor,
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      tileColor: Get.theme.cardColor,
                      title: Poppins(
                        text: transaction.courseName.toString(),
                        fontSize: 16,
                        color: Get.theme.secondaryHeaderColor,
                      ),
                      trailing: Poppins(
                        text: '+${transaction.amount} Rs',
                        fontSize: 14,
                        color: Colors.green,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Poppins(
                            text: transaction.studentName.toString(),
                            fontSize: 12,
                            color: Get.theme.primaryColor,
                          ),
                          Poppins(
                            text: 'By ${transaction.paymentMethod}',
                            fontSize: 12,
                            color: Get.theme.hintColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

}
