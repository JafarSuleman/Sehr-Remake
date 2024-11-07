import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/app_button_widget.dart';
import '../../utils/app/constant.dart';
import '../../utils/color_manager.dart';
import '../../utils/routes/routes.dart';
import '../../utils/size_config.dart';

class TermsConditionView extends StatefulWidget {
  const TermsConditionView({
    super.key,
  });

  @override
  State<TermsConditionView> createState() => _TermsConditionViewState();
}

class _TermsConditionViewState extends State<TermsConditionView> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(getProportionateScreenHeight(18)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              kTextBentonSansBold("Terms & Conditions",
                  fontSize: getProportionateScreenHeight(31)),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              Expanded(
                child: Scrollbar(
                  trackVisibility: true,
                  thumbVisibility: true,
                  thickness: 6,
                  radius: const Radius.circular(20),
                  scrollbarOrientation: ScrollbarOrientation.left,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: termslist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(termslist[index]),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    activeColor: ColorManager.primary,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                  ),
                  const Text('Agree to Terms and Conditions'),
                ],
              ),
              AppButtonWidget(
                textColor: _isChecked ? ColorManager.white : ColorManager.black,
                text: 'Get Started',
                bgColor: _isChecked ? ColorManager.primary : ColorManager.grey,
                ontap: _isChecked
                    ? () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString("agree", "true");
                        Get.offAndToNamed(Routes.loginRoute);
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TermCardWidget extends StatelessWidget {
  const TermCardWidget({
    super.key,
    required this.title,
    required this.discription,
  });
  final String title;
  final String discription;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: getProportionateScreenHeight(15),
      shadowColor: ColorManager.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          getProportionateScreenHeight(24),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: getProportionateScreenHeight(15),
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(15),
            ),
            child: Row(
              children: [
                kTextBentonSansMed(
                  title,
                  fontSize: getProportionateScreenHeight(17),
                ),
              ],
            ),
          ),
          // buildVerticleSpace(32),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(15),
              vertical: getProportionateScreenHeight(20),
            ),
            child: kTextBentonSansReg(
              discription,
              fontSize: getProportionateScreenHeight(12),
              lineHeight: getProportionateScreenHeight(2),
              // overFlow: TextOverflow.ellipsis,
              // maxLines: 4,
            ),
          ),
        ],
      ),
    );
  }
}

List<String> termslist = [
  "1. The SEHR project is for every citizen of Pakistan and Ajk.",
  "2. The project is based on (نیک نیتی/Good will)، (حسن ظن ) and ( احسان) welfare۔",
  "3. No donation, investment or any financial support will be accepted. ",
  "4. All offers are based on gift or support.",
  "5. No offer or incentive will be claimable in the court of law. ",
  "6. Nothing will be recieved against any offer or incentive.",
  "7. The company SOBER TECHNOLOGIES INT. ISLAMABAD/SEHR PRIVATE LIMITED has the right to withdraw any offer or incentive at any time",
  "8. All decisions will be finalized by prof. Munawar Ahmad Malik / Ceo.",
  "9. No decision of the company will be challenged in any court of law in Pakistan or abroad.",
  "10. By using the 'SEHR' app, you agree to grant the company access to your device's location.",
  "11. The company will collect and use this information in accordance with its Privacy Policy.",
  "12.The app requires location access for location-based features and functionalities.",
  "13. The app may request access to phone's camera and photo gallery for uploading pictures.",
  "14. The company takes measures to safeguard your data but can not guarantee absolute security.",
  "15. You are responsible for the content you share and must not use the app for unlawful purposes.",
  "16. The app and its content are protected by copyright and intellectual property laws.",
  "17. The company is not liable for any damages resulting from app usage.",
  "18. The company reserves the right to terminate your access to the app at any time.",
  "19. The company may modify or discontinue the app and these terms without prior notice",
  "I am ready to accept and work with SEHR under such terms and conditions. I pledge to obey that i will obey all bylaws of Sober Technologies Int. Islamabad/SEHR project"
];
