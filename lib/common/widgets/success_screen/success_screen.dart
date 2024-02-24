import 'package:flutter/material.dart';

import 'package:hungerheavend/common/styles/spacing_style.dart';

import 'package:hungerheavend/utils/constants/sizes.dart';
import 'package:hungerheavend/utils/constants/text_strings.dart';
import 'package:hungerheavend/utils/helpers/helper_functions.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.image, required this.title, required this.subtitle, required this.onPressed});

  final String image,title,subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight*2,
          child: Column(
            children: [
              //image
              Image(
                image: AssetImage(image),
                width: THelperFunctions.screenWidth(),
              ),

              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              //Title & subtitle
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              

              Text(
                subtitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              

              //button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: const Text(TTexts.tContinue),
                ),
              ),



            ],
          ),
          ),
        
        ),
    );
  }
}