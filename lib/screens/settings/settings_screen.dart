import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:when_the_last_time/components/custom_app_bar.dart';
import 'package:when_the_last_time/components/list_item.dart';
import 'package:when_the_last_time/models/theme/theme_provider.dart';

class Settings extends StatefulWidget {
  static String routeName = "/settings";

  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'الاعدادات',
      ),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    ListItem(
                      title: const Text('عن التطبيق'),
                      leading: const Icon(Icons.info_outline_rounded),
                      trailing: Icon(Icons.chevron_right,
                          color: Theme.of(context).colorScheme.primary),
                      onTap: () {
                        Navigator.pushNamed(context, "/about");
                      },
                    ),
                    ListItem(
                      title: const Text('المظهر الليلي'),
                      leading: const Icon(Icons.mode_night_outlined),
                      trailing: Switch.adaptive(
                        value:
                            Provider.of<ThemeProvider>(context, listen: false)
                                .isDarkMode,
                        activeColor: Theme.of(context).colorScheme.primary,
                        onChanged: (bool value) => {
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleTheme(value)
                        },
                      ),
                    ),
                    // ListItem(
                    //   title: const Text('تواصل معنا'),

                    //   trailingIcon: Icons.chat_outlined,
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => ContactScreen(

                    //                 )));
                    //   },
                    // ),
                    // CustomListTile(
                    //   title: 'شرح التطبيق',
                    //   icon: Icons.description_outlined,
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => OnBoarding(
                    //                   updateOnBoarding: () =>
                    //                       {Navigator.pop(context)},
                    //                 )));
                    //   },
                    //   isNavigation: true,
                    // ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
