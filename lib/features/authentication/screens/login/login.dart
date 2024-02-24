import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:hungerheavend/common/styles/spacing_style.dart';
import 'package:hungerheavend/common/widgets/login_signup/form_divider.dart';
import 'package:hungerheavend/common/widgets/login_signup/social_icon.dart';
import 'package:hungerheavend/features/authentication/screens/login/widgets/login_form.dart';
import 'package:hungerheavend/features/authentication/screens/login/widgets/login_header.dart';
import 'package:hungerheavend/utils/constants/sizes.dart';
import 'package:hungerheavend/utils/constants/text_strings.dart';
import 'package:hungerheavend/utils/helpers/helper_functions.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              TLoginHeader(dark: dark),
              const TLoginForm(),
              TFormDivider(
                dividerText: TTexts.orSignInWith.capitalize!,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              const TSocialicon(),
            ],
          ),
        ),
      ),
    );
  }
}
