import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/loading_widget.dart';
import '../../../controller/user_view_list_controller.dart';
import '../../../model/user_table_model.dart';
import '../../../utils/color_manager.dart';

class ViewListScreen extends StatelessWidget {
  const ViewListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserTableController controller = Get.find();

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
              title: const Text(
                "User List",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              elevation: 4,
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
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
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: loadingSpinkit(ColorManager.gradient1, 80));
          }

          if (controller.users.isEmpty) {
            return const Center(
              child: Text(
                "No users found",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade900.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DataTable(
                columnSpacing: 15,
                dataRowHeight: 60,
                headingRowHeight: 80,
                headingRowColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.green.shade50,
                ),
                dividerThickness: 1.5,
                border: TableBorder(
                  borderRadius: BorderRadius.circular(15),
                  horizontalInside: BorderSide(
                    width: 0.5,
                    color: Colors.green.shade100,
                  ),
                ),
                columns: [
                  DataColumn(
                    label: Text(
                      "Sr No",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Address",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Spending",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ),
                ],
                rows: controller.users.asMap().entries.map((entry) {
                  int index = entry.key;
                  SpecialPackageUserModel user = entry.value;
                  return DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                      (states) => index % 2 == 0
                          ? Colors.white
                          : Colors.green.shade50.withOpacity(0.3),
                    ),
                    cells: [
                      DataCell(Text(
                        (index + 1).toString(),
                        style: TextStyle(color: Colors.green.shade800),
                      )),
                      DataCell(Text(
                        user.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.green.shade800,
                        ),
                      )),
                      DataCell(Text(
                        user.address,
                        style: TextStyle(color: Colors.green.shade800),
                      )),
                      DataCell(Text(
                        user.totalSpendings.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      )),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        }),
      ),
    );
  }
}
