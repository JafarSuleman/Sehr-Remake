// import 'package:flutter/material.dart';

// import '../utils/app/constant.dart';
// import '../utils/asset_manager.dart';
// import '../utils/color_manager.dart';
// import '../utils/size_config.dart';

// import 'app_button_widget.dart';

// class RecentOrdersBuilder extends StatelessWidget {
//   const RecentOrdersBuilder({
//     Key? key,
//     // required this.name,
//     // required this.category,
//     // required this.distance,
//     // required this.onFavourite,
//     // required this.onDetail,
//     // required this.isFavourite,
//     required this.items,
//   }) : super(key: key);
//   // final String name;
//   // final String category;
//   // final String distance;
//   // final bool isFavourite;
//   // final void Function() onFavourite;
//   // final void Function() onDetail;
//   final List<ShopDataModel> items;

//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       shrinkWrap: true,
//       itemCount: items.length,
//       separatorBuilder: (context, index) => buildVerticleSpace(10),
//       padding: EdgeInsets.only(
//         bottom: getProportionateScreenHeight(100),
//       ),
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) => ListTile(
//         tileColor: ColorManager.white,
//         contentPadding: EdgeInsets.symmetric(
//           horizontal: getProportionateScreenWidth(12),
//           vertical: getProportionateScreenHeight(10),
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(
//             getProportionateScreenHeight(22),
//           ),
//         ),
//         leading: Image.asset(
//           AppImages.menu,
//           height: getProportionateScreenHeight(56.5),
//           width: getProportionateScreenHeight(56.5),
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             kTextBentonSansMed(
//               items[index].shopName,
//               fontSize: getProportionateScreenHeight(15),
//             ),
//             buildVerticleSpace(3),
//             kTextBentonSansReg(
//               items[index].shopCategory,
//               color: ColorManager.textGrey.withOpacity(0.8),
//               letterSpacing: getProportionateScreenWidth(0.5),
//             ),
//             buildVerticleSpace(3),
//             kTextBentonSansReg(
//               '8km away',
//               color: ColorManager.textGrey.withOpacity(0.8),
//               fontSize: getProportionateScreenHeight(10),
//               letterSpacing: getProportionateScreenWidth(0.5),
//             ),
//           ],
//         ),
//         trailing: Consumer<HomeViewModel>(
//           builder: (context, value, child) => Column(
//             children: [
//               InkWell(
//                 onTap: () => {},
//                 splashColor: ColorManager.transparent,
//                 borderRadius: BorderRadius.circular(40),
//                 child: Icon(
//                   items[index].isFavourite
//                       ? Icons.favorite_rounded
//                       : Icons.favorite_border_rounded,
//                   size: getProportionateScreenHeight(20),
//                   color: items[index].isFavourite ? ColorManager.error : null,
//                 ),
//               ),
//               const Spacer(),
//               AppButtonWidget(
//                 ontap: () {
//                   showModalBottomSheet(
//                     context: context,
//                     isScrollControlled: true,
//                     backgroundColor: ColorManager.transparent,
//                     builder: (ctx) => Text("data"),
//                   );
//                 },
//                 height: getProportionateScreenHeight(26),
//                 width: getProportionateScreenWidth(72),
//                 borderRadius: getProportionateScreenHeight(18),
//                 text: 'Detail',
//                 textSize: getProportionateScreenHeight(12),
//                 letterSpacing: getProportionateScreenWidth(0.5),
//               ),
//               buildVerticleSpace(5),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
