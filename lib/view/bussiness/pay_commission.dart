import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sehr_remake/controller/bussinesController.dart';
import '../../utils/app/constant.dart';
import '../../utils/color_manager.dart';
import '../../utils/size_config.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';

class PayScreen extends StatefulWidget {
  const PayScreen({super.key});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  XFile? image;

  void _getGallery() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.camera);
    if (file != null) {
      setState(() {
        image = file;
      });
    }
  }

  //Updated Code

  @override
  Widget build(BuildContext context) {
    var shopId = context.watch<BussinessController>().singleShopData.id;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: image != null
          ? FloatingActionButton.extended(
              extendedPadding: const EdgeInsets.symmetric(horizontal: 60),
              label: const Text(
                "Upload",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () async {
                String res =
                    await SendPayment(shopId.toString(), image as XFile);

                setState(() {
                  image = null;
                });

                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(res)));
              },
              backgroundColor: ColorManager.gradient2,
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.network(
                    "https://iconape.com/wp-content/png_logo_vector/jazz-cash-logo.png",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.network(
                    "https://cdn-icons-png.flaticon.com/512/4140/4140809.png",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.network(
                    "https://crushlogo.com/public/uploads/thumbnail/easypaisa-pay-logo-11685340011w1ndm8dzgj.png",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Easy Paisa",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "03006786890",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Muhamad Amir",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Jazz Cash",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "03006786890",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Muhamad Amir",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        "Bank Transfer",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Faisal Bank",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "0300678689022122",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Muhamad Amir",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 250,
              width: 250,
              child: image == null
                  ? _buildCard(
                      icon: "assets/icons/Gallery.png",
                      label: "Upload Transaction",
                      ontap: () {
                        _getGallery();
                      })
                  : Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              getProportionateScreenHeight(15),
                            ),
                          ),
                          height: getProportionateScreenHeight(129),
                          width: SizeConfig.screenWidth,
                          child: Image.file(
                            File(image!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(211, 255, 255, 255),
                                shape: BoxShape.circle),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    image = null;
                                  });
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                )),
                          ),
                        )
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> SendPayment(String shopId, XFile file) async {
    String res = "Somthing Went Wrong";
    try {
      // var response = await http.post(
      //     Uri.parse("${Constants.BASE_URL}/api/v1/user"),
      //     body: jsonEncode(user.toJson()),
      //     headers: {'Content-Type': "multipart/form-data"});
      // Create a multipart request for the server
      var uri = Uri.parse(
          "${Constants.BASE_URL}/api/v1/payment"); // Replace with your Node.js server URL
      var request = http.MultipartRequest('POST', uri);

      request.fields['shopId'] = shopId;

      var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();
      var multipartFile = http.MultipartFile('image', stream, length,
          filename: basename(file.path));

      request.files.add(multipartFile);

      // Send the request and await the response
      var response = await request.send();

      if (response.statusCode == 200) {
        res = "Payment Request Sent !";
      } else {
        res = "Failed to Register User ${response.reasonPhrase}";
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Widget _buildCard({
    required String icon,
    required String label,
    void Function()? ontap,
  }) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: getProportionateScreenHeight(129),
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(
            getProportionateScreenHeight(15),
          ),
          boxShadow: [
            BoxShadow(
              color: ColorManager.black.withOpacity(0.05),
              blurRadius: getProportionateScreenHeight(15),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              height: getProportionateScreenHeight(50),
              width: getProportionateScreenHeight(50),
            ),
            buildVerticleSpace(9),
            kTextBentonSansMed(label),
          ],
        ),
      ),
    );
  }
}
