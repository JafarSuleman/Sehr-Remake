import 'package:flutter/material.dart';
import 'package:sehr_remake/utils/color_manager.dart';

import '../../utils/text_manager.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.gradient2,
        title: Text('About Us'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Logo centered at the top
                Container(
                  width: 200, // Adjust the width as needed
                  height: 200, // Adjust the height as needed
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/logo.png")),
                      shape: BoxShape.circle,
                      color: Colors.white
                      // Change the color or use an Image widget for your logo
                      ),
                ),

                // Title
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'سحر کیا ہے؟',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Content
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.end, // Align text to the left
                  children: [
                    Text(
                      'سحر (SEHR) ایک سادہ معاشی انقلاب کا فارمولا ہے.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'SEHR = Sober Economic and Housing Revolution',
                      style: TextStyleManager.regularTextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'اس میں عام عوام اور خواص کو مکانوں کی قلت کا جو سامنا ہے اس کو کسی حد تک پورا کرنے کی کوشش کی جائے گی۔',
                      style: TextStyleManager.regularTextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'اس میں شامل ہونے والے تمام ممبران کو ایک مکان بالکل فری دیا جائے گا۔',
                      style: TextStyleManager.regularTextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'کسی بھی شخص سے مکان کے حوالے سے نہ کوئی فیس لی جائے گی۔',
                      style: TextStyleManager.regularTextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'نہ عطیہ نه تحفہ اور نہ ہی انویسٹمنٹ لی جائے گی۔',
                      style: TextStyleManager.regularTextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'یہ ایک انتہائی سادہ فارمولا ہے کہ صرف اپنی ماہوار خریداری کو ایک لائن پر لاتے ہوئے سحر کوڈ والی شاپس سے کریں تو آپ کی اپنی ضروریات کو پورا کرنے کے لئے خرچ کی گئی رقم آپ کے مکان کی قسط تصور ہوگی۔',
                      style: TextStyleManager.regularTextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'کل 240 قسطیں ہوں گی، ایک قسط 10 ہزار روہے کی ہوگی۔',
                      style: TextStyleManager.regularTextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'یہ وہ رقم ہوگی جو آپ اپنی روز مرہ کی خریداری سے خرچ کرتے ہیں۔',
                      style: TextStyleManager.regularTextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'آپ نے سحر پروجیکٹ کو ایک روپیہ بھی ادا نہیں کرنا .',
                      style: TextStyleManager.regularTextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'کسی بھی شعبہ سے تعلق رکھنے والے افراد اس میں شامل ہو کر حیران کن فوائد حاصل کر سکتے ہیں ۔',
                      style: TextStyleManager.regularTextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'ہر شعبہ کے لیے آفرز نہ صرف حیران کن ہے بلکہ ناقابل عمل نظر آتی ہے، یہی اس پروجیکٹ کے منفرد یا innovative ہونے کا ثبوت بھی ہے۔',
                      style: TextStyleManager.regularTextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'اس پروجیکٹ کو ڈیزائن کرنے والے پروفیسر منور احمد ملک ہیں جو پہلے ہی 50 سے زائد ایجادات کے موجد ہیں۔',
                      style: TextStyleManager.regularTextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'پاکستان انجینئرنگ کونسل اسلام آباد کے تھنک ٹینک کے ممبر رہ چکے ہیں۔',
                      style: TextStyleManager.regularTextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'نیشنل لیول پر بہت سے پروجیکٹ ڈیزائن کر چکے ہیں پچھلے 20 سال سے اس پروجیکٹ کو ترتیب دے رہے تھے ، اسے اکنامکس کے ماہرین قابل عمل قرار دے چکے ہیں ۔',
                      style: TextStyleManager.regularTextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'یہ مکان ہر تحصیل میں پہلے سے موجود سوسائٹیز یا کالونیز میں پلاٹ لے کر بنائے جائیں گے اور پبلک کو فری دیئے جائیں گے۔',
                      style: TextStyleManager.regularTextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'یہ منصوبہ اپنے اندر ایک معاشی انقلاب بھی رکھتا ہے جب اتنی بڑی معاشی سرگرمی ایک لائن پر آجائے گی تو قیمتیں بھی کنٹرول میں آجائیں گی مہنگائی ختم ہو کر منفی ہو جائے گی ان شاءاللہ، ڈالر کا ریٹ بھی کنٹرول ہو جائے گا اور بیرونی قرضوں سے بھی نجات ملے گی ان شاءاللہ ۔',
                      style: TextStyleManager.regularTextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
