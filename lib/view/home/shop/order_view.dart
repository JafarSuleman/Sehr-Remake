import 'package:flutter/material.dart';
import 'package:sehr_remake/model/business_model.dart';
import '../../../utils/app/constant.dart';
import '../../../utils/color_manager.dart';
import '../../../utils/size_config.dart';
import '../../../components/app_button_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'order_proccessing.dart';

class OrderPlacingView extends StatefulWidget {
  final BussinessModel model;
  final String identifier;

  OrderPlacingView(this.model, this.identifier);

  @override
  State<OrderPlacingView> createState() => _OrderPlacingViewState();
}

class _OrderPlacingViewState extends State<OrderPlacingView> {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorManager.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios, color: ColorManager.primary),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: kTextBentonSansMed(
          'Place Order',
          color: ColorManager.white,
          fontSize: getProportionateScreenHeight(20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section with Shop Image
            Container(
              height: getProportionateScreenHeight(420),
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("${Constants.BASE_URL}/${widget.model.logo}"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -30),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(getProportionateScreenHeight(30)),
                    topRight: Radius.circular(getProportionateScreenHeight(30)),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(getProportionateScreenWidth(24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shop Info Section
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ColorManager.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ColorManager.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                  "${Constants.BASE_URL}/${widget.model.logo}"),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  kTextBentonSansMed(
                                    widget.model.businessName ?? '',
                                    fontSize: getProportionateScreenHeight(18),
                                    color: ColorManager.primary,
                                  ),
                                  SizedBox(height: 4),
                                  kTextBentonSansReg(
                                    'Owner: ${widget.model.ownerName ?? "N/A"}',
                                    fontSize: getProportionateScreenHeight(14),
                                    color: ColorManager.textGrey,
                                  ),
                                  SizedBox(height: 4),
                                  kTextBentonSansReg(
                                    'Sehr Code: ${widget.model.sehrCode ?? "N/A"}',
                                    fontSize: getProportionateScreenHeight(14),
                                    color: ColorManager.textGrey,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(32)),

                      // Amount Input
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: ColorManager.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: ColorManager.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            kTextBentonSansMed(
                              'Enter Amount',
                              fontSize: getProportionateScreenHeight(16),
                              color: ColorManager.primary,
                            ),
                            SizedBox(height: 16),
                            TextField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: getProportionateScreenHeight(24),
                                color: ColorManager.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Rs. ",
                                    style: TextStyle(
                                      color: ColorManager.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: getProportionateScreenHeight(24),
                                    ),
                                  ),
                                ),
                                hintText: '0',
                                hintStyle: TextStyle(
                                  color: ColorManager.textGrey.withOpacity(0.5),
                                  fontSize: getProportionateScreenHeight(24),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(32)),

                      // Verify Order Button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade900,
                              Colors.green.shade500,
                              Colors.green.shade900,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.25),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        width: double.infinity,
                        child: AppButtonWidget(
                          ontap: () async {
                            if (_amountController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter amount'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            
                            try {
                              var response = await http.post(
                                Uri.parse("${Constants.BASE_URL}${Constants.PLACE_ORDER}"),
                                headers: {
                                  'Content-Type': 'application/json'
                                },
                                body: jsonEncode({
                                  "shopid": widget.model.id.toString(),
                                  "userid": widget.identifier.toString(),
                                  "amount": int.parse(_amountController.text)
                                })
                              );
                              print(response.body);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OrderProcessingView()
                                ),
                              );
                            } catch (e) {
                              print(e.toString());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString()))
                              );
                            }
                          },
                          height: getProportionateScreenHeight(50),
                          borderRadius: getProportionateScreenHeight(12),
                          text: 'Verify Order',
                          textSize: getProportionateScreenHeight(16),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
