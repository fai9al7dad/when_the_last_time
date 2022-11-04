import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:when_the_last_time/models/events/events_provider.dart';
import 'package:when_the_last_time/models/theme/theme_provider.dart';
import 'package:when_the_last_time/screens/deleted_events/deleted_events.dart';
import 'package:when_the_last_time/screens/events_details/events_details.dart';
import 'package:when_the_last_time/screens/home_page/home_page.dart';
import 'package:when_the_last_time/screens/init_app_loading.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ChangeNotifierProvider<EventsProvider>(create: (_) => EventsProvider()),
    ],
    child: const MyApp(), // Wrap your app
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => MaterialApp(
        title: 'when the last time',
        // locale: const Locale('ar', 'EG'),
        initialRoute: InitAppLoading.routeName,
        debugShowCheckedModeBanner: false,
        themeMode: themeProvider.themeMode,
        theme: MyTheme.lightTheme,
        darkTheme: MyTheme.darkTheme,
        routes: {
          InitAppLoading.routeName: (context) => const InitAppLoading(),
          HomePage.routeName: (context) => const HomePage(),
          DeletedEvents.routeName: (context) => const DeletedEvents(),
          EventsDetails.routeName: (context) => const EventsDetails(),
        },
      ),
    );
  }
}
