import 'package:flutter/material.dart';

import '../../utils/color_manager.dart';
import '../../utils/text_manager.dart';

class AlertScreen extends StatelessWidget {
  AlertScreen({super.key});
  List<String> _alerts = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sehr Alerts",
            style: TextStyleManager.mediumTextStyle(
                color: Colors.white, fontSize: 24)),
        backgroundColor: ColorManager.gradient1,
      ),
      body: SafeArea(
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
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: ColorManager.gradient2),
                    padding: EdgeInsets.all(10),
                    margin: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Alert Title Example",
                              style: TextStyleManager.boldTextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                            Text(
                              "6 Sep , 2023",
                              style: TextStyleManager.boldTextStyle(
                                  fontSize: 14, color: Colors.white),
                            )
                          ],
                        ),
                        Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged",
                          style: TextStyleManager.regularTextStyle(
                              fontSize: 14, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )),
    );
  }
}
