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
      appBar: AppBar(
        backgroundColor: ColorManager.home_button,
        title: const Text("User List"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return  Center(child: loadingSpinkit(ColorManager.gradient1, 80));
        }

        if (controller.users.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 15,
            dataRowHeight: 60,
            headingRowHeight: 80,
            headingRowColor: MaterialStateProperty.resolveWith((states) => Colors.grey.shade200),
            dividerThickness: 1.5,
            border: TableBorder(
              horizontalInside: BorderSide(
                width: 0.5,
                color: Colors.grey.shade300,
              ),
            ),
            columns: const [
              DataColumn(
                label: Text("Sr No", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              DataColumn(
                label: Text("Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              DataColumn(
                label: Text("Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              DataColumn(
                label: Text("Spending", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
            rows: controller.users.asMap().entries.map((entry) {
              int index = entry.key;
              SpecialPackageUserModel user = entry.value;
              return DataRow(
                color: MaterialStateProperty.resolveWith<Color?>(
                        (states) => index % 2 == 0 ? Colors.grey.shade50 : Colors.grey.shade100),
                cells: [
                  DataCell(Text((index + 1).toString())),
                  DataCell(Text(user.name, style: const TextStyle(fontWeight: FontWeight.w500))),
                  DataCell(Text(user.address)),
                  DataCell(Text(user.totalSpendings.toString(), style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green))),
                ],
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}
