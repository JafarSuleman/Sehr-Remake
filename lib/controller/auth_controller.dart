import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../utils/app/constant.dart';
import '../view/profile/phone_otp_screen.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  Future<void> sendWhatsAppOTP(BuildContext context, String phoneNumber, String? specialPackageName, String? selectedLocationId) async {
    isLoading.value = true;

    String phone = phoneNumber.startsWith('0')
        ? phoneNumber.replaceFirst('0', '+92')
        : phoneNumber;

    try {
      final response = await http.post(
        Uri.parse('${Constants.BASE_URL}${Constants.SEND_WHATSAPP_OTP}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'whatsappNumber': phone}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("OTP sent via WhatsApp")),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => phoneNumberVerificationCodeView(
                specialPackageName: specialPackageName,
                selectedLocationId: selectedLocationId,
                phone: phone,
                isWhatsApp: true,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to send WhatsApp OTP.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send WhatsApp OTP.")),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error sending WhatsApp OTP.")),
      );
    } finally {
      isLoading.value = false;
    }
  }
}

