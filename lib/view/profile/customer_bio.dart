// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sehr/utils/routes/routes.dart';

// import '../../components/app_button_widget.dart';
// import '../../components/drop_down_widget.dart';
// import '../../components/radio_button_widget.dart';
// import '../../components/text_field_component.dart';
// import '../../components/top_back_button_widget.dart';
// import '../../utils/app/constant.dart';
// import '../../utils/asset_manager.dart';
// import '../../utils/color_manager.dart';
// import '../../utils/size_config.dart';

// class AddCustomerBioView extends StatefulWidget {
//   const AddCustomerBioView({super.key});

//   @override
//   State<AddCustomerBioView> createState() => _AddCustomerBioViewState();
// }

// class _AddCustomerBioViewState extends State<AddCustomerBioView> {
//   List<String> filterlist = ['Matric', 'Intermediate', 'Graduation'];

//   bool nodata = false;

//   @override
//   Widget build(BuildContext context) {
//     // final viewModel = Provider.of<AuthViewModel>(context);
//     return SafeArea(
//         child: Scaffold(
//       body: Stack(
//         children: [
//           Image.asset(
//             AppImages.pattern2,
//             color: ColorManager.primary.withOpacity(0.1),
//           ),
//           SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const TopBackButtonWidget(),
//                 buildVerticleSpace(24),
//                 Padding(
//                   padding: EdgeInsets.only(
//                     left: getProportionateScreenWidth(27),
//                   ),
//                   child: kTextBentonSansMed(
//                     'Fill in your bio to get\nstarted',
//                     fontSize: getProportionateScreenHeight(25),
//                   ),
//                 ),
//                 buildVerticleSpace(52),
//                 Padding(
//                   padding:
//                       EdgeInsets.only(left: getProportionateScreenWidth(27)),
//                   child: kTextBentonSansMed(
//                     'This data will be displayed in your\n\naccount profile for security',
//                     fontSize: getProportionateScreenHeight(12),
//                   ),
//                 ),
//                 buildVerticleSpace(8),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: getProportionateScreenWidth(23),
//                   ),
//                   child: Form(
//                     child: Column(
//                       children: [
//                         TextFieldWidget(
//                           hintText: 'First Name',
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Name is required';
//                             }
//                             return null;
//                           },
//                         ),
//                         buildVerticleSpace(20),
//                         TextFieldWidget(
//                           hintText: 'Last Name',
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Name is required';
//                             }
//                             return null;
//                           },
//                         ),
//                         buildVerticleSpace(20),
//                         TextFieldWidget(
//                           keyboardType: TextInputType.number,
//                           hintText: 'Cnic No',
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'CNIC is required';
//                             } else if (value.length < 13) {
//                               return 'Invalid cnic number';
//                             }
//                             return null;
//                           },
//                         ),
//                         buildVerticleSpace(20),
//                         DropDownWidget(
//                           lableText: 'Education',
//                           hintText: 'Select Education',
//                           selectedOption: 'Matric',
//                           dropdownMenuItems: filterlist
//                               .map<DropdownMenuItem<String>>(
//                                 (value) => DropdownMenuItem(
//                                   value: value,
//                                   child: kTextBentonSansReg(
//                                     value,
//                                   ),
//                                 ),
//                               )
//                               .toList(),
//                         ),
//                         buildVerticleSpace(20),
//                         TextFieldWidget(
//                           readOnly: true,
//                           hintText: 'DOB',
//                           sufixIcon: _buildCalenderWidget(context),
//                         ),
//                         // buildVerticleSpace(20),
//                         // TextFieldWidget(
//                         //   controller: viewModel.userMobNoTextController,
//                         //   hintText: 'Mobile Number',
//                         //   validator: (value) {
//                         //     if (value == null || value.isEmpty) {
//                         //       return 'Mobile number is required';
//                         //     } else if (value.length < 11) {
//                         //       return 'Invalid mobile number';
//                         //     }
//                         //     return null;
//                         //   },
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: getProportionateScreenWidth(43),
//                     vertical: getProportionateScreenHeight(16),
//                   ),
//                   child: kTextBentonSansReg('Gender'),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: getProportionateScreenWidth(60),
//                   ),
//                   child: Row(
//                     children: [
//                       RadioButtonWidget(
//                         value: 'male',
//                         groupValue: true,
//                         text: 'Male',
//                         onChanged: (value) {},
//                       ),
//                       buildHorizontalSpace(44),
//                       RadioButtonWidget(
//                         value: 'female',
//                         groupValue: false,
//                         text: 'Female',
//                         onChanged: (value) {},
//                       ),
//                     ],
//                   ),
//                 ),
//                 buildVerticleSpace(18),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: getProportionateScreenWidth(118),
//                   ),
//                   child: AppButtonWidget(
//                     ontap: () async {
//                       Get.toNamed(Routes.photoSelectionRoute);
//                     },
//                     child: const Text(
//                       "Next",
//                       style: TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ));
//   }

//   Widget _buildCalenderWidget(BuildContext context) {
//     return InkWell(
//       onTap: () async {
//         final DateTime? picked = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime(1900),
//           lastDate: DateTime(2100),
//         );
//       },
//       child: Icon(
//         Icons.calendar_month,
//         size: getProportionateScreenHeight(18),
//         color: ColorManager.primary,
//       ),
//     );
//   }
// }
