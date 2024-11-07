import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sehr_remake/components/app_button_widget.dart';
import 'package:sehr_remake/components/text_field_component.dart';
import 'package:sehr_remake/controller/bussinesController.dart';
import 'package:sehr_remake/controller/user_controller.dart';
import 'package:sehr_remake/utils/color_manager.dart';
import 'package:http/http.dart' as http;
import 'package:sehr_remake/utils/text_manager.dart';

import '../../../utils/app/constant.dart';

class EditBussinessProfile extends StatefulWidget {
  const EditBussinessProfile({super.key});

  @override
  State<EditBussinessProfile> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditBussinessProfile> {
  XFile? _image;
  TextEditingController _nameController =
      TextEditingController(text: "John Doe");
  TextEditingController _phoneController =
      TextEditingController(text: "123-456-7890");
  bool _isEditing = false;

  Future _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _showImagePickerDialog(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await showDialog<File>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Select Image Source"),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                final pickedFile =
                    await picker.pickImage(source: ImageSource.camera);
                setState(() {
                  _image = pickedFile;
                });
              },
              child: const Text("Camera"),
            ),
            SimpleDialogOption(
              onPressed: () async {
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  _image = pickedFile;
                });
              },
              child: const Text("Gallery"),
            ),
          ],
        );
      },
    );

    if (pickedFile != null) {
      // Do something with the selected image (e.g., upload it, display it, etc.)
    }
  }

  @override
  Widget build(BuildContext context) {
    var bussinessProvider = context.watch<BussinessController>().singleShopData;
    print(bussinessProvider.logo);

    _nameController.text = bussinessProvider.businessName.toString();
    _phoneController.text = bussinessProvider.mobile.toString();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorManager.gradient2,
          title: Text('Edit Bussiness Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      height: 200,
                      child: _image == null
                          ? CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl:
                                  "${Constants.BASE_URL}/${bussinessProvider.logo}",
                              placeholder: (context, url) => Image.asset(
                                  "assets/images/shop.jpg",
                                  fit: BoxFit.fill),
                              errorWidget: (context, url, error) {
                                print(error);
                                return Image.asset("assets/images/shop.jpg",
                                    fit: BoxFit.fill);
                              })
                          : Image.file(File(_image!.path)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        _showImagePickerDialog(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black38),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Bussiness Name",
                      style: TextStyleManager.regularTextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFieldWidget(
                      readOnly: true,
                      controller: _nameController,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Phone",
                      style: TextStyleManager.regularTextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFieldWidget(
                      readOnly: true,
                      controller: _phoneController,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                AppButtonWidget(
                  ontap: () async {
                    if (_image == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Choose An Image First")));
                      return;
                    }
                    await updatePhoto(
                            FirebaseAuth.instance.currentUser!.phoneNumber
                                .toString()
                                .replaceAll("+92", "0"),
                            _image as XFile)
                        .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Image Has been updated")));
                      context.read<BussinessController>().getBussinessData(
                            FirebaseAuth.instance.currentUser!.phoneNumber
                                .toString(),
                          );
                    });
                  },
                  text: "Save",
                )
              ],
            ),
          ),
        ));
  }

  Future<void> updatePhoto(String id, XFile file) async {
    var request = http.MultipartRequest(
      'PATCH',
      Uri.parse('${Constants.BASE_URL}/api/v1/business/update-image'),
    );
    request.fields['mobile'] = id;
    var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    var multipartFile = http.MultipartFile('image', stream, length,
        filename: basename(file.path));

    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Photo updated successfully');
    } else {
      print('Failed to update photo');
    }
  }
}
