import 'package:flutter/material.dart';

import 'package:when_the_last_time/components/custom_app_bar.dart';
import 'package:when_the_last_time/components/list_item.dart';

class AboutApp extends StatelessWidget {
  static String routeName = "/about";
  const AboutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'عن التطبيق',
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const Image(
                  image: AssetImage(
                      'assets/images/gradients/magicpattern-8h_tctpq4h0-unsplash.jpg'),
                  height: 100,
                ),
              ),
              const SizedBox(height: 20),
              const Text("تطبيق متى آخر مرة", style: TextStyle(fontSize: 14)),
              const SizedBox(height: 5),
              const Text("الإصدار 1.0.1",
                  style: TextStyle(fontSize: 14, color: Color(0xffae8f74))),
              const SizedBox(height: 20),
              const ListItem(
                title: Text(
                  textAlign: TextAlign.right,
                  "تطبيق تضيف فيه حدث ثم يضاف تاريخ الإضافة. ثم يخبرك كم مضى من اخر مرة زرت او عملت الحدث.. مثلا الحدث (زيارة فلان) بتاريخ 12-10-1443، واليوم 17، فالمخرج سيكون مضى 5 أيام على أخر زيارة لفلان",
                  style: TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
        ));
  }
}
