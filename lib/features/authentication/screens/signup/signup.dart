import 'package:flutter/material.dart';
import 'package:hungerheavend/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:hungerheavend/utils/constants/sizes.dart';
import 'package:hungerheavend/utils/constants/text_strings.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TTexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              const TSignUpForm(),
            ],
          ),
        ),
      ),
    );
  }
}
