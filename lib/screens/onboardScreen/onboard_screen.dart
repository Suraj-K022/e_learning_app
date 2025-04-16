
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../customWidgets/custom_buttons.dart';
import '../../customWidgets/customtext.dart';
import '../../utils/images.dart';
import '../splashscreen/entityScreen/entity_screen.dart';




class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Map<String, String>> onboardData = [
    {
      'title': 'Tailor-Make Professional Invoices',
      'subtitle':
      'Choose from a wide range of customizable templates and create invoices that reflect your business.',
      'image': Images.onboardimage1
    },
    {
      'title': 'Quick & Secure Payments',
      'subtitle':
      'Set up online payment and allow your customers to choose from multiple payment options.',
      'image': Images.onboardimage2
    },
    {
      'title': 'Time Tracking',
      'subtitle':
      'Track the time your users spend on tasks. You can later create timesheets for them and bill your customers.',
      'image': Images.onboardimage3
    },
    {
      'title': 'Access Detailed Reports',
      'subtitle':
      'Access in-depth reports and get a detailed overview of your business’s health.',
      'image': Images.onboardimage4
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currentIndex = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (currentIndex < onboardData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to login/signup screen
      Get.off(() => EntityScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: currentIndex == 0
          ? null
          : FloatingActionButton(
        onPressed: () {
          if (_pageController.page! > 0) {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        elevation: 0, // Optional: Remove shadow for a cleaner look
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        child: Icon(Icons.arrow_back_ios_new_rounded, color: Get.theme.primaryColor, size: 24),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardData.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 350,
                      child: Image.asset(
                        onboardData[index]['image']!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 70),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Poppins(
                        text: onboardData[index]['title']!,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        textAlign: TextAlign.center,
                        color: Get.theme.secondaryHeaderColor,
                        maxLines: 2,
                      ),
                    ),
                    if (onboardData[index]['subtitle']!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        child: Poppins(
                          text: onboardData[index]['subtitle']!,
                          maxLines: 4,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          textAlign: TextAlign.center,
                          color: Get.theme.hintColor,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: onboardData.length,
            effect: ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: Get.theme.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                if (currentIndex < 3) // Show Skip button only if not on the last page
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        _pageController.jumpToPage(onboardData.length - 1);
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Get.theme.primaryColor, width: 1),
                        ),
                        child: Center(
                          child: Poppins(
                            text: 'Skip',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Get.theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (currentIndex < 3) const SizedBox(width: 20), // Add spacing only when Skip is visible
                Expanded(
                  flex: currentIndex == 3 ? 2 : 1, // Make "Get Started" full width when Skip is hidden
                  child: CustomButton(
                    onPressed: _nextPage,
                    child: Poppins(
                      text: currentIndex == onboardData.length - 1 ? 'Get Started' : 'Next',
                      color: Get.theme.secondaryHeaderColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
