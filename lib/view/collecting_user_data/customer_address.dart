import 'dart:convert';

import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:sehr_remake/model/user_model.dart';
import 'package:sehr_remake/view/collecting_user_data/customer_photos.dart';
import '../../components/app_button_widget.dart';
import '../../components/drop_down_widget.dart';
import '../../components/radio_button_widget.dart';
import '../../components/text_field_component.dart';
import '../../components/top_back_widget.dart';
import '../../utils/app/constant.dart';
import '../../utils/asset_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/size_config.dart';

loadingshowdialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Please Wait")
                ],
              )
            ],
          ),
        );
      });
}

class SetLocationView extends StatefulWidget {
  final String fname;
  final String lname;
  final String cnic;
  final String education;
  final String dob;
  final String gender;
  final String? package;
  final String? specialPackage;
  final String? phoneNumber;
  final String? email;
  final String? selectedLocationId;

  const SetLocationView({
    super.key,
    required this.fname,
    required this.lname,
    required this.cnic,
    required this.dob,
    required this.education,
    required this.gender,
    this.package,
    this.specialPackage,
    this.phoneNumber,
    this.email,
    this.selectedLocationId,
  });

  @override
  State<SetLocationView> createState() => _SetLocationViewState();
}

class _SetLocationViewState extends State<SetLocationView> {
  bool dataLoading = false;

  Map<String, dynamic>? dataTest;
  final List<dynamic> _list = [];
  List<dynamic> filterList = [];
  //province

  Map<String, dynamic>? provinceTest;
  final List<dynamic> _list2 = [];

  List<dynamic> filterList2 = [];
  //districts data

  Map<String, dynamic>? districtTest;
  final List<dynamic> _districtList = [];
  List<dynamic> filterDristrict = [];

  String? selectedProvince;
  String? selectedDivision;
  String? selectedDistrict;
  String? selectedTehsil;
// tehsil data

  final TextEditingController addressController = TextEditingController();

  Map<String, dynamic>? tehsilTest;
  final List<dynamic> _tehsilList = [];
  List<dynamic> filterTehsil = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Special Package Location Id In SetLocation Screen ==> ${widget.selectedLocationId}");
    print(widget.package);
    return dataLoading == false
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  Image.asset(
                    AppImages.pattern2,
                    color: ColorManager.primary.withOpacity(0.1),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TopBackButtonWidget(),
                      buildVerticleSpace(20),
                      Padding(
                        padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(27),
                        ),
                        child: kTextBentonSansMed(
                          'Set Your Location',
                          fontSize: getProportionateScreenHeight(25),
                        ),
                      ),
                      buildVerticleSpace(20),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(22),
                        ),
                        child: Container(
                          // height: getProportionateScreenHeight(287),
                          width: SizeConfig.screenWidth,
                          decoration: BoxDecoration(
                            color: ColorManager.white,
                            borderRadius: BorderRadius.circular(
                              getProportionateScreenHeight(22),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: ColorManager.black.withOpacity(0.05),
                                blurRadius: getProportionateScreenHeight(15),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(11),
                                  vertical: getProportionateScreenHeight(20),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      AppIcons.pinIcon,
                                      height: getProportionateScreenHeight(33),
                                      width: getProportionateScreenHeight(33),
                                    ),
                                    buildHorizontalSpace(14),
                                    kTextBentonSansMed(
                                      'Address',
                                      fontSize:
                                          getProportionateScreenHeight(15),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: getProportionateScreenWidth(17),
                                  right: getProportionateScreenWidth(8),
                                ),
                                child: Form(
                                  child: Column(
                                    children: [
                                      buildVerticleSpace(12),
                                      TextFieldWidget(
                                        controller: addressController,
                                        hintText: 'Address',
                                        fillColor: ColorManager.lightGrey,
                                        blurRadius:
                                            getProportionateScreenHeight(3),
                                      ),
                                      buildVerticleSpace(12),
                                      DropDownWidget(
                                          bgColor: ColorManager.lightGrey,
                                          dropdownColor: ColorManager.white,
                                          blurRadius:
                                              getProportionateScreenHeight(3),
                                          lableText: 'Province',
                                          hintText: 'Select Province',
                                          selectedOption: selectedProvince,
                                          dropdownMenuItems: filterList2
                                              .map<DropdownMenuItem<String>>(
                                                (value) => DropdownMenuItem(
                                                  value: value["title"],
                                                  child: kTextBentonSansReg(
                                                      value["title"]),
                                                ),
                                              )
                                              .toList(),
                                          onChange: (value) async {
                                            String? data;
                                            cities = data;
                                            divisions = data;
                                            tehsils = data;
                                            var listDistrictId = filterList2
                                                .where((element) =>
                                                    (element["title"]
                                                            .toString()
                                                            .toLowerCase()
                                                            .trim() ==
                                                        value
                                                            .toString()
                                                            .toLowerCase()
                                                            .trim()))
                                                .toList();
                                            loadingshowdialog(context);
                                            filterDristrict.clear();
                                            filterList.clear();
                                            filterTehsil.clear();

                                            print("Province ==> ${listDistrictId
                                                .first["title"]
                                                .toString()}");

                                            await citycall(listDistrictId
                                                .first["_id"]
                                                .toString());
                                            print("City Call Id ==> ${listDistrictId
                                                .first["_id"]
                                                .toString()}");
                                            setState(() {
                                              selectedProvince =
                                                  value.toString();
                                            });
                                            Navigator.pop(context);
                                          }),
                                      buildVerticleSpace(12),
                                      DropDownWidget(
                                          bgColor: ColorManager.lightGrey,
                                          dropdownColor: ColorManager.white,
                                          blurRadius:
                                              getProportionateScreenHeight(3),
                                          lableText: 'Division',
                                          hintText: 'Select Division',
                                          selectedOption: selectedDivision,
                                          dropdownMenuItems: filterList
                                              .map<DropdownMenuItem<String>>(
                                                (value) => DropdownMenuItem(
                                                  value:
                                                      value["title"].toString(),
                                                  child: kTextBentonSansReg(
                                                      value["title"]
                                                          .toString()),
                                                ),
                                              )
                                              .toList(),
                                          onChange: (value) async {
                                            String? data;
                                            cities = data;
                                            cities = value;
                                            var listDistrictId = filterList
                                                .where((element) =>
                                                    (element["title"]
                                                            .toString()
                                                            .toLowerCase()
                                                            .trim() ==
                                                        value
                                                            .toString()
                                                            .toLowerCase()
                                                            .trim()))
                                                .toList();
                                            loadingshowdialog(context);
                                            filterDristrict.clear();
                                            filterTehsil.clear();

                                            await districtsdata(listDistrictId
                                                .first["_id"]
                                                .toString());

                                            setState(() {
                                              selectedDivision =
                                                  value.toString();
                                            });

                                            Navigator.pop(context);
                                            //
                                          }),
                                      buildVerticleSpace(12),
                                      DropDownWidget(
                                          bgColor: ColorManager.lightGrey,
                                          dropdownColor: ColorManager.white,
                                          blurRadius:
                                              getProportionateScreenHeight(3),
                                          lableText: 'District',
                                          hintText: 'Select District',
                                          selectedOption: selectedDistrict,
                                          dropdownMenuItems: filterDristrict
                                              .map<DropdownMenuItem<String>>(
                                                (value) => DropdownMenuItem(
                                                  value:
                                                      value["title"].toString(),
                                                  child: kTextBentonSansReg(
                                                      value["title"]),
                                                ),
                                              )
                                              .toList(),
                                          onChange: (value) async {
                                            String? data;
                                            divisions = data;
                                            divisions = value;
                                            var listDistrictId = filterDristrict
                                                .where((element) =>
                                                    (element["title"]
                                                            .toString()
                                                            .toLowerCase()
                                                            .trim() ==
                                                        value
                                                            .toString()
                                                            .toLowerCase()
                                                            .trim()))
                                                .toList();
                                            loadingshowdialog(context);
                                            filterTehsil.clear();
                                            await tehsildata(listDistrictId
                                                .first["_id"]
                                                .toString());
                                            setState(() {
                                              selectedDistrict =
                                                  value.toString();
                                            });
                                            Navigator.pop(context);
                                          }),
                                      buildVerticleSpace(12),
                                      DropDownWidget(
                                          bgColor: ColorManager.lightGrey,
                                          dropdownColor: ColorManager.white,
                                          blurRadius:
                                              getProportionateScreenHeight(3),
                                          lableText: 'Tehsil',
                                          hintText: 'Select Tehsil',
                                          selectedOption: selectedTehsil,
                                          dropdownMenuItems: filterTehsil
                                              .map<DropdownMenuItem<String>>(
                                                (value) => DropdownMenuItem(
                                                  value:
                                                      value["title"].toString(),
                                                  child: kTextBentonSansReg(
                                                      value["title"]),
                                                ),
                                              )
                                              .toList(),
                                          onChange: (value) {
                                            String? data;
                                            tehsils = data;
                                            tehsils = value;
                                            setState(() {
                                              selectedTehsil = value.toString();
                                            });
                                          }),
                                      buildVerticleSpace(12),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // buildVerticalSpace(50),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(118),
                        ),
                        child: AppButtonWidget(
                          ontap: () {
                            if (selectedProvince == null ||
                                selectedDistrict == null ||
                                selectedDivision == null ||
                                addressController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Select the required fields")));

                              return;
                            }
                            print("Email ==> ${widget.email}");

                            final User userData = User(
                              package: widget.package,
                              specialPackage: widget.specialPackage,
                              firstName: widget.fname,
                              lastName: widget.lname,
                              cnic: widget.cnic,
                              dob: widget.dob,
                              address: addressController.text,
                              education: widget.education,
                              gender: widget.gender,
                              province: selectedProvince,
                              division: selectedDivision,
                              district: selectedDistrict,
                              tehsil: selectedTehsil,
                              mobile: widget.phoneNumber,
                              selectedLocationId: widget.selectedLocationId
                            );

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UploadProfilePhotoView(user: userData,email: widget.email,),
                                ));
                          },
                          text: 'Next',
                        ),
                      ),

                      buildVerticleSpace(50),
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  String? cities;
  String? citiesdemo;
  String? tehsils;
  String? divisions;

  Future<void> citycall(String id) async {
    filterList.clear();
    print("ID ===> $id");

    var response = await http.get(
      Uri.parse("http://52.64.170.201:3505/api/v1/address/division/$id"),
    );

    if (response.statusCode == 200) {
      // Proceed to parse JSON
      var dataTest = jsonDecode(response.body);
      _list.clear();
      _list.add(dataTest == null ? [] : dataTest.values.toList());
      _list[0][0].forEach((element) {
        filterList.add(element);
      });
    } else {
      // Handle error
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  fetchorders() async {
    await proviencecall();

    dataLoading = true;
    setState(() {});
  }

  @override
  void initState() {
    fetchorders();
    // TODO: implement initState
    super.initState();
  }

  Future proviencecall() async {
    var responseofdata =
    await http.get(Uri.parse("http://52.64.170.201:3505/api/v1/address/province"));

    provinceTest = convert.jsonDecode(responseofdata.body);
    _list2.add(provinceTest == null ? [] : provinceTest!.values.toList());
    _list2[0][0].forEach((element) {
      filterList2.add(element);
    });
    print(provinceTest);
    // setState(() {
    //   selectedProvice = provincetest!['province'][0]['title'];
    // });
    return provinceTest;
  }



  Future tehsildata(String districtid) async {
    // Construct the URL with the district ID parameter
    var url = Uri.parse("http://52.64.170.201:3505/api/v1/address/tehsil/$districtid");

    // Perform the HTTP GET request
    var response = await http.get(url);

    // Check if the response status is successful (status code 200)
    if (response.statusCode == 200) {
      try {
        // Parse the response body as JSON
        tehsilTest = convert.jsonDecode(response.body);

        // Clear the current list and populate it with the parsed data
        _tehsilList.clear();
        _tehsilList.add(tehsilTest == null ? [] : tehsilTest?.values.toList());

        // Populate filterTehsil with the parsed data
        _tehsilList[0][0].forEach((element) {
          filterTehsil.add(element);
        });

        print(tehsilTest); // Optional: Log the parsed data for verification

        // Return the parsed JSON data
        return tehsilTest;
      } catch (e) {
        // Handle JSON parsing error
        print('Error parsing JSON: $e');
        print('Response body: ${response.body}');
      }
    } else {
      // Log the error status code and response body for debugging
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }


  Future<void> districtsdata(String divisionid) async {
    var url = Uri.parse("http://52.64.170.201:3505/api/v1/address/district/$divisionid");
    var response = await http.get(url);

    print('Request URL: $url');
    print('Status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      // Proceed to parse JSON
      var districtTest = jsonDecode(response.body);
      _districtList.clear();
      _districtList.add(districtTest == null ? [] : districtTest.values.toList());
      _districtList[0][0].forEach((element) {
        filterDristrict.add(element);
      });
      print(districtTest);
      return districtTest;
    } else {
      // Handle error
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

}
