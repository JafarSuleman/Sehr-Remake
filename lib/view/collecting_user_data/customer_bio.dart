import 'dart:convert';

import 'dart:convert' as convert;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/app_button_widget.dart';
import '../../components/drop_down_widget.dart';
import '../../components/radio_button_widget.dart';
import '../../components/text_field_component.dart';
import '../../components/top_back_widget.dart';
import '../../utils/app/constant.dart';
import '../../utils/asset_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/size_config.dart';
import 'customer_address.dart';
import '../../components/loading_widget.dart';

class AddCustomerBioView extends StatefulWidget {
  final String? packageName;
  final String? specialPackageName;
  final String? email;
  final String? whatsApp;
  final String? selectedLocationId;
  const AddCustomerBioView({super.key,this.whatsApp, this.packageName,this.email, this.specialPackageName, this.selectedLocationId});

  @override
  State<AddCustomerBioView> createState() => _AddCustomerBioViewState();
}

class _AddCustomerBioViewState extends State<AddCustomerBioView> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController(); // New controller

  String selectedGender = '';
  String selectedEducation = 'Uneducated';
  bool isLoading = false; // Loading state

  @override
  void dispose() {
    // Dispose all controllers
    firstNameController.dispose();
    lastNameController.dispose();
    cnicController.dispose();
    dobController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  List<String> filterlist = [
    'Uneducated',
    'Primary',
    'Middle',
    'Matric',
    'Graduation',
    'Masters',
    'MPhil',
    'Phd',
    'MBBS',
    'LLB',
    'Diploma',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    print("Special Package Id ==> ${widget.specialPackageName}");
    print("Package Id ==> ${widget.packageName}");
    print("Customer Bio Screen Email ==> ${widget.email}");
    print("Special Package Location Id ==> ${widget.selectedLocationId}");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xffeaeffae).withOpacity(0.5),
              Colors.white,
              Colors.white.withOpacity(0.5),
              const Color(0xffeaeffae),
            ],
          ),
        ),
        child: Stack(
          children: [
            Image.asset(
              AppImages.pattern2,
              color: ColorManager.primary.withOpacity(0.1),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30,),
                  const TopBackButtonWidget(),
                  buildVerticleSpace(24),
                  Padding(
                    padding: EdgeInsets.only(
                      left: getProportionateScreenWidth(27),
                    ),
                    child: kTextBentonSansMed(
                      'Fill in your bio to get\nstarted',
                      fontSize: getProportionateScreenHeight(25),
                    ),
                  ),
                  buildVerticleSpace(32),
                  Padding(
                    padding:
                    EdgeInsets.only(left: getProportionateScreenWidth(27)),
                    child: kTextBentonSansMed(
                      'This data will be displayed in your\naccount profile for security',
                      fontSize: getProportionateScreenHeight(15),
                    ),
                  ),
                  buildVerticleSpace(12),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(23),
                    ),
                    child: Form(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextFieldWidget(
                              controller: firstNameController,
                              hintText: 'First Name',

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Name is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          buildVerticleSpace(20),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextFieldWidget(
                              controller: lastNameController,
                              hintText: 'Last Name',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Name is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          buildVerticleSpace(20),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextFieldWidget(
                              controller: cnicController,
                              keyboardType: TextInputType.number,
                              hintText: 'Cnic No',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'CNIC is required';
                                } else if (value.length < 13) {
                                  return 'Invalid cnic number';
                                }
                                return null;
                              },
                            ),
                          ),
                          buildVerticleSpace(20),
                          DropDownWidget(
                            lableText: 'Education',
                            hintText: 'Select Education',
                            dropdownMenuItems: filterlist
                                .map<DropdownMenuItem<String>>(
                                  (value) => DropdownMenuItem(
                                  value: value,
                                  child: kTextBentonSansReg(
                                    value,
                                  ),
                                ),
                              )
                                .toList(),
                            onChange: (value) {
                              setState(() {
                                selectedEducation = value!;
                              });
                            },
                            selectedOption: selectedEducation,
                          ),
                          buildVerticleSpace(20),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextFieldWidget(
                              controller: dobController,
                              readOnly: true,
                              hintText: 'DOB',
                              sufixIcon: _buildCalenderWidget(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(30),
                      vertical: getProportionateScreenHeight(16),
                    ),
                    child: kTextBentonSansReg('Gender',fontSize: 15,),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(30),
                    ),
                    child: Row(
                      children: [
                        RadioButtonWidget(
                          value: 'male',
                          groupValue: selectedGender,
                          text: 'Male',
                          onChanged: (value) => setState(() {
                            selectedGender = value.toString();
                          }),
                        ),
                        buildHorizontalSpace(44),
                        RadioButtonWidget(
                          value: 'female',
                          groupValue: selectedGender,
                          text: 'Female',
                          onChanged: (value) => setState(() {
                            selectedGender = value.toString();
                          }),
                        ),
                      ],
                    ),
                  ),
                  buildVerticleSpace(30),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(25),
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade900,
                            Colors.green.shade500,
                            Colors.green.shade900,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.25),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: AppButtonWidget(
                        ontap: () async {
                          setState(() => isLoading = true);
                          if (firstNameController.text.isEmpty ||
                              lastNameController.text.isEmpty ||
                              cnicController.text.isEmpty ||
                              dobController.text.isEmpty ||
                              selectedGender.isEmpty ||
                              selectedEducation.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('All fields are required'),
                              ),
                            );
                            setState(() => isLoading = false);
                            return;
                          }
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String authMethod = prefs.getString('authMethod') ?? '';
                          String identifier = prefs.getString('identifier') ?? '';

                          String? phone;
                          String? email;
                          if (authMethod == 'phone') {
                            phone = identifier;
                          }else if (authMethod == 'email') {
                            email = identifier;
                          }
                          // if (authMethod == 'email' && phoneNumberController.text.isEmpty) {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(content: Text('Phone number is required')),
                          //   );
                          //   setState(() => isLoading = false);
                          //   return;
                          // }
                          print("Special package ===> ${widget.specialPackageName}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SetLocationView(
                                  fname: firstNameController.text,
                                  lname: lastNameController.text,
                                  phoneNumber: phone,
                                  cnic: cnicController.text,
                                  dob: dobController.text,
                                  gender: selectedGender,
                                  education: selectedEducation,
                                  package: widget.packageName,
                                  email: widget.email ?? email,
                                  specialPackage: widget.specialPackageName,
                                  selectedLocationId: widget.selectedLocationId,

                                ),
                              )).then((_) => setState(() => isLoading = false));
                        },
                        child: isLoading
                            ? loadingSpinkit(ColorManager.white,)
                            : const Text(
                          "Next",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalenderWidget(BuildContext context) {
    return InkWell(
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          setState(() {
            dobController.text = picked!.toIso8601String();
          });
        },
        child: Icon(
          Icons.calendar_month,
          size: getProportionateScreenHeight(18),
          color: ColorManager.primary,
        ));
  }
  Future<String> _getAuthMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authMethod') ?? '';
  }
}
