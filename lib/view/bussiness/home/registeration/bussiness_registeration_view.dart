import 'dart:convert' as convert;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sehr_remake/controller/category_controller.dart';
import 'package:sehr_remake/model/business_model.dart';
import 'package:sehr_remake/view/bussiness/bussiness_photos.dart';
import 'package:sehr_remake/view/home/home.dart';

import '../../../../components/app_button_widget.dart';
import '../../../../components/drop_down_widget.dart';
import '../../../../components/text_field_component.dart';
import '../../../../utils/app/constant.dart';
import '../../../../utils/asset_manager.dart';
import '../../../../utils/color_manager.dart';
import '../../../../utils/size_config.dart';
import 'package:http/http.dart' as http;

class AddBusinessDetailsView extends StatefulWidget {
  const AddBusinessDetailsView({super.key});

  @override
  State<AddBusinessDetailsView> createState() => _AddBusinessDetailsViewState();
}

class _AddBusinessDetailsViewState extends State<AddBusinessDetailsView> {
  Position? position;
  Future<void> requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      getCurrentLocation().then((value) {
        setState(() {
          position = value;
        });
      });
    } else if (status.isDenied) {
      // Permission denied. You can handle this case by showing a dialog or message to the user.
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied. You can open the app settings to allow the user to enable location access.
      openAppSettings();
    }
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }

  final GlobalKey<ScaffoldState> _formKey = GlobalKey();

  final TextEditingController _companyName = TextEditingController();
  final TextEditingController _ownerName = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _refferalCode = TextEditingController();

  fetchorders() async {
    await apicall();
    if (filterlist.isEmpty) {
      nodata = true;
    } else {}
    if (mounted) {
      setState(() {});
    }

    dataloading = true;
    setState(() {});
  }

  bool nodata = false;

  Future apicall() async {
    var responseofdata =
        await http.get(Uri.parse("http://109.123.236.174:3000/api/category"));

    datatest = convert.jsonDecode(responseofdata.body);
    _list.add(datatest == null ? [] : datatest!.values.toList());
    _list[0][0].forEach((element) {
      print(element);
      filterlist.add(element);
    });

    return datatest;
  }

  String? selectedCateogry;

  @override
  void initState() {
    context.read<CategoryController>().getCategories();
    fetchorders();
    Future.delayed(Duration.zero).then((value) async {
      await requestLocationPermission();
    });
    super.initState();
  }

  bool dataloading = false;

  //categrie data
  Map<String, dynamic>? datatest;
  final List<dynamic> _list = [];
  List<dynamic> filterlist = [];

  //provience
  Map<String, dynamic>? provincetest;
  final List<dynamic> _list2 = [];
  List<dynamic> filterlist2 = [];

  //division data
  Map<String, dynamic>? divisionTest;
  final List<dynamic> _divisionlist = [];
  List<dynamic> filterdivision = [];

  //districts data
  Map<String, dynamic>? districtTest;
  final List<dynamic> _districtlist = [];
  List<dynamic> filterdristrict = [];

  // tehsil data
  Map<String, dynamic>? tehsiltest;
  final List<dynamic> _tehsillist = [];
  List<dynamic> filtertehsil = [];

  @override
  Widget build(BuildContext context) {
    var categories = context.watch<CategoryController>().categories;
    // final viewModel = Provider.of<AuthViewModel>(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              AppImages.pattern2,
              color: ColorManager.primary.withOpacity(0.1),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: getProportionateScreenHeight(35),
                      left: getProportionateScreenWidth(25),
                    ),
                    child: InkWell(
                      onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          )),
                      borderRadius: BorderRadius.circular(
                        getProportionateScreenHeight(15),
                      ),
                      child: Container(
                        height: getProportionateScreenHeight(45),
                        width: getProportionateScreenHeight(45),
                        decoration: BoxDecoration(
                          color: ColorManager.secondaryLight.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            getProportionateScreenHeight(15),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: ColorManager.icon,
                          size: getProportionateScreenHeight(22),
                        ),
                      ),
                    ),
                  ),
                  buildVerticleSpace(24),
                  Padding(
                    padding: EdgeInsets.only(
                      left: getProportionateScreenWidth(27),
                    ),
                    child: kTextBentonSansMed(
                      'Fill in your business\ndetail to get started',
                      fontSize: getProportionateScreenHeight(25),
                    ),
                  ),
                  buildVerticleSpace(34),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(23),
                      ),
                      child: Column(
                        children: [
                          TextFieldWidget(
                            controller: _companyName,
                            hintText: 'Business / Company',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Business/Company name is required';
                              } else if (value.length < 3) {
                                return 'Invalid Business/Company name';
                              }
                              return null;
                            },
                          ),
                          buildVerticleSpace(20),
                          TextFieldWidget(
                            controller: _ownerName,
                            hintText: 'Owner Name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Owner name is required';
                              } else if (value.length < 3) {
                                return 'Invalid Owner name';
                              }
                              return null;
                            },
                          ),
                          buildVerticleSpace(20),
                          DropDownWidget(
                              lableText: 'Category',
                              hintText: 'Select Category',
                              selectedOption: selectedCateogry,
                              dropdownMenuItems: categories
                                  .map<DropdownMenuItem<String>>(
                                    (value) => DropdownMenuItem(
                                      value: value.id,
                                      child: kTextBentonSansReg(
                                        value.title.toString(),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChange: (value) {
                                print(value);
                                setState(() {
                                  selectedCateogry = value;
                                });
                              }),
                          buildVerticleSpace(20),
                          TextFieldWidget(
                            controller: _description,
                            maxlines: 10,
                            hintText: 'Description About',
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'description is required';
                              }
                              return null;
                            },
                          ),
                          buildVerticleSpace(20),
                          TextFieldWidget(
                            controller: _refferalCode,
                            maxlines: 10,
                            hintText: 'Refferal Code (Optional)',
                            keyboardType: TextInputType.text,
                          ),
                          buildVerticleSpace(20),
                          buildVerticleSpace(20),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(95),
                            ),
                            child: AppButtonWidget(
                              ontap: () async {
                                if (_companyName.text.isEmpty ||
                                    _ownerName.text.isEmpty ||
                                    _description.text.isEmpty ||
                                    selectedCateogry == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Fill All the required fields")));
                                  return;
                                }

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UploadBussinessPhoto(
                                              model: BussinessModel(
                                                  refferalCode:
                                                      _refferalCode.text,
                                                  businessName:
                                                      _companyName.text,
                                                  ownerName: _ownerName.text,
                                                  about: _description.text,
                                                  lat: position!.latitude,
                                                  lon: position!.longitude,
                                                  categoryId:
                                                      selectedCateogry)),
                                    ));
                              },
                              text: 'Next',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
