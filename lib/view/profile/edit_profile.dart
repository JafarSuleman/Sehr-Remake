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
import 'package:sehr_remake/controller/user_controller.dart';
import 'package:sehr_remake/utils/color_manager.dart';
import 'package:http/http.dart' as http;
import 'package:sehr_remake/utils/text_manager.dart';

import '../../utils/app/constant.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  bool _isEditing = false;
  XFile? _image;

  // Function to open the image picker dialog
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
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
    var userProvider = context.watch<UserController>().userModel;
    print(userProvider.avatar);

    _nameController.text = "${userProvider.firstName}";
    _lastNameController.text = userProvider.lastName.toString();
    _phoneController.text = userProvider.mobile.toString();

    _phoneController.text = _phoneController.text.replaceFirst("+92", "0");

    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorManager.gradient2,
          title: Text('Edit Profile'),
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
                      width: double.infinity,
                      child: _image == null
                          ? CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl:
                                  "${Constants.BASE_URL}/${userProvider.avatar.toString()}",
                              placeholder: (context, url) =>
                                  Image.asset(SEHR_SHOP_ICON, fit: BoxFit.fill),
                              errorWidget: (context, url, error) {
                                print(error);
                                return Image.asset(SEHR_SHOP_ICON,
                                    fit: BoxFit.fill);
                              })
                          : Image.file(
                              File(_image!.path),
                              fit: BoxFit.fill,
                            ),
                    ),
                    SizedBox(
                      height: 180,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 235, 124, 116)),
                          child: IconButton(
                            onPressed: () => _showPicker(context),
                            icon: Icon(Icons.edit),
                            color: Colors.white,
                          ),
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
                      "First Name",
                      style: TextStyleManager.regularTextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFieldWidget(
                      readOnly: false,
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
                      "Last Name",
                      style: TextStyleManager.regularTextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFieldWidget(
                      readOnly: false,
                      controller: _lastNameController,
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
                  ontap: () {
                    UserController()
                        .updateUserData(
                            _nameController.text,
                            _lastNameController.text,
                            _image,
                            FirebaseAuth.instance.currentUser!.phoneNumber
                                .toString(),
                            userProvider.avatar.toString())
                        .then((value) {
                      context.read<UserController>().getUserData(FirebaseAuth
                          .instance.currentUser!.phoneNumber
                          .toString(),context);
                      return ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(value)));
                    });
                  },
                  text: "Save",
                )
              ],
            ),
          ),
        ));
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
