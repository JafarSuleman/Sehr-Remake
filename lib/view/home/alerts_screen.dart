import 'package:flutter/material.dart';

import '../../utils/color_manager.dart';
import '../../utils/text_manager.dart';

class AlertScreen extends StatelessWidget {
  AlertScreen({super.key});
  List<String> _alerts = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.shade900,
                  Colors.green.shade500,
                  Colors.green.shade900,
                ],
              ),
            ),
            child: AppBar(
              title: Text(
                "Sehr Alerts",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              elevation: 4,
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
          ),
        ),
      ),
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
        child: SafeArea(
          child: _alerts.isEmpty
              ? Center(
                  child: Text(
                    "No Alerts Yet !",
                    style: TextStyleManager.mediumTextStyle(
                        fontSize: 16, color: ColorManager.textGrey),
                  ),
                )
              : ListView.builder(
                  itemCount: 3,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Alert Title Example",
                              style: TextStyleManager.boldTextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                            Text(
                              "6 Sep , 2023",
                              style: TextStyleManager.boldTextStyle(
                                  fontSize: 14, color: Colors.black54),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged",
                          style: TextStyleManager.regularTextStyle(
                              fontSize: 14, color: Colors.black87),
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
