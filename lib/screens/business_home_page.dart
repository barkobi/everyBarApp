import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iBar/data/Headlines.dart';
import 'package:iBar/models/business_model.dart';
import 'package:iBar/providers/language_provider.dart';
import 'package:iBar/widgets/raiting_bar.dart';
import 'package:iBar/widgets/business_home_page_buttons.dart';
import 'package:iBar/widgets/business_page_text.dart';
import 'dart:convert';

import 'package:iBar/widgets/business_page_top.dart';

class BusinessHomePage extends ConsumerWidget {
  const BusinessHomePage({
    super.key,
    required this.businessModel,
  });
  final Business businessModel;

  final String defaultImageUrl = 'assests/home.png';

  void _handleRatingChanged(int rating) {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanguage = ref.watch(currentLanguageProvider);
    final selectedMap = selectedLanguageMap[selectedLanguage];

    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: deviceHeight * 0.4,
              child: Stack(
                children: [
                  Center(
                    child: Image.memory(base64.decode(businessModel.imageUrl!)),
                  ),
                  Positioned(
                    child: Container(
                      height: deviceHeight * 0.2,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                        colors: [Colors.black, Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: deviceHeight * 0.35),
                    child: BusinessPageButtons(business: businessModel),
                  ),
                  BusinessPageTop(business: businessModel)
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.02),
              child: Text(
                businessModel.name,
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: deviceWidth * 0.1,
                    fontWeight: FontWeight.bold),
              ),
            ),
            BusinessPageTexts(business: businessModel),
            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.01),
              child: StarRating(
                initialRating: businessModel.ratingAvg,
                onRatingChanged: _handleRatingChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
